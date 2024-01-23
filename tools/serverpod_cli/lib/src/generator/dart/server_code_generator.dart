import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generator/dart/library_generators/model_library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/library_generator.dart';

class PartOfAllocator implements Allocator {
  static final _doNotPrefix = ['dart:core'];

  final _imports = <String, int>{};
  var _keys = 1;

  PartOfAllocator(List<String>? doNotPrefix) {
    _doNotPrefix.addAll(doNotPrefix ?? []);
  }

  @override
  String allocate(Reference reference) {
    final symbol = reference.symbol;
    final url = reference.url;
    if (url == null || _doNotPrefix.contains(url)) {
      return symbol!;
    }
    return '_i${_imports.putIfAbsent(url, _nextKey)}.$symbol';
  }

  int _nextKey() => _keys++;

  @override
  Iterable<Directive> get imports => [];
}

class PartAllocator implements Allocator {
  PartOfAllocator _partOfAllocator;

  PartAllocator._(this._partOfAllocator);

  factory PartAllocator(PartOfAllocator partOfAllocator) {
    return PartAllocator._(partOfAllocator);
  }

  @override
  String allocate(Reference reference) {
    return _partOfAllocator.allocate(reference);
  }

  @override
  Iterable<Directive> get imports => _partOfAllocator._imports.keys.map(
        (u) => Directive.import(u, as: '_i${_partOfAllocator._imports[u]}'),
      );
}

/// A [CodeGenerator] that generates the server side dart code of a
/// serverpod project.
class DartServerCodeGenerator extends CodeGenerator {
  const DartServerCodeGenerator();

  @override
  Map<String, String> generateSerializableModelsCode({
    required List<SerializableModelDefinition> models,
    required GeneratorConfig config,
  }) {
    var serverSideGenerator = SerializableModelLibraryGenerator(
      serverCode: true,
      config: config,
    );

    var partOfAllocator = PartOfAllocator(['models.dart']);

    return {
      for (var protocolFile in models)
        p.joinAll([
          ...config.generatedServeModelPathParts,
          ...protocolFile.subDirParts,
          '${protocolFile.fileName}.dart'
        ]): serverSideGenerator
            .generateModelLibrary(protocolFile)
            .generatePartOfCode(allocator: partOfAllocator),
      p.joinAll([...config.generatedServeModelPathParts, 'models.dart']):
          Library((l) => l
                ..directives.addAll(models.map((protocolFile) => Directive.part(
                        p.joinAll([
                      ...protocolFile.subDirParts,
                      '${protocolFile.fileName}.dart'
                    ]))))
                ..name = 'models'
                ..body.add(
                    Class((classBuilder) => classBuilder.name = '_Undefined')))
              .generatePartOfCode(allocator: PartAllocator(partOfAllocator))
    };
  }

  @override
  Map<String, String> generateProtocolCode({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) {
    var serverClassGenerator = LibraryGenerator(
      serverCode: true,
      protocolDefinition: protocolDefinition,
      config: config,
    );

    return {
      p.joinAll([...config.generatedServeModelPathParts, 'protocol.dart']):
          serverClassGenerator.generateProtocol().generateCode(),
      p.joinAll([...config.generatedServeModelPathParts, 'endpoints.dart']):
          serverClassGenerator.generateServerEndpointDispatch().generateCode(),
    };
  }
}
