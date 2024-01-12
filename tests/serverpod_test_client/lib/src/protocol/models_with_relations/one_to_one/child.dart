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

abstract class Child extends _i1.SerializableEntity {
  Child._({
    this.id,
    this.parent,
  });

  factory Child({
    int? id,
    _i2.Parent? parent,
  }) = _ChildImpl;

  factory Child.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Child(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      parent: serializationManager
          .deserialize<_i2.Parent?>(jsonSerialization['parent']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2.Parent? parent;

  Child copyWith({
    int? id,
    _i2.Parent? parent,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (parent != null) 'parent': parent?.toJson(),
    };
  }
}

class _Undefined {}

class _ChildImpl extends Child {
  _ChildImpl({
    int? id,
    _i2.Parent? parent,
  }) : super._(
          id: id,
          parent: parent,
        );

  @override
  Child copyWith({
    Object? id = _Undefined,
    Object? parent = _Undefined,
  }) {
    return Child(
      id: id is int? ? id : this.id,
      parent: parent is _i2.Parent? ? parent : this.parent?.copyWith(),
    );
  }
}
