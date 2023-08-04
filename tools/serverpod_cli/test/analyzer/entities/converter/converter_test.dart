import 'package:serverpod_cli/src/analyzer/entities/converter/converter.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

main() {
  test(' ', () {
    var document = loadYamlDocument(
      '''
      field: String, !relation=value
      ''',
    );

    YamlMap node = document.contents as YamlMap;

    var contentNode = node.nodes['field']!;
    var content = contentNode.value;

    var yamlMap = convertStringifiedNestedNodesToYamlMap(
      content,
      contentNode.span,
      firstKey: 'type',
      onDuplicateKey: (key, span) {
        print('Duplicate key: $key');
      },
      onNegatedKeyWithValue: (key, span) {
        print('Negated key with value: $key');
      },
    );
  });

  
  test(' ', () {
    var document = loadYamlDocument(
      '''
      field: String, relation(!key=value, duplicated, duplicated)
      ''',
    );

    YamlMap node = document.contents as YamlMap;

    var contentNode = node.nodes['field']!;
    var content = contentNode.value;

    var yamlMap = convertStringifiedNestedNodesToYamlMap(
      content,
      contentNode.span,
      firstKey: 'type',
      onDuplicateKey: (key, span) {
        print('Duplicate key: $key');
      },
      onNegatedKeyWithValue: (key, span) {
        print('Negated key with value: $key');
      },
    );
  });
}
