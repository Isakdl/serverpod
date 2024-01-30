import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/shared.dart';

String createFieldName(
  bool serverCode,
  SerializableModelFieldDefinition field,
) {
  if (field.hiddenSerializableField(serverCode)) {
    return createImplicitFieldName(field.name);
  }

  return field.name;
}

Block ifStatement(Expression conditional, Code body, {bool inline = false}) {
  if (inline) {
    return Block.of([
      const Code('if ('),
      conditional.code,
      const Code(') '),
      body,
    ]);
  }

  return Block.of([
    const Code('if ('),
    conditional.code,
    const Code(') {'),
    body,
    const Code('}'),
  ]);
}

Reference createSerializableFieldNameReference(
  bool serverCode,
  SerializableModelFieldDefinition field,
) {
  String prefix = '';

  if (field.relation != null) {
    prefix += '_';
  }

  // TODO do I want to do this? i.e. double __ ? might not be needed? maybe it is...
  if (field.hiddenSerializableField(serverCode) &&
      !field.name.startsWith('_')) {
    prefix += '_';
  }

  return refer('$prefix${field.name}');
}

String createForeignFieldName(ListRelationDefinition relation) {
  if (relation.implicitForeignField) {
    return createImplicitFieldName(relation.foreignFieldName);
  }

  return relation.foreignFieldName;
}

String createImplicitFieldName(String fieldName) {
  return '\$$fieldName';
}

TypeReference typeWhereExpressionBuilder(
  String className,
  bool serverCode, {
  nullable = true,
}) {
  return _typeWithTableCallback(
    className,
    'WhereExpressionBuilder',
    serverCode,
    nullable: nullable,
  );
}

TypeReference typeOrderByBuilder(
  String className,
  bool serverCode, {
  nullable = true,
}) {
  return _typeWithTableCallback(
    className,
    'OrderByBuilder',
    serverCode,
    nullable: nullable,
  );
}

TypeReference typeOrderByListBuilder(
  String className,
  bool serverCode, {
  nullable = true,
}) {
  return _typeWithTableCallback(
    className,
    'OrderByListBuilder',
    serverCode,
    nullable: nullable,
  );
}

TypeReference _typeWithTableCallback(
  String className,
  String typeName,
  bool serverCode, {
  nullable = true,
}) {
  return TypeReference(
    (t) => t
      ..symbol = typeName
      ..types.addAll([
        refer('${className}Table'),
      ])
      ..url = serverpodUrl(serverCode)
      ..isNullable = nullable,
  );
}

Block relationForeignKeyObjectIdSyncCheck(
  SerializableModelFieldDefinition field,
  List<String> subDirParts,
  bool serverCode,
  GeneratorConfig config,
) {
  var relation = field.relation;
  if (relation is! ForeignRelationDefinition) {
    throw ArgumentError(
      'This method is only valid to call for fields with a Foreign key relation.',
    );
  }

  var containerField = relation.containerField;
  if (containerField == null) {
    return Block();
  }

  var checkIdFieldSync = refer(field.name)
      .notEqualTo(refer(containerField.name).property(defaultPrimaryKeyName));

  var syncCondition = typeCheckField(
    containerField,
    subDirParts,
    serverCode,
    config,
  ).and(checkIdFieldSync);

  Expression condition;

  if (field.type.nullable) {
    condition = typeCheckField(
      field,
      subDirParts,
      serverCode,
      config,
    ).and(syncCondition);
  } else {
    condition = syncCondition;
  }

  var throwBlock = Code('''throw ArgumentError(
  'Inconsistent values for ${field.name} (\$${field.name}) and ${containerField.name}.$defaultPrimaryKeyName (\${${containerField.name}.$defaultPrimaryKeyName})',
);''');

  return ifStatement(condition, throwBlock);
}

Expression typeCheckField(
  SerializableModelFieldDefinition field,
  List<String> subDirParts,
  bool serverCode,
  GeneratorConfig config,
) {
  return refer(field.name).isA(field.type.reference(serverCode,
      subDirParts: subDirParts, config: config, nullable: false));
}
