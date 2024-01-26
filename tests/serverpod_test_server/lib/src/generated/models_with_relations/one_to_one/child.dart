/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
part of protocol;

abstract class Child extends _i1.TableRow {
  Child._({
    int? id,
    Parent? parent,
  })  : _parent = parent,
        super(id) {
    if (parent != null && id == null) {
      throw ArgumentError.notNull('id');
    }

    if (parent != null && id != null) {
      parent.childId = id;
      parent.child = this;
    }
  }

  factory Child({
    int? id,
    Parent? parent,
  }) = _ChildImpl;

  factory Child.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Child(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      parent: serializationManager
          .deserialize<Parent?>(jsonSerialization['parent']),
    );
  }

  static final t = ChildTable();

  static const db = ChildRepository._();

  Parent? _parent;

  set parent(Parent? parent) {
    if (parent != null && id == null) {
      throw ArgumentError.notNull('id');
    }

    _parent = parent;

    var _id = id;
    if (_id != null) {
      _parent?.childId = _id;
      _parent?.child = this;
    }
  }

  Parent? get parent => _parent;

  @override
  _i1.Table get table => t;

  Child copyWith({
    int? id,
    Parent? parent,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (parent != null) 'parent': parent?.toJson(),
    };
  }
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {'id': id};
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      if (parent != null) 'parent': parent?.allToJson(),
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
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<Child>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChildTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    ChildInclude? include,
  }) async {
    return session.db.find<Child>(
      where: where != null ? where(Child.t) : null,
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
  static Future<Child?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChildTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    ChildInclude? include,
  }) async {
    return session.db.findSingleRow<Child>(
      where: where != null ? where(Child.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<Child?> findById(
    _i1.Session session,
    int id, {
    ChildInclude? include,
  }) async {
    return session.db.findById<Child>(
      id,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChildTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Child>(
      where: where(Child.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    Child row, {
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
    Child row, {
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
    Child row, {
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
    _i1.WhereExpressionBuilder<ChildTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Child>(
      where: where != null ? where(Child.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static ChildInclude include({ParentInclude? parent}) {
    return ChildInclude._(parent: parent);
  }

  static ChildIncludeList includeList({
    _i1.WhereExpressionBuilder<ChildTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChildTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChildTable>? orderByList,
    ChildInclude? include,
  }) {
    return ChildIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Child.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Child.t),
      include: include,
    );
  }
}

class _Undefined {}

class _ChildImpl extends Child {
  _ChildImpl({
    int? id,
    Parent? parent,
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
      parent: parent is Parent? ? parent : this.parent?.copyWith(),
    );
  }

  Map<String, dynamic> toJson({Set<Object>? $visited, Object? $previous}) {
    var _visited = $visited ?? Set<Object>();
    _visited.add(this);

    var $$parent = parent;

    return {
      if (id != null) 'id': id,
      if ($$parent is _ParentImpl && $previous != $$parent)
        'parent': $$parent.toJson($visited: _visited, $previous: this),
    };
  }

  @override
  Map<String, dynamic> allToJson({_ParentImpl? $parent}) {
    var __parent = parent;
    return {
      if (id != null) 'id': id,
      if (__parent is _ParentImpl && $parent != __parent)
        'parent': __parent.toJson($previous: this),
    };
  }
}

class ChildTable extends _i1.Table {
  ChildTable({super.tableRelation}) : super(tableName: 'child') {}

  ParentTable? _parent;

  ParentTable get parent {
    if (_parent != null) return _parent!;
    _parent = _i1.createRelationTable(
      relationFieldName: 'parent',
      field: Child.t.id,
      foreignField: Parent.t.childId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          ParentTable(tableRelation: foreignTableRelation),
    );
    return _parent!;
  }

  @override
  List<_i1.Column> get columns => [id];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'parent') {
      return parent;
    }
    return null;
  }
}

@Deprecated('Use ChildTable.t instead.')
ChildTable tChild = ChildTable();

class ChildInclude extends _i1.IncludeObject {
  ChildInclude._({ParentInclude? parent}) {
    _parent = parent;
  }

  ParentInclude? _parent;

  @override
  Map<String, _i1.Include?> get includes => {'parent': _parent};

  @override
  _i1.Table get table => Child.t;
}

class ChildIncludeList extends _i1.IncludeList {
  ChildIncludeList._({
    _i1.WhereExpressionBuilder<ChildTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Child.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Child.t;
}

class ChildRepository {
  const ChildRepository._();

  final attachRow = const ChildAttachRowRepository._();

  final detachRow = const ChildDetachRowRepository._();

  Future<List<Child>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChildTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChildTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChildTable>? orderByList,
    _i1.Transaction? transaction,
    ChildInclude? include,
  }) async {
    return session.dbNext.find<Child>(
      where: where?.call(Child.t),
      orderBy: orderBy?.call(Child.t),
      orderByList: orderByList?.call(Child.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Child?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChildTable>? where,
    int? offset,
    _i1.OrderByBuilder<ChildTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChildTable>? orderByList,
    _i1.Transaction? transaction,
    ChildInclude? include,
  }) async {
    return session.dbNext.findFirstRow<Child>(
      where: where?.call(Child.t),
      orderBy: orderBy?.call(Child.t),
      orderByList: orderByList?.call(Child.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Child?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ChildInclude? include,
  }) async {
    return session.dbNext.findById<Child>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Child>> insert(
    _i1.Session session,
    List<Child> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<Child>(
      rows,
      transaction: transaction,
    );
  }

  Future<Child> insertRow(
    _i1.Session session,
    Child row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<Child>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Child>> update(
    _i1.Session session,
    List<Child> rows, {
    _i1.ColumnSelections<ChildTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Child>(
      rows,
      columns: columns?.call(Child.t),
      transaction: transaction,
    );
  }

  Future<Child> updateRow(
    _i1.Session session,
    Child row, {
    _i1.ColumnSelections<ChildTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Child>(
      row,
      columns: columns?.call(Child.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Child> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<Child>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Child row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<Child>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChildTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Child>(
      where: where(Child.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChildTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<Child>(
      where: where?.call(Child.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ChildAttachRowRepository {
  const ChildAttachRowRepository._();

  Future<void> parent(
    _i1.Session session,
    Child child,
    Parent parent,
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

class ChildDetachRowRepository {
  const ChildDetachRowRepository._();

  Future<void> parent(
    _i1.Session session,
    Child child,
  ) async {
    var $parent = child.parent;

    if ($parent == null) {
      throw ArgumentError.notNull('child.parent');
    }
    if ($parent.id == null) {
      throw ArgumentError.notNull('child.parent.id');
    }
    if (child.id == null) {
      throw ArgumentError.notNull('child.id');
    }

    var $$parent = $parent.copyWith(childId: null);
    await session.dbNext.updateRow<Parent>(
      $$parent,
      columns: [Parent.t.childId],
    );
  }
}
