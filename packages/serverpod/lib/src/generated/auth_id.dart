/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class AuthId extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  AuthId._({
    int? id,
    required this.scopes,
    this.refreshTokens,
  }) : super(id);

  factory AuthId({
    int? id,
    required List<String> scopes,
    List<_i2.RefreshToken>? refreshTokens,
  }) = _AuthIdImpl;

  factory AuthId.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthId(
      id: jsonSerialization['id'] as int?,
      scopes: (jsonSerialization['scopes'] as List)
          .map((e) => e as String)
          .toList(),
      refreshTokens: (jsonSerialization['refreshTokens'] as List?)
          ?.map((e) => _i2.RefreshToken.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = AuthIdTable();

  static const db = AuthIdRepository._();

  List<String> scopes;

  List<_i2.RefreshToken>? refreshTokens;

  @override
  _i1.Table get table => t;

  AuthId copyWith({
    int? id,
    List<String>? scopes,
    List<_i2.RefreshToken>? refreshTokens,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'scopes': scopes.toJson(),
      if (refreshTokens != null)
        'refreshTokens': refreshTokens?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id};
  }

  static AuthIdInclude include({_i2.RefreshTokenIncludeList? refreshTokens}) {
    return AuthIdInclude._(refreshTokens: refreshTokens);
  }

  static AuthIdIncludeList includeList({
    _i1.WhereExpressionBuilder<AuthIdTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthIdTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthIdTable>? orderByList,
    AuthIdInclude? include,
  }) {
    return AuthIdIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthId.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AuthId.t),
      include: include,
    );
  }
}

class _Undefined {}

class _AuthIdImpl extends AuthId {
  _AuthIdImpl({
    int? id,
    required List<String> scopes,
    List<_i2.RefreshToken>? refreshTokens,
  }) : super._(
          id: id,
          scopes: scopes,
          refreshTokens: refreshTokens,
        );

  @override
  AuthId copyWith({
    Object? id = _Undefined,
    List<String>? scopes,
    Object? refreshTokens = _Undefined,
  }) {
    return AuthId(
      id: id is int? ? id : this.id,
      scopes: scopes ?? this.scopes.clone(),
      refreshTokens: refreshTokens is List<_i2.RefreshToken>?
          ? refreshTokens
          : this.refreshTokens?.clone(),
    );
  }
}

class AuthIdTable extends _i1.Table {
  AuthIdTable({super.tableRelation}) : super(tableName: 'serverpod_auth_id') {
    scopes = _i1.ColumnSerializable(
      'scopes',
      this,
    );
  }

  late final _i1.ColumnSerializable scopes;

  _i2.RefreshTokenTable? ___refreshTokens;

  _i1.ManyRelation<_i2.RefreshTokenTable>? _refreshTokens;

  _i2.RefreshTokenTable get __refreshTokens {
    if (___refreshTokens != null) return ___refreshTokens!;
    ___refreshTokens = _i1.createRelationTable(
      relationFieldName: '__refreshTokens',
      field: AuthId.t.id,
      foreignField:
          _i2.RefreshToken.t.$_serverpodAuthIdRefreshtokensServerpodAuthIdId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.RefreshTokenTable(tableRelation: foreignTableRelation),
    );
    return ___refreshTokens!;
  }

  _i1.ManyRelation<_i2.RefreshTokenTable> get refreshTokens {
    if (_refreshTokens != null) return _refreshTokens!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'refreshTokens',
      field: AuthId.t.id,
      foreignField:
          _i2.RefreshToken.t.$_serverpodAuthIdRefreshtokensServerpodAuthIdId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.RefreshTokenTable(tableRelation: foreignTableRelation),
    );
    _refreshTokens = _i1.ManyRelation<_i2.RefreshTokenTable>(
      tableWithRelations: relationTable,
      table: _i2.RefreshTokenTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _refreshTokens!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        scopes,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'refreshTokens') {
      return __refreshTokens;
    }
    return null;
  }
}

class AuthIdInclude extends _i1.IncludeObject {
  AuthIdInclude._({_i2.RefreshTokenIncludeList? refreshTokens}) {
    _refreshTokens = refreshTokens;
  }

  _i2.RefreshTokenIncludeList? _refreshTokens;

  @override
  Map<String, _i1.Include?> get includes => {'refreshTokens': _refreshTokens};

  @override
  _i1.Table get table => AuthId.t;
}

