/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class RefreshToken extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  RefreshToken._({
    int? id,
    required this.authId,
    required this.token,
    required this.tokenHash,
    required this.provider,
    this.expiresAt,
  }) : super(id);

  factory RefreshToken({
    int? id,
    required int authId,
    required String token,
    required String tokenHash,
    required String provider,
    DateTime? expiresAt,
  }) = _RefreshTokenImpl;

  factory RefreshToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return RefreshToken(
      id: jsonSerialization['id'] as int?,
      authId: jsonSerialization['authId'] as int,
      token: jsonSerialization['token'] as String,
      tokenHash: jsonSerialization['tokenHash'] as String,
      provider: jsonSerialization['provider'] as String,
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
    );
  }

  static final t = RefreshTokenTable();

  static const db = RefreshTokenRepository._();

  int authId;

  String token;

  String tokenHash;

  String provider;

  DateTime? expiresAt;

  int? _serverpodAuthIdRefreshtokensServerpodAuthIdId;

  @override
  _i1.Table get table => t;

  RefreshToken copyWith({
    int? id,
    int? authId,
    String? token,
    String? tokenHash,
    String? provider,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'authId': authId,
      'token': token,
      'tokenHash': tokenHash,
      'provider': provider,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      if (_serverpodAuthIdRefreshtokensServerpodAuthIdId != null)
        '_serverpodAuthIdRefreshtokensServerpodAuthIdId':
            _serverpodAuthIdRefreshtokensServerpodAuthIdId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id};
  }

  static RefreshTokenInclude include() {
    return RefreshTokenInclude._();
  }

  static RefreshTokenIncludeList includeList({
    _i1.WhereExpressionBuilder<RefreshTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RefreshTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RefreshTokenTable>? orderByList,
    RefreshTokenInclude? include,
  }) {
    return RefreshTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RefreshToken.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RefreshToken.t),
      include: include,
    );
  }
}

class _Undefined {}

class _RefreshTokenImpl extends RefreshToken {
  _RefreshTokenImpl({
    int? id,
    required int authId,
    required String token,
    required String tokenHash,
    required String provider,
    DateTime? expiresAt,
  }) : super._(
          id: id,
          authId: authId,
          token: token,
          tokenHash: tokenHash,
          provider: provider,
          expiresAt: expiresAt,
        );

  @override
  RefreshToken copyWith({
    Object? id = _Undefined,
    int? authId,
    String? token,
    String? tokenHash,
    String? provider,
    Object? expiresAt = _Undefined,
  }) {
    return RefreshToken(
      id: id is int? ? id : this.id,
      authId: authId ?? this.authId,
      token: token ?? this.token,
      tokenHash: tokenHash ?? this.tokenHash,
      provider: provider ?? this.provider,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
    );
  }
}

class RefreshTokenImplicit extends _RefreshTokenImpl {
  RefreshTokenImplicit._({
    int? id,
    required int authId,
    required String token,
    required String tokenHash,
    required String provider,
    DateTime? expiresAt,
    this.$_serverpodAuthIdRefreshtokensServerpodAuthIdId,
  }) : super(
          id: id,
          authId: authId,
          token: token,
          tokenHash: tokenHash,
          provider: provider,
          expiresAt: expiresAt,
        );

  factory RefreshTokenImplicit(
    RefreshToken refreshToken, {
    int? $_serverpodAuthIdRefreshtokensServerpodAuthIdId,
  }) {
    return RefreshTokenImplicit._(
      id: refreshToken.id,
      authId: refreshToken.authId,
      token: refreshToken.token,
      tokenHash: refreshToken.tokenHash,
      provider: refreshToken.provider,
      expiresAt: refreshToken.expiresAt,
      $_serverpodAuthIdRefreshtokensServerpodAuthIdId:
          $_serverpodAuthIdRefreshtokensServerpodAuthIdId,
    );
  }

