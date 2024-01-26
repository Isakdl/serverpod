/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../../protocol.dart' as _i2;

abstract class Post extends _i1.TableRow {
  Post._({
    int? id,
    required this.content,
    Post? previous,
    int? nextId,
    Post? next,
  })  : _nextId = next is Post ? next.id : nextId,
        _next = next,
        _previous = previous,
        super(id) {
    if (nextId is int && next is Post && nextId != next.id) {
      throw ArgumentError(
        'Inconsistent values for nextId ($nextId) and next.id (${next.id})',
      );
    }

    if (next is Post) {
      _next?.previous = this;
    }

    if (previous is Post) {
      _previous?.next = this;
    }
  }

  factory Post({
    int? id,
    required String content,
    _i2.Post? previous,
    int? nextId,
    _i2.Post? next,
  }) = _PostImpl;

  factory Post.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Post(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      content: serializationManager
          .deserialize<String>(jsonSerialization['content']),
      previous: serializationManager
          .deserialize<_i2.Post?>(jsonSerialization['previous']),
      nextId:
          serializationManager.deserialize<int?>(jsonSerialization['nextId']),
      next: serializationManager
          .deserialize<_i2.Post?>(jsonSerialization['next']),
    );
  }

  static final t = PostTable();

  static const db = PostRepository._();

  String content;

  _i2.Post? _previous;

  set previous(_i2.Post? previous) {
    if (previous == _previous) return;

    _previous = previous;

    if (_previous?.next != this) {
      _previous?.nextId = this.id; //<- add test
      _previous?.next = this;
    }
  }

  _i2.Post? get previous => _previous;

  int? _nextId;

  _i2.Post? _next;

  set nextId(int? nextId) {
    if (_nextId == nextId) return;

    _nextId = nextId;
    _next = null;
  }

  int? get nextId => _nextId;
  set next(_i2.Post? next) {
    if (next == _next) return;

    nextId = next?.id;
    _next = next;

    if (_next?.previous != this) {
      _next?.previous = this;
    }
  }

  _i2.Post? get next => _next;

  @override
  _i1.Table get table => t;

  Post copyWith({
    int? id,
    String? content,
    _i2.Post? previous,
    int? nextId,
    _i2.Post? next,
  });

  @override
  Map<String, dynamic> toJson() => internalToJson();

  /// Internal serializer used by the framework.
  /// Use [toJson] instead. This method might be removed in the future in a none major version.
  Map<String, dynamic> internalToJson({
    Set<Object>? $visited,
    Object? $previous,
  }) {
    var _visited = $visited ?? {};

    if (_visited.contains(this)) {
      throw StateError(
        'Unable to convert object to a JSON representation because a circular reference was detected.',
      );
    }
    _visited.add(this);

    var _previousNode = $previous ?? this;
    return {
      if (id != null) 'id': id,
      'content': content,
      if (previous != null && _previousNode != previous)
        'previous':
            previous?.internalToJson($visited: _visited, $previous: this),
      if (nextId != null) 'nextId': nextId,
      if (next != null && _previousNode != next)
        'next': next?.internalToJson($visited: _visited, $previous: this),
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'content': content,
      'nextId': nextId,
    };
  }

  @override
  Map<String, dynamic> allToJson() => internalAllToJson();

  /// Internal serializer used by the framework.
  /// Use [toJson] instead. This method might be removed in the future in a none major version.
  Map<String, dynamic> internalAllToJson({
    Set<Object>? $visited,
    Object? $previous,
  }) {
    var _visited = $visited ?? {};

    if (_visited.contains(this)) {
      throw StateError(
        'Unable to convert object to a JSON representation because a circular reference was detected.',
      );
    }
    _visited.add(this);

    var _previousNode = $previous ?? this;
    return {
      if (id != null) 'id': id,
      'content': content,
      if (previous != null && _previousNode != previous)
        'previous':
            previous?.internalAllToJson($visited: _visited, $previous: this),
      if (nextId != null) 'nextId': nextId,
      if (next != null && _previousNode != next)
        'next': next?.internalAllToJson($visited: _visited, $previous: this),
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
      case 'content':
        content = value;
        return;
      case 'nextId':
        nextId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<Post>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PostTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    PostInclude? include,
  }) async {
    return session.db.find<Post>(
      where: where != null ? where(Post.t) : null,
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
  static Future<Post?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PostTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    PostInclude? include,
  }) async {
    return session.db.findSingleRow<Post>(
      where: where != null ? where(Post.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<Post?> findById(
    _i1.Session session,
    int id, {
    PostInclude? include,
  }) async {
    return session.db.findById<Post>(
      id,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PostTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Post>(
      where: where(Post.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    Post row, {
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
    Post row, {
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
    Post row, {
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
    _i1.WhereExpressionBuilder<PostTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Post>(
      where: where != null ? where(Post.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static PostInclude include({
    _i2.PostInclude? previous,
    _i2.PostInclude? next,
  }) {
    return PostInclude._(
      previous: previous,
      next: next,
    );
  }

  static PostIncludeList includeList({
    _i1.WhereExpressionBuilder<PostTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PostTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PostTable>? orderByList,
    PostInclude? include,
  }) {
    return PostIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Post.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Post.t),
      include: include,
    );
  }
}

class _Undefined {}

class _PostImpl extends Post {
  _PostImpl({
    int? id,
    required String content,
    _i2.Post? previous,
    int? nextId,
    _i2.Post? next,
  }) : super._(
          id: id,
          content: content,
          previous: previous,
          nextId: nextId,
          next: next,
        );

  @override
  Post copyWith({
    Object? id = _Undefined,
    String? content,
    Object? previous = _Undefined,
    Object? nextId = _Undefined,
    Object? next = _Undefined,
  }) {
    if (nextId is int? && next is Post? && nextId != next?.id) {
      throw ArgumentError(
        'Inconsistent values for nextId ($nextId) and next.id ({$next?.id})',
      );
    }

    var _nextId = nextId is int? ? nextId : this.nextId;
    var _syncedNextId = next is Post? ? next?.id : _nextId;

    var _syncedPrevious =
        previous is Post? ? previous : this.previous?.copyWith(next: this);

    var _next = next is Post? ? next : this.next?.copyWith(previous: this);
    var _syncedNext = nextId is int && nextId != _next?.id ? null : _next;

    return Post(
      id: id is int? ? id : this.id,
      content: content ?? this.content,
      previous: _syncedPrevious,
      nextId: _syncedNextId,
      next: _syncedNext,
    );
  }
}

class PostTable extends _i1.Table {
  PostTable({super.tableRelation}) : super(tableName: 'post') {
    content = _i1.ColumnString(
      'content',
      this,
    );
    nextId = _i1.ColumnInt(
      'nextId',
      this,
    );
  }

  late final _i1.ColumnString content;

  _i2.PostTable? _previous;

  late final _i1.ColumnInt nextId;

  _i2.PostTable? _next;

  _i2.PostTable get previous {
    if (_previous != null) return _previous!;
    _previous = _i1.createRelationTable(
      relationFieldName: 'previous',
      field: Post.t.id,
      foreignField: _i2.Post.t.nextId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PostTable(tableRelation: foreignTableRelation),
    );
    return _previous!;
  }

  _i2.PostTable get next {
    if (_next != null) return _next!;
    _next = _i1.createRelationTable(
      relationFieldName: 'next',
      field: Post.t.nextId,
      foreignField: _i2.Post.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PostTable(tableRelation: foreignTableRelation),
    );
    return _next!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        content,
        nextId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'previous') {
      return previous;
    }
    if (relationField == 'next') {
      return next;
    }
    return null;
  }
}

@Deprecated('Use PostTable.t instead.')
PostTable tPost = PostTable();

class PostInclude extends _i1.IncludeObject {
  PostInclude._({
    _i2.PostInclude? previous,
    _i2.PostInclude? next,
  }) {
    _previous = previous;
    _next = next;
  }

  _i2.PostInclude? _previous;

  _i2.PostInclude? _next;

  @override
  Map<String, _i1.Include?> get includes => {
        'previous': _previous,
        'next': _next,
      };

  @override
  _i1.Table get table => Post.t;
}

class PostIncludeList extends _i1.IncludeList {
  PostIncludeList._({
    _i1.WhereExpressionBuilder<PostTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Post.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Post.t;
}

class PostRepository {
  const PostRepository._();

  final attachRow = const PostAttachRowRepository._();

  final detachRow = const PostDetachRowRepository._();

  Future<List<Post>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PostTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PostTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PostTable>? orderByList,
    _i1.Transaction? transaction,
    PostInclude? include,
  }) async {
    return session.dbNext.find<Post>(
      where: where?.call(Post.t),
      orderBy: orderBy?.call(Post.t),
      orderByList: orderByList?.call(Post.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Post?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PostTable>? where,
    int? offset,
    _i1.OrderByBuilder<PostTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PostTable>? orderByList,
    _i1.Transaction? transaction,
    PostInclude? include,
  }) async {
    return session.dbNext.findFirstRow<Post>(
      where: where?.call(Post.t),
      orderBy: orderBy?.call(Post.t),
      orderByList: orderByList?.call(Post.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Post?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    PostInclude? include,
  }) async {
    return session.dbNext.findById<Post>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Post>> insert(
    _i1.Session session,
    List<Post> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<Post>(
      rows,
      transaction: transaction,
    );
  }

  Future<Post> insertRow(
    _i1.Session session,
    Post row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<Post>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Post>> update(
    _i1.Session session,
    List<Post> rows, {
    _i1.ColumnSelections<PostTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Post>(
      rows,
      columns: columns?.call(Post.t),
      transaction: transaction,
    );
  }

  Future<Post> updateRow(
    _i1.Session session,
    Post row, {
    _i1.ColumnSelections<PostTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Post>(
      row,
      columns: columns?.call(Post.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Post> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<Post>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Post row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<Post>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PostTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Post>(
      where: where(Post.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PostTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<Post>(
      where: where?.call(Post.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class PostAttachRowRepository {
  const PostAttachRowRepository._();

  Future<void> previous(
    _i1.Session session,
    Post post,
    _i2.Post previous,
  ) async {
    if (previous.id == null) {
      throw ArgumentError.notNull('previous.id');
    }
    if (post.id == null) {
      throw ArgumentError.notNull('post.id');
    }

    var $previous = previous.copyWith(nextId: post.id);
    await session.dbNext.updateRow<_i2.Post>(
      $previous,
      columns: [_i2.Post.t.nextId],
    );
  }

  Future<void> next(
    _i1.Session session,
    Post post,
    _i2.Post next,
  ) async {
    if (post.id == null) {
      throw ArgumentError.notNull('post.id');
    }
    if (next.id == null) {
      throw ArgumentError.notNull('next.id');
    }

    var $post = post.copyWith(nextId: next.id);
    await session.dbNext.updateRow<Post>(
      $post,
      columns: [Post.t.nextId],
    );
  }
}

class PostDetachRowRepository {
  const PostDetachRowRepository._();

  Future<void> previous(
    _i1.Session session,
    Post post,
  ) async {
    var $previous = post.previous;

    if ($previous == null) {
      throw ArgumentError.notNull('post.previous');
    }
    if ($previous.id == null) {
      throw ArgumentError.notNull('post.previous.id');
    }
    if (post.id == null) {
      throw ArgumentError.notNull('post.id');
    }

    var $$previous = $previous.copyWith(nextId: null);
    await session.dbNext.updateRow<_i2.Post>(
      $$previous,
      columns: [_i2.Post.t.nextId],
    );
  }

  Future<void> next(
    _i1.Session session,
    Post post,
  ) async {
    if (post.id == null) {
      throw ArgumentError.notNull('post.id');
    }

    var $post = post.copyWith(nextId: null);
    await session.dbNext.updateRow<Post>(
      $post,
      columns: [Post.t.nextId],
    );
  }
}
