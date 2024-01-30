import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/class_generators_util.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

Method buildAbstractCopyWithMethod(
  String className,
  ClassDefinition classDefinition,
  List<SerializableModelFieldDefinition> fields,
  bool serverCode,
  GeneratorConfig config,
) {
  return Method((methodBuilder) {
    methodBuilder
      ..name = 'copyWith'
      ..optionalParameters.addAll(
        _buildAbstractCopyWithParameters(
            classDefinition, fields, serverCode, config),
      )
      ..returns = refer(className);
  });
}

Method buildCopyWithMethod(
  ClassDefinition classDefinition,
  List<SerializableModelFieldDefinition> fields,
  bool serverCode,
  GeneratorConfig config,
) {
  return Method(
    (m) {
      m
        ..name = 'copyWith'
        ..annotations.add(refer('override'))
        ..optionalParameters.addAll(
          fields.where((field) => field.shouldIncludeField(serverCode)).map(
            (field) {
              var fieldType = field.type.reference(
                serverCode,
                nullable: true,
                subDirParts: classDefinition.subDirParts,
                config: config,
              );

              var type = field.type.nullable ? refer('Object?') : fieldType;
              var defaultValue =
                  field.type.nullable ? const Code('_Undefined') : null;

              return Parameter((p) {
                p
                  ..name = field.name
                  ..named = true
                  ..type = type
                  ..defaultTo = defaultValue;
              });
            },
          ),
        )
        ..returns = refer(classDefinition.className)
        ..body = Block.of([
          ...fields
              .where((field) => field.shouldIncludeField(serverCode))
              .where((field) => field.relation is ForeignRelationDefinition)
              .map((field) => relationForeignKeyObjectIdSyncCheck(
                    field,
                    classDefinition.subDirParts,
                    serverCode,
                    config,
                  )),
          ...fields
              .where((field) => field.shouldIncludeField(serverCode))
              .where((field) => field.relation != null)
              .map<Block>((field) {
            var relation = field.relation;
            return Block.of([
              declareVar('\$${field.name}')
                  .assign(_copyWithFieldExpression(
                      field, classDefinition.subDirParts, serverCode, config))
                  .statement,
              if (relation is ForeignRelationDefinition &&
                  relation.containerField != null)
                refer('\$${field.name}')
                    .assign(refer(relation.containerField!.name)
                        .isA(relation.containerField!.type.reference(
                          serverCode,
                          config: config,
                          subDirParts: classDefinition.subDirParts,
                        ))
                        .conditional(
                            refer(relation.containerField!.name)
                                .nullSafeProperty(defaultPrimaryKeyName),
                            refer('\$${field.name}')))
                    .statement,
            ]);
          }),
          refer(classDefinition.className)
              .call(
                [],
                _buildCopyWithAssignment(
                  classDefinition,
                  fields,
                  serverCode,
                  config,
                ),
              )
              .returned
              .statement
        ]);
      ;
    },
  );
}

List<Parameter> _buildAbstractCopyWithParameters(
  ClassDefinition classDefinition,
  List<SerializableModelFieldDefinition> fields,
  bool serverCode,
  GeneratorConfig config,
) {
  return fields
      .where((field) => field.shouldIncludeField(serverCode))
      .map((field) {
    var type = field.type.reference(
      serverCode,
      nullable: true,
      subDirParts: classDefinition.subDirParts,
      config: config,
    );

    return Parameter(
      (p) => p
        ..named = true
        ..type = type
        ..name = field.name,
    );
  }).toList();
}

Map<String, Expression> _buildCopyWithAssignment(
  ClassDefinition classDefinition,
  List<SerializableModelFieldDefinition> fields,
  bool serverCode,
  GeneratorConfig config,
) {
  return fields.where((field) => field.shouldIncludeField(serverCode)).fold({},
      (map, field) {
    Expression valueDefinition;
    if (field.relation != null) {
      valueDefinition = refer('\$${field.name}');
    } else {
      valueDefinition = _copyWithFieldExpression(
        field,
        classDefinition.subDirParts,
        serverCode,
        config,
      );
    }

    return {
      ...map,
      field.name: valueDefinition,
    };
  });
}

Expression _copyWithFieldExpression(
  SerializableModelFieldDefinition field,
  List<String> subDirParts,
  bool serverCode,
  GeneratorConfig config,
) {
  Expression assignment;

  if ((field.type.isEnumType ||
      noneMutableTypeNames.contains(field.type.className))) {
    assignment = refer('this').property(field.name);
  } else if (clonableTypeNames.contains(field.type.className)) {
    assignment = _buildMaybeNullMethodCall(field, 'clone');
  } else {
    var relation = field.relation;
    var params = <String, Expression>{};
    if (relation is ObjectRelationDefinition) {
      var foreignContainerField = relation.foreignContainerField;
      if (foreignContainerField != null) {
        params[foreignContainerField.name] = refer('this');
      }
    }

    assignment = _buildMaybeNullMethodCall(field, 'copyWith');
  }

  Expression valueDefinition;

  if (field.type.nullable) {
    valueDefinition = refer(field.name)
        .isA(field.type.reference(
          serverCode,
          nullable: field.type.nullable,
          subDirParts: subDirParts,
          config: config,
        ))
        .conditional(
          refer(field.name),
          assignment,
        );
  } else {
    valueDefinition = refer(field.name).ifNullThen(
      assignment,
    );
  }

  return valueDefinition;
}

Expression _buildMaybeNullMethodCall(
  SerializableModelFieldDefinition field,
  String methodName, {
  Map<String, Expression> namedParams = const {},
}) {
  if (field.type.nullable) {
    return refer('this')
        .property(field.name)
        .nullSafeProperty(methodName)
        .call([], namedParams);
  } else {
    return refer('this')
        .property(field.name)
        .property(methodName)
        .call([], namedParams);
  }
}