  int? $_serverpodAuthIdRefreshtokensServerpodAuthIdId;

  @override
  Map<String, dynamic> toJson() {
    var jsonMap = super.toJson();
    jsonMap.addAll({
      '_serverpodAuthIdRefreshtokensServerpodAuthIdId':
          $_serverpodAuthIdRefreshtokensServerpodAuthIdId
    });
    return jsonMap;
  }
}

class RefreshTokenTable extends _i1.Table {
  RefreshTokenTable({super.tableRelation})
      : super(tableName: 'serverpod_refresh_token') {
    authId = _i1.ColumnInt(
      'authId',
      this,
    );
    tokenHash = _i1.ColumnString(
      'tokenHash',
      this,
    );
    provider = _i1.ColumnString(
      'provider',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    $_serverpodAuthIdRefreshtokensServerpodAuthIdId = _i1.ColumnInt(
      '_serverpodAuthIdRefreshtokensServerpodAuthIdId',
      this,
    );
  }

  late final _i1.ColumnInt authId;

  late final _i1.ColumnString tokenHash;

  late final _i1.ColumnString provider;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnInt $_serverpodAuthIdRefreshtokensServerpodAuthIdId;

  @override
  List<_i1.Column> get columns => [
        id,
        authId,
        tokenHash,
        provider,
        expiresAt,
        $_serverpodAuthIdRefreshtokensServerpodAuthIdId,
      ];
}

class RefreshTokenInclude extends _i1.IncludeObject {
  RefreshTokenInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => RefreshToken.t;
}

class RefreshTokenIncludeList extends _i1.IncludeList {
  RefreshTokenIncludeList._({
    _i1.WhereExpressionBuilder<RefreshTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RefreshToken.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => RefreshToken.t;
}

class RefreshTokenRepository {
  const RefreshTokenRepository._();

  Future<List<RefreshToken>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RefreshTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RefreshTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RefreshTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<RefreshToken>(
      where: where?.call(RefreshToken.t),
      orderBy: orderBy?.call(RefreshToken.t),
      orderByList: orderByList?.call(RefreshToken.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<RefreshToken?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RefreshTokenTable>? where,
    int? offset,
    _i1.OrderByBuilder<RefreshTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RefreshTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<RefreshToken>(
      where: where?.call(RefreshToken.t),
      orderBy: orderBy?.call(RefreshToken.t),
      orderByList: orderByList?.call(RefreshToken.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<RefreshToken?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<RefreshToken>(
      id,
      transaction: transaction,
    );
  }

  Future<List<RefreshToken>> insert(
    _i1.Session session,
    List<RefreshToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<RefreshToken>(
      rows,
      transaction: transaction,
    );
  }

  Future<RefreshToken> insertRow(
    _i1.Session session,
    RefreshToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RefreshToken>(
      row,
      transaction: transaction,
    );
  }

  Future<List<RefreshToken>> update(
    _i1.Session session,
    List<RefreshToken> rows, {
    _i1.ColumnSelections<RefreshTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RefreshToken>(
      rows,
      columns: columns?.call(RefreshToken.t),
      transaction: transaction,
    );
  }

  Future<RefreshToken> updateRow(
    _i1.Session session,
    RefreshToken row, {
    _i1.ColumnSelections<RefreshTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RefreshToken>(
      row,
      columns: columns?.call(RefreshToken.t),
      transaction: transaction,
    );
  }

  Future<List<RefreshToken>> delete(
    _i1.Session session,
    List<RefreshToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RefreshToken>(
      rows,
      transaction: transaction,
    );
  }

  Future<RefreshToken> deleteRow(
    _i1.Session session,
    RefreshToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RefreshToken>(
      row,
      transaction: transaction,
    );
  }

  Future<List<RefreshToken>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RefreshTokenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RefreshToken>(
      where: where(RefreshToken.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RefreshTokenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RefreshToken>(
      where: where?.call(RefreshToken.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
