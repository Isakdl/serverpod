/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Parent extends _i1.SerializableEntity {
  Parent._({
    this.id,
    required this.childId,
    this.child,
  });

  factory Parent({
    int? id,
    required int childId,
    _i2.Child? child,
  }) = _ParentImpl;

  factory Parent.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Parent(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      childId:
          serializationManager.deserialize<int>(jsonSerialization['childId']),
      child: serializationManager
          .deserialize<_i2.Child?>(jsonSerialization['child']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int childId;

  _i2.Child? child;

  Parent copyWith({
    int? id,
    int? childId,
    _i2.Child? child,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'childId': childId,
      if (child != null) 'child': child?.toJson(),
    };
  }
}

class _Undefined {}

class _ParentImpl extends Parent {
  _ParentImpl({
    int? id,
    required int childId,
    _i2.Child? child,
  }) : super._(
          id: id,
          childId: childId,
          child: child,
        );

  @override
  Parent copyWith({
    Object? id = _Undefined,
    int? childId,
    Object? child = _Undefined,
  }) {
    return Parent(
      id: id is int? ? id : this.id,
      childId: childId ?? this.childId,
      child: child is _i2.Child? ? child : this.child?.copyWith(),
    );
  }
}
