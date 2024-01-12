import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given two double linked objects when setting the origin side object in the constructor then the other side links back to this.',
      () {
    var nextPost = Post(id: 2, content: 'Next post!');
    var post = Post(id: 1, content: 'Hello world!', next: nextPost);

    expect(post.next?.previous?.content, contains('Hello world!'));
  });

  test(
      'Given two double linked objects when setting the origin side object with copyWith then the other side links back to this.',
      () {
    var nextPost = Post(id: 2, content: 'Next post!');
    var post = Post(id: 1, content: 'Hello world!');

    var copy = post.copyWith(next: nextPost);

    expect(copy.next?.previous?.content, contains('Hello world!'));
  });

  test(
      'Given two double linked objects when setting the origin side object with setter then the other side links back to this.',
      () {
    var nextPost = Post(id: 2, content: 'Next post!');
    var post = Post(id: 1, content: 'Hello world!');

    post.next = nextPost;

    expect(post.next?.previous?.content, contains('Hello world!'));
  });

  test(
      'Given two double linked objects when setting the none origin side object in the constructor then the other side has the object and id set',
      () {
    var previousPost = Post(id: 2, content: 'Previous post!');
    var post = Post(id: 1, content: 'Hello world!', previous: previousPost);

    expect(post.previous?.next?.content, contains('Hello world!'));
    expect(post.previous?.nextId, 1);
  });

  test(
      'Given two double linked objects when setting the none origin side object with copyWith then the other side has the object and id set.',
      () {
    var previousPost = Post(id: 2, content: 'Previous post!');
    var post = Post(id: 1, content: 'Hello world!');

    var copy = post.copyWith(previous: previousPost);

    expect(copy.previous?.next?.content, contains('Hello world!'));
    expect(copy.previous?.nextId, 1);
  });

  test(
      'Given two double linked objects when setting the none origin side object with setter then the other side has the object and id set.',
      () {
    var previousPost = Post(id: 2, content: 'Previous post!');
    var post = Post(id: 1, content: 'Hello world!');

    post.previous = previousPost;

    expect(post.previous?.next?.content, contains('Hello world!'));
    expect(post.previous?.nextId, 1);
  });

  test(
      'Given two double linked objects without an id when setting the none origin side object in the constructor then the other side the foreign key field set to null.',
      () {
    var previousPost = Post(content: 'Previous post!');
    var post = Post(content: 'Hello world!', previous: previousPost);

    expect(post.previous?.nextId, isNull);
  });

  test(
      'Given two double linked objects without an id when setting the none origin side object with copyWith then the other side has the foreign key field set to null.',
      () {
    var previousPost = Post(content: 'Previous post!');
    var post = Post(content: 'Hello world!');

    var copy = post.copyWith(previous: previousPost);

    expect(copy.previous?.nextId, isNull);
  });

  test(
      'Given two double linked objects without an id when setting the none origin side object with setter then the other side has the foreign key field set to null.',
      () {
    var previousPost = Post(content: 'Previous post!');
    var post = Post(content: 'Hello world!');

    post.previous = previousPost;

    expect(post.previous?.nextId, isNull);
  });

  test(
      'Given a double linked required relation without ids when setting the none origin side object in the constructor then an error is thrown.',
      () {
    var parent = Parent(childId: 2);

    expect(() => Child(parent: parent), throwsA(isA<ArgumentError>()));
  });

  test(
      'Given a double linked required relation without ids when setting the none origin side object with the copyWith method then an error is thrown.',
      () {
    var parent = Parent(childId: 2);
    var child = Child(parent: parent);

    expect(() => child.copyWith(parent: parent), throwsA(isA<ArgumentError>()));
  });

  test(
      'Given a double linked required relation without ids when setting the none origin side object with the setter method then an error is thrown.',
      () {
    var parent = Parent(childId: 2);
    var child = Child(parent: parent);

    expect(() => child.parent = parent, throwsA(isA<ArgumentError>()));
  });
}