class AuthIdIncludeList extends _i1.IncludeList {
  AuthIdIncludeList._({
    _i1.WhereExpressionBuilder<AuthIdTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuthId.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => AuthId.t;
}

class AuthIdRepository {
  const AuthIdRepository._();

  final attach = const AuthIdAttachRepository._();

  final attachRow = const AuthIdAttachRowRepository._();

  final detach = const AuthIdDetachRepository._();

  final detachRow = const AuthIdDetachRowRepository._();

  Future<List<AuthId>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthIdTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthIdTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthIdTable>? orderByList,
    _i1.Transaction? transaction,
    AuthIdInclude? include,
  }) async {
    return session.db.find<AuthId>(
      where: where?.call(AuthId.t),
      orderBy: orderBy?.call(AuthId.t),
      orderByList: orderByList?.call(AuthId.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<AuthId?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthIdTable>? where,
    int? offset,
    _i1.OrderByBuilder<AuthIdTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthIdTable>? orderByList,
    _i1.Transaction? transaction,
    AuthIdInclude? include,
  }) async {
    return session.db.findFirstRow<AuthId>(
      where: where?.call(AuthId.t),
      orderBy: orderBy?.call(AuthId.t),
      orderByList: orderByList?.call(AuthId.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<AuthId?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    AuthIdInclude? include,
  }) async {
    return session.db.findById<AuthId>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<AuthId>> insert(
    _i1.Session session,
    List<AuthId> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AuthId>(
      rows,
      transaction: transaction,
    );
  }

  Future<AuthId> insertRow(
    _i1.Session session,
    AuthId row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuthId>(
      row,
      transaction: transaction,
    );
  }

  Future<List<AuthId>> update(
    _i1.Session session,
    List<AuthId> rows, {
    _i1.ColumnSelections<AuthIdTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AuthId>(
      rows,
      columns: columns?.call(AuthId.t),
      transaction: transaction,
    );
  }

  Future<AuthId> updateRow(
    _i1.Session session,
    AuthId row, {
    _i1.ColumnSelections<AuthIdTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuthId>(
      row,
      columns: columns?.call(AuthId.t),
      transaction: transaction,
    );
  }

  Future<List<AuthId>> delete(
    _i1.Session session,
    List<AuthId> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AuthId>(
      rows,
      transaction: transaction,
    );
  }

  Future<AuthId> deleteRow(
    _i1.Session session,
    AuthId row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuthId>(
      row,
      transaction: transaction,
    );
  }

  Future<List<AuthId>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AuthIdTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AuthId>(
      where: where(AuthId.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthIdTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AuthId>(
      where: where?.call(AuthId.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AuthIdAttachRepository {
  const AuthIdAttachRepository._();

  Future<void> refreshTokens(
    _i1.Session session,
    AuthId authId,
    List<_i2.RefreshToken> refreshToken,
  ) async {
    if (refreshToken.any((e) => e.id == null)) {
      throw ArgumentError.notNull('refreshToken.id');
    }
    if (authId.id == null) {
      throw ArgumentError.notNull('authId.id');
    }

    var $refreshToken = refreshToken
        .map((e) => _i2.RefreshTokenImplicit(
              e,
              $_serverpodAuthIdRefreshtokensServerpodAuthIdId: authId.id,
            ))
        .toList();
    await session.db.update<_i2.RefreshToken>(
      $refreshToken,
      columns: [
        _i2.RefreshToken.t.$_serverpodAuthIdRefreshtokensServerpodAuthIdId
      ],
    );
  }
}

class AuthIdAttachRowRepository {
  const AuthIdAttachRowRepository._();

  Future<void> refreshTokens(
    _i1.Session session,
    AuthId authId,
    _i2.RefreshToken refreshToken,
  ) async {
    if (refreshToken.id == null) {
      throw ArgumentError.notNull('refreshToken.id');
    }
    if (authId.id == null) {
      throw ArgumentError.notNull('authId.id');
    }

    var $refreshToken = _i2.RefreshTokenImplicit(
      refreshToken,
      $_serverpodAuthIdRefreshtokensServerpodAuthIdId: authId.id,
    );
    await session.db.updateRow<_i2.RefreshToken>(
      $refreshToken,
      columns: [
        _i2.RefreshToken.t.$_serverpodAuthIdRefreshtokensServerpodAuthIdId
      ],
    );
  }
}

class AuthIdDetachRepository {
  const AuthIdDetachRepository._();

  Future<void> refreshTokens(
    _i1.Session session,
    List<_i2.RefreshToken> refreshToken,
  ) async {
    if (refreshToken.any((e) => e.id == null)) {
      throw ArgumentError.notNull('refreshToken.id');
    }

    var $refreshToken = refreshToken
        .map((e) => _i2.RefreshTokenImplicit(
              e,
              $_serverpodAuthIdRefreshtokensServerpodAuthIdId: null,
            ))
        .toList();
    await session.db.update<_i2.RefreshToken>(
      $refreshToken,
      columns: [
        _i2.RefreshToken.t.$_serverpodAuthIdRefreshtokensServerpodAuthIdId
      ],
    );
  }
}

class AuthIdDetachRowRepository {
  const AuthIdDetachRowRepository._();

  Future<void> refreshTokens(
    _i1.Session session,
    _i2.RefreshToken refreshToken,
  ) async {
    if (refreshToken.id == null) {
      throw ArgumentError.notNull('refreshToken.id');
    }

    var $refreshToken = _i2.RefreshTokenImplicit(
      refreshToken,
      $_serverpodAuthIdRefreshtokensServerpodAuthIdId: null,
    );
    await session.db.updateRow<_i2.RefreshToken>(
      $refreshToken,
      columns: [
        _i2.RefreshToken.t.$_serverpodAuthIdRefreshtokensServerpodAuthIdId
      ],
    );
  }
}
