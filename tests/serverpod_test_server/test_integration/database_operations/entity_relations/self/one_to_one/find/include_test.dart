import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given models with one to one relation', () {
    late List<Post> posts;

    setUp(() async {
      posts = await Post.db.insert(
        session,
        [
          Post(content: 'Hello world!'),
          Post(content: 'Hello again!'),
          Post(content: 'Hello a third time!'),
        ],
      );
      await Post.db.attachRow.next(session, posts[0], posts[1]);
      await Post.db.attachRow.next(session, posts[1], posts[2]);
    });

    tearDown(() async {
      await Post.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
        'when fetching models including relations then result includes relation data.',
        () async {
      var postsFetched = await Post.db.find(
        session,
        include: Post.include(next: Post.include()),
        orderBy: (t) => t.id,
      );

      expect(postsFetched[0].next?.content, 'Hello again!');
      expect(postsFetched[1].next?.content, 'Hello a third time!');
      expect(postsFetched[2].next, isNull);
    });

    test(
        'when fetching models including nested relation then result includes nested relation data.',
        () async {
      var postsFetched = await Post.db.findById(
        session,
        posts[0].id!,
        include: Post.include(next: Post.include(next: Post.include())),
      );

      expect(postsFetched?.next?.next?.content, 'Hello a third time!');
    });

    test(
        'when fetching models including nested relation then result has resolved the double linked dependency.',
        () async {
      var postsFetched = await Post.db.findById(
        session,
        posts[0].id!,
        include: Post.include(next: Post.include(next: Post.include())),
      );

      expect(postsFetched?.next?.previous?.content, 'Hello world!');
      expect(postsFetched?.next?.next?.previous?.content, 'Hello again!');
    });

    test(
        'when fetching models including nested relation then result has resolved the double linked dependency in the backwards direction.',
        () async {
      var postsFetched = await Post.db.findById(
        session,
        posts[2].id!,
        include: Post.include(previous: Post.include(previous: Post.include())),
      );

      expect(postsFetched?.previous?.next?.content, 'Hello a third time!');
      expect(postsFetched?.previous?.previous?.next?.content, 'Hello again!');
    });

    test(
        'when fetching models including nested relation then result has resolved the double linked dependency both backwards and forwards.',
        () async {
      var postFetched = await Post.db.findById(
        session,
        posts[1].id!,
        include: Post.include(next: Post.include(), previous: Post.include()),
      );

      expect(postFetched?.next?.previous?.content, 'Hello again!');
      expect(postFetched?.previous?.next?.content, 'Hello again!');
    });
  });
}
