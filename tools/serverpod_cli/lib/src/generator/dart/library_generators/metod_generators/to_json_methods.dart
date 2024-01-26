import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/class_generators_util.dart';
import 'package:serverpod_cli/src/generator/types.dart';

String _visitedParamName = '\$visited';
String _previousParamName = '\$previous';

String _visitedLocalName = '_visited';
String _previousLocalName = '_previousNode';

List<Method> buildToJsonMethods(
  List<SerializableModelFieldDefinition> fields,
  bool serverCode,
  String? tableName,
) {
  var fieldsToSerializeForClient =
      fields.where((field) => field.shouldSerializeField(serverCode));

  return [
    _buildModelClassToJsonMethod(),
    _buildModelClassInternalToJsonMethod(
      fieldsToSerializeForClient,
      serverCode,
      'toJson',
    ),
    if (serverCode && tableName != null)
      _buildModelClassToJsonForDatabaseMethod(fields, serverCode),
    if (serverCode) _buildModelClassAllToJsonMethod(),
    if (serverCode)
      _buildModelClassInternalToJsonMethod(
        fields,
        serverCode,
        'allToJson',
      ),
  ];
}

Method _buildModelClassAllToJsonMethod() {
  return Method(
    (m) => m
      ..returns = refer('Map<String,dynamic>')
      ..name = 'allToJson'
      ..annotations.add(refer('override'))
      ..lambda = true
      ..body = refer('internalAllToJson').call([]).code,
  );
}

Method _buildModelClassInternalToJsonMethod(
  Iterable<SerializableModelFieldDefinition> fields,
  bool serverCode,
  String toJsonMethodName,
) {
  return Method(
    (m) => m
      ..docs.addAll([
        '/// Internal serializer used by the framework.',
        '/// Use [$toJsonMethodName] instead. This method might be removed in the future in a none major version.',
      ])
      ..returns = refer('Map<String,dynamic>')
      ..name = 'internal${toJsonMethodName.pascalCase}'
      ..optionalParameters.addAll([
        Parameter(
          (p) => p
            ..name = _visitedParamName
            ..type = TypeReference(
              (t) => t
                ..isNullable = true
                ..symbol = 'Set<Object>',
            )
            ..named = true,
        ),
        Parameter(
          (p) => p
            ..name = _previousParamName
            ..type = TypeReference(
              (t) => t
                ..isNullable = true
                ..symbol = 'Object',
            )
            ..named = true,
        ),
      ])
      ..body =
          _createToJsonBodyFromFields(fields, serverCode, toJsonMethodName),
  );
}

Method _buildModelClassToJsonForDatabaseMethod(
  Iterable<SerializableModelFieldDefinition> fields,
  bool serverCode,
) {
  var serializableFields =
      fields.where((f) => f.shouldSerializeFieldForDatabase(serverCode));

  return Method(
    (m) {
      m.returns = refer('Map<String,dynamic>');
      m.name = 'toJsonForDatabase';
      m.annotations.addAll(
          [refer('override'), refer("Deprecated('Will be removed in 2.0.0')")]);

      m.body = literalMap(
        {
          for (var field in serializableFields)
            literalString(field.name):
                createSerializableFieldNameReference(serverCode, field)
        },
      ).returned.statement;
    },
  );
}

Method _buildModelClassToJsonMethod() {
  return Method(
    (m) {
      m.returns = refer('Map<String,dynamic>');
      m.name = 'toJson';
      m.annotations.add(refer('override'));

      m.body = refer('internalToJson').call([]).code;
    },
  );
}

