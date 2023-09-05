/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

class Address extends _i1.SerializableEntity {
  Address({
    this.id,
    required this.street,
    required this.inhabitantId,
    this.inhabitant,
  });

  factory Address.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Address(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      street:
          serializationManager.deserialize<String>(jsonSerialization['street']),
      inhabitantId: serializationManager
          .deserialize<int>(jsonSerialization['inhabitantId']),
      inhabitant: serializationManager
          .deserialize<_i2.Citizen?>(jsonSerialization['inhabitant']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String street;

  int inhabitantId;

  _i2.Citizen? inhabitant;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'street': street,
      'inhabitantId': inhabitantId,
      'inhabitant': inhabitant,
    };
  }
}