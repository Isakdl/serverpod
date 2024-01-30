import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/class_generators_util.dart';

List<Method> buildModelClassSettersAndGetters(
  List<SerializableModelFieldDefinition> fields,
  List<String> subDirParts,
  bool serverCode,
  GeneratorConfig config,
) {
  var relationFields = fields
      .where((f) => f.shouldIncludeField(serverCode))
      .where((f) => f.relation != null);

  return relationFields.expand((field) {
    return [
      _buildFieldGetter(field, subDirParts, serverCode, config),
      if (field.relation is ForeignRelationDefinition)
        _buildForeignFieldSetter(field, subDirParts, serverCode, config),
      if (field.relation is ObjectRelationDefinition)
        _buildObjectFieldSetter(field, subDirParts, serverCode, config),
      if (field.relation is ListRelationDefinition)
        _buildListFieldSetter(field, subDirParts, serverCode, config),
    ];
  }).toList();
}

Method _buildFieldGetter(
  SerializableModelFieldDefinition field,
  List<String> subDirParts,
  bool serverCode,
  GeneratorConfig config,
) {
  return Method((m) {
    m
      ..name = field.name
      ..type = MethodType.getter
      ..lambda = true
      ..returns = field.type.reference(
        serverCode,
        subDirParts: subDirParts,
        config: config,
      )
      ..body = createSerializableFieldNameReference(
        serverCode,
        field,
      ).code;
  });
}

Method _buildForeignFieldSetter(
  SerializableModelFieldDefinition field,
  List<String> subDirParts,
  bool serverCode,
  GeneratorConfig config,
) {
  var relation = field.relation as ForeignRelationDefinition;
  var containerField = relation.containerField;

  var body = Block.of([
    ifStatement(
      createSerializableFieldNameReference(
        serverCode,
        field,
      ).equalTo(refer(field.name)),
      const Code('return;'),
    ),
    const Code(''),
    createSerializableFieldNameReference(
      serverCode,
      field,
    ).assign(refer(field.name)).statement,
    if (containerField != null)
      createSerializableFieldNameReference(
        serverCode,
        containerField,
      ).assign(refer('null')).statement,
  ]);

  return Method((m) {
    m
      ..name = field.name
      ..type = MethodType.setter
      ..requiredParameters.add(
        Parameter((p) {
          p
            ..name = field.name
            ..type = field.type.reference(
              serverCode,
              subDirParts: subDirParts,
              config: config,
            );
        }),
      )
      ..body = body;
  });
}

Method _buildObjectFieldSetter(
  SerializableModelFieldDefinition field,
  List<String> subDirParts,
  bool serverCode,
  GeneratorConfig config,
) {
  var relation = field.relation as ObjectRelationDefinition;
  var foreignContainerField = relation.foreignContainerField;

  var body = Block.of([
    ifStatement(
      createSerializableFieldNameReference(
        serverCode,
        field,
      ).equalTo(refer(field.name)),
      const Code('return;'),
    ),
    const Code(''),
    if (!relation.nullableRelation)
      ifStatement(
          refer(field.name).notEqualTo(literalNull).and(refer(field.name)
              .property(defaultPrimaryKeyName)
              .equalTo(literalNull)),
          const Code('''throw ArgumentError(
  'Given object has no id set. Are yu sure it is saved in the database?',
);
''')),
    const Code(''),
    if (relation.isForeignKeyOrigin && relation.nullableRelation)
      refer(relation.fieldName)
          .assign(refer(field.name).nullSafeProperty(defaultPrimaryKeyName))
          .statement,
    if (relation.isForeignKeyOrigin && !relation.nullableRelation)
      ifStatement(
          refer(field.name).notEqualTo(literalNull),
          refer(relation.fieldName)
              .assign(refer(field.name).property(defaultPrimaryKeyName))
              .nullChecked
              .statement),
    createSerializableFieldNameReference(
      serverCode,
      field,
    ).assign(refer(field.name)).statement,
    // TODO might need to remove? Doesn't this cause a bug?
    if (!relation.isForeignKeyOrigin)
      createSerializableFieldNameReference(
        serverCode,
        field,
      )
          .nullSafeProperty(relation.foreignFieldName)
          .assign(refer('this').property(defaultPrimaryKeyName))
          .statement,
    const Code(''),
    if (foreignContainerField != null &&
        foreignContainerField.relation is! ListRelationDefinition)
      ifStatement(
          createSerializableFieldNameReference(
            serverCode,
            field,
          )
              .nullSafeProperty(foreignContainerField.name)
              .notEqualTo(refer('this')),
          createSerializableFieldNameReference(
            serverCode,
            field,
          )
              .nullSafeProperty(foreignContainerField.name)
              .assign(refer('this'))
              .statement),
  ]);

  return Method((m) {
    m
      ..name = field.name
      ..type = MethodType.setter
      ..requiredParameters.add(
        Parameter((p) {
          p
            ..name = field.name
            ..type = field.type.reference(
              serverCode,
              subDirParts: subDirParts,
              config: config,
            );
        }),
      )
      ..body = body;
  });
}

Method _buildListFieldSetter(
  SerializableModelFieldDefinition field,
  List<String> subDirParts,
  bool serverCode,
  GeneratorConfig config,
) {
  return Method((m) {
    m
      ..name = field.name
      ..type = MethodType.setter
      ..requiredParameters.add(
        Parameter((p) {
          p
            ..name = field.name
            ..type = field.type.reference(
              serverCode,
              subDirParts: subDirParts,
              config: config,
            );
        }),
      )
      ..body = createSerializableFieldNameReference(
        serverCode,
        field,
      ).assign(refer(field.name)).code;
  });
}