Expression _toJsonCallConversionMethod(
  Reference fieldRef,
  SerializableModelFieldDefinition field,
  TypeDefinition fieldType,
  String toJsonMethodName,
) {
  if (fieldType.isSerializedValue) return fieldRef;

  Expression fieldExpression = fieldRef;

  var specialToJson = field.relation != null
      ? 'internal${toJsonMethodName.pascalCase}'
      : toJsonMethodName;

  var toJson = fieldType.isSerializedByExtension || fieldType.isEnumType
      ? 'toJson'
      : specialToJson;

  if (fieldType.nullable) {
    fieldExpression = fieldExpression.nullSafeProperty(toJson);
  } else {
    fieldExpression = fieldExpression.property(toJson);
  }

  Map<String, Expression> namedParams = {};

  if (fieldType.isListType && !fieldType.generics.first.isSerializedValue) {
    namedParams = {
      'valueToJson': Method(
        (p) => p
          ..lambda = true
          ..requiredParameters.add(
            Parameter((p) => p..name = 'v'),
          )
          ..body = _toJsonCallConversionMethod(
            refer('v'),
            field,
            fieldType.generics.first,
            toJsonMethodName,
          ).code,
      ).closure
    };
  } else if (fieldType.isMapType) {
    if (!fieldType.generics.first.isSerializedValue) {
      namedParams = {
        ...namedParams,
        'keyToJson': Method(
          (p) => p
            ..lambda = true
            ..requiredParameters.add(
              Parameter((p) => p..name = 'k'),
            )
            ..body = _toJsonCallConversionMethod(
              refer('k'),
              field,
              fieldType.generics.first,
              toJsonMethodName,
            ).code,
        ).closure
      };
    }
    if (!fieldType.generics.last.isSerializedValue) {
      namedParams = {
        ...namedParams,
        'valueToJson': Method(
          (p) => p
            ..lambda = true
            ..requiredParameters.add(
              Parameter((p) => p..name = 'v'),
            )
            ..body = _toJsonCallConversionMethod(
              refer('v'),
              field,
              fieldType.generics.last,
              toJsonMethodName,
            ).code,
        ).closure
      };
    }
  } else if (field.relation != null) {
    namedParams = {
      _visitedParamName: refer(_visitedLocalName),
      _previousParamName: refer('this'),
    };
  }

  return fieldExpression.call([], namedParams);
}

Code _createToJsonBodyFromFields(
  Iterable<SerializableModelFieldDefinition> fields,
  bool serverCode,
  String toJsonMethodName,
) {
  var map = fields.fold<Map<Code, Expression>>({}, (map, field) {
    var fieldName = createSerializableFieldNameReference(
      serverCode,
      field,
    );

    Expression fieldRef = _toJsonCallConversionMethod(
      fieldName,
      field,
      field.type,
      toJsonMethodName,
    );

    Expression? nullableCondition;
    Expression? relationCondition;

    if (field.type.nullable) {
      nullableCondition = fieldName.notEqualTo(literalNull);
    }

    if (field.relation != null &&
        field.relation is! ForeignRelationDefinition) {
      relationCondition =
          refer(_previousLocalName).notEqualTo(refer(field.name));
    }

    Expression? condition;

    if (nullableCondition != null && relationCondition != null) {
      condition = nullableCondition.and(relationCondition);
    } else if (nullableCondition != null) {
      condition = nullableCondition;
    } else if (relationCondition != null) {
      condition = relationCondition;
    }

    var mapKeyBuilder = BlockBuilder()
      ..statements.addAll([
        if (condition != null) const Code('if ('),
        if (condition != null) condition.code,
        if (condition != null) const Code(') '),
        literalString(field.name).code,
      ]);

    return {
      ...map,
      mapKeyBuilder.build(): fieldRef,
    };
  });

  var blockBuilder = BlockBuilder();

  if (fields.any(
    (f) => f.relation != null && f.relation is! ForeignRelationDefinition,
  )) {
    blockBuilder.statements.addAll([
      declareVar(_visitedLocalName)
          .assign(refer(_visitedParamName).ifNullThen(literalSet({})))
          .statement,
      const Code(''),
      _buildIfVisitedThrow(),
      refer(_visitedLocalName).property('add').call([refer('this')]).statement,
      const Code(''),
      declareVar(_previousLocalName)
          .assign(refer(_previousParamName).ifNullThen(refer('this')))
          .statement,
    ]);
  }

  blockBuilder.statements.addAll([
    literalMap(map).returned.statement,
  ]);

  return blockBuilder.build();
}

Block _buildIfVisitedThrow() {
  return Block.of([
    Code('if ($_visitedLocalName.contains(this)) {'),
    refer('StateError', 'dart:core')
        .call([
          literalString(
              'Unable to convert object to a JSON representation because a circular reference was detected.')
        ])
        .thrown
        .statement,
    const Code('}'),
  ]);
}
