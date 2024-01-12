/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Parent extends _i1.TableRow {
  Parent._({
    int? id,
    required this.childId,
    this.child,
  }) : super(id);

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

  static final t = ParentTable();

  static const db = ParentRepository._();

  int childId;

  _i2.Child? child;

  @override
  _i1.Table get table => t;

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

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'childId': childId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'childId': childId,
      if (child != null) 'child': child?.allToJson(),
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'childId':
        childId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<Parent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    ParentInclude? include,
  }) async {
    return session.db.find<Parent>(
      where: where != null ? where(Parent.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<Parent?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    ParentInclude? include,
  }) async {
    return session.db.findSingleRow<Parent>(
      where: where != null ? where(Parent.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<Parent?> findById(
    _i1.Session session,
    int id, {
    ParentInclude? include,
  }) async {
    return session.db.findById<Parent>(
      id,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ParentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Parent>(
      where: where(Parent.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    Parent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
  static Future<bool> update(
    _i1.Session session,
    Parent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
  static Future<void> insert(
    _i1.Session session,
    Parent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Parent>(
      where: where != null ? where(Parent.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static ParentInclude include({_i2.ChildInclude? child}) {
    return ParentInclude._(child: child);
  }

  static ParentIncludeList includeList({
    _i1.WhereExpressionBuilder<ParentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ParentTable>? orderByList,
    ParentInclude? include,
  }) {
    return ParentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Parent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Parent.t),
      include: include,
    );
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

class ParentTable extends _i1.Table {
  ParentTable({super.tableRelation}) : super(tableName: 'parent') {
    childId = _i1.ColumnInt(
      'childId',
      this,
    );
  }

  late final _i1.ColumnInt childId;

  _i2.ChildTable? _child;

  _i2.ChildTable get child {
    if (_child != null) return _child!;
    _child = _i1.createRelationTable(
      relationFieldName: 'child',
      field: Parent.t.childId,
      foreignField: _i2.Child.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ChildTable(tableRelation: foreignTableRelation),
    );
    return _child!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        childId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'child') {
      return child;
    }
    return null;
  }
}

@Deprecated('Use ParentTable.t instead.')
ParentTable tParent = ParentTable();

class ParentInclude extends _i1.IncludeObject {
  ParentInclude._({_i2.ChildInclude? child}) {
    _child = child;
  }

  _i2.ChildInclude? _child;

  @override
  Map<String, _i1.Include?> get includes => {'child': _child};

  @override
  _i1.Table get table => Parent.t;
}

class ParentIncludeList extends _i1.IncludeList {
  ParentIncludeList._({
    _i1.WhereExpressionBuilder<ParentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Parent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Parent.t;
}

class ParentRepository {
  const ParentRepository._();

  final attachRow = const ParentAttachRowRepository._();

  Future<List<Parent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ParentTable>? orderByList,
    _i1.Transaction? transaction,
    ParentInclude? include,
  }) async {
    return session.dbNext.find<Parent>(
      where: where?.call(Parent.t),
      orderBy: orderBy?.call(Parent.t),
      orderByList: orderByList?.call(Parent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Parent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentTable>? where,
    int? offset,
    _i1.OrderByBuilder<ParentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ParentTable>? orderByList,
    _i1.Transaction? transaction,
    ParentInclude? include,
  }) async {
    return session.dbNext.findFirstRow<Parent>(
      where: where?.call(Parent.t),
      orderBy: orderBy?.call(Parent.t),
      orderByList: orderByList?.call(Parent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Parent?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ParentInclude? include,
  }) async {
    return session.dbNext.findById<Parent>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Parent>> insert(
    _i1.Session session,
    List<Parent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<Parent>(
      rows,
      transaction: transaction,
    );
  }

  Future<Parent> insertRow(
    _i1.Session session,
    Parent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<Parent>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Parent>> update(
    _i1.Session session,
    List<Parent> rows, {
    _i1.ColumnSelections<ParentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Parent>(
      rows,
      columns: columns?.call(Parent.t),
      transaction: transaction,
    );
  }

  Future<Parent> updateRow(
    _i1.Session session,
    Parent row, {
    _i1.ColumnSelections<ParentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Parent>(
      row,
      columns: columns?.call(Parent.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Parent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<Parent>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Parent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<Parent>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ParentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Parent>(
      where: where(Parent.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ParentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<Parent>(
      where: where?.call(Parent.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ParentAttachRowRepository {
  const ParentAttachRowRepository._();

  Future<void> child(
    _i1.Session session,
    Parent parent,
    _i2.Child child,
  ) async {
    if (parent.id == null) {
      throw ArgumentError.notNull('parent.id');
    }
    if (child.id == null) {
      throw ArgumentError.notNull('child.id');
    }

    var $parent = parent.copyWith(childId: child.id);
    await session.dbNext.updateRow<Parent>(
      $parent,
      columns: [Parent.t.childId],
    );
  }
}
