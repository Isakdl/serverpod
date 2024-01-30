import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given two posts with ids when constructing the object by only setting the object field and not the foreign key field then the foreign key field is set to the id of the object.',
      () {
    var nextPost = Post(id: 2, content: 'Next post!');
    var post = Post(
      id: 1,
      content: 'Hello world!',
      next: nextPost,
    );

    expect(post.next, isNotNull);
    expect(post.nextId, 2);
  });

  test(
      'Given two posts with ids when constructing the object by only setting the object field and setting the foreign key field to another id then an ArgumentError is thrown.',
      () {
    var nextPost = Post(id: 2, content: 'Next post!');

    expect(
      () => Post(
        id: 1,
        content: 'Hello world!',
        next: nextPost,
        nextId: 5,
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test(
      'Given a post with the foreign key set to a value but the object field is set to null then the foreign key field has the original value.',
      () {
    var post = Post(
      content: 'Hello world!',
      nextId: 2,
    );

    expect(post.nextId, 2);
  });
  test(
      'Given two posts without an id when setting the nested object the foreign key field is set to null.',
      () {
    var post = Post(content: 'Hello world!');
    var nextPost = Post(content: 'Next post!');

    post.next = nextPost;

    expect(post.nextId, isNull);
  });

  test(
      'Given two posts with an id when setting the nested object the foreign key field is set to id of the object.',
      () {
    var post = Post(id: 1, content: 'Hello world!');
    var nextPost = Post(id: 2, content: 'Next post!');

    post.next = nextPost;

    expect(post.nextId, 2);
  });

  test(
      'Given two posts with an id when setting the nested object to null then the foreign key field is also set to null.',
      () {
    var nextPost = Post(id: 2, content: 'Next post!');
    var post = Post(id: 1, content: 'Hello world!', next: nextPost);

    post.next = null;

    expect(post.nextId, isNull);
  });

  test(
      'Given two nested posts with id set when explicitly setting the foreign key field to null then the relation object is also set to null.',
      () {
    var nextPost = Post(id: 2, content: 'Next post!');
    var post = Post(id: 1, content: 'Hello world!', next: nextPost);

    post.nextId = null;

    expect(post.next, isNull);
  });

  test(
      'Given two nested posts with id set when explicitly setting the foreign key field to another id then the relation object is set to null.',
      () {
    var nextPost = Post(id: 2, content: 'Next post!');
    var post = Post(id: 1, content: 'Hello world!', next: nextPost);

    post.nextId = 5;

    expect(post.next, isNull);
  });

  test(
      'Given two nested posts with id set when explicitly setting the foreign key field to the same id again then the relation object is also not modified.',
      () {
    var nextPost = Post(id: 2, content: 'Next post!');
    var post = Post(
      id: 1,
      content: 'Hello world!',
      next: nextPost,
    );

    post.nextId = 2;

    expect(post.next, nextPost);
  });

  test(
      'Given two posts with an id when using copyWith and setting the nested object then the foreign key field is set to id of the object.',
      () {
    var post = Post(id: 1, content: 'Hello world!');
    var nextPost = Post(id: 2, content: 'Next post!');

    var copy = post.copyWith(next: nextPost);

    expect(copy.nextId, 2);
  });

  test(
      'Given two posts without an id when using copyWith and setting the nested object then the foreign key field is set to id of the object.',
      () {
    var post = Post(content: 'Hello world!', nextId: 5);
    var nextPost = Post(content: 'Next post!');

    var copy = post.copyWith(next: nextPost);

    expect(copy.nextId, isNull);
  });

  test(
      'Given two posts without an id when using copyWith and setting the the foreign key field to the same value as it already is then the object field is not null.',
      () {
    var nextPost = Post(id: 2, content: 'Next post!');
    var post = Post(id: 1, content: 'Hello world!', next: nextPost);

    var copy = post.copyWith(nextId: 2);

    expect(copy.next, isNotNull);
  });

  test(
      'Given two posts without an id when using copyWith and setting the the foreign key field to another then the object field is null.',
      () {
    var nextPost = Post(id: 2, content: 'Next post!');
    var post = Post(id: 1, content: 'Hello world!', next: nextPost);

    var copy = post.copyWith(nextId: 5);

    expect(copy.next, isNull);
  });

  test(
      'Given an object where the object field and foreign key are given inconsistent values in the copyWith method then an ArgumentError is thrown.',
      () {
    var nextPost = Post(id: 2, content: 'Next post!');
    var post = Post(id: 1, content: 'Hello world!');

    expect(
      () => post.copyWith(nextId: 5, next: nextPost),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('test name', () {
    var stockholm = Town(id: 1, name: 'Stockholm');
    var company = Company(
      name: 'Serverpod',
      townId: stockholm.id!,
      town: stockholm,
    );

    expect(company.townId, 1);
    expect(company.town, stockholm);
  });

  test(
      'Given a none nullable relation when setting the object field that has an id defined then the foreign key field is updated.',
      () {
    var stockholm = Town(id: 1, name: 'Stockholm');
    var gothenburg = Town(id: 2, name: 'Gothenburg');
    var company = Company(
      name: 'Serverpod',
      townId: stockholm.id!,
      town: stockholm,
    );

    company.town = gothenburg;

    expect(company.townId, 2);
    expect(company.town?.name, 'Gothenburg');
  });

  test(
      'Given a none nullable relation when setting the object field that does not have the id field set then an error is thrown.',
      () {
    var stockholm = Town(id: 1, name: 'Stockholm');
    var gothenburg = Town(name: 'Gothenburg');
    var company = Company(
      name: 'Serverpod',
      townId: stockholm.id!,
      town: stockholm,
    );

    expect(() => company.town = gothenburg, throwsA(isA<ArgumentError>()));
  });

  test(
      'Given a none nullable relation when applying copyWith on the object field that does not have the id field set then an error is thrown.',
      () {
    var stockholm = Town(id: 1, name: 'Stockholm');
    var gothenburg = Town(name: 'Gothenburg');
    var company = Company(
      name: 'Serverpod',
      townId: stockholm.id!,
      town: stockholm,
    );

    expect(
      () => company.copyWith(town: gothenburg),
      throwsA(isA<ArgumentError>()),
    );
  });

  test(
      'Given a none nullable relation when creating an object with a object field that does not have the id field set then an error is thrown.',
      () {
    var gothenburg = Town(name: 'Gothenburg');

    expect(
      () => Company(
        name: 'Serverpod',
        townId: 1,
        town: gothenburg,
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test(
      'Given a none nullable relation when setting the object field to null the foreign key field is left as is.',
      () {
    var stockholm = Town(id: 1, name: 'Stockholm');

    var company = Company(
      name: 'Serverpod',
      townId: stockholm.id!,
      town: stockholm,
    );

    company.town = null;

    expect(company.townId, 1);
  });

  test(
      'Given a double linked required relation without ids when setting the origin side object in the constructor then an error is thrown.',
      () {
    var child = Child();

    expect(
        () => Parent(childId: 2, child: child), throwsA(isA<ArgumentError>()));
  });

  test(
      'Given a double linked required relation without ids when setting the origin side object with the copyWith method then an error is thrown.',
      () {
    var child = Child();
    var parent = Parent(childId: 2);

    expect(() => parent.copyWith(child: child), throwsA(isA<ArgumentError>()));
  });

  test(
      'Given a double linked required relation without ids when setting the origin side object with the setter method then an error is thrown.',
      () {
    var child = Child();
    var parent = Parent(childId: 2);

    expect(() => parent.child = child, throwsA(isA<ArgumentError>()));
  });

  test(
      'Given a double linked required relation with mismatching ids when setting the origin side object with the copyWith method then an error is thrown.',
      () {
    var child = Child(id: 3);
    var parent = Parent(childId: 2);

    expect(() => parent.copyWith(childId: 2, child: child),
        throwsA(isA<ArgumentError>()));
  });

  test(
      'Given a double linked relation with ids when setting the origin side in the constructor then the object field is set on the origin side.',
      () {
    var child = Child(id: 2);
    var parent = Parent(id: 1, childId: 2, child: child);

    expect(parent.child?.parent, parent);
  });

  test(
      'Given a double linked relation with ids when setting the origin side in the setter method then the object field is set on the origin side.',
      () {
    var child = Child(id: 2);
    var parent = Parent(id: 1, childId: 3);

    parent.child = child;

    expect(parent.child?.parent, parent);
  });

  test(
      'Given a double linked relation with ids when setting the origin side in the copyWith method then the object field is set on the origin side.',
      () {
    var child = Child(id: 2);
    var parent = Parent(id: 1, childId: 3);

    var copy = parent.copyWith(child: child);

    expect(copy.child?.parent?.id, 1);
  });

  test('Given a double linked relation with ids when setting the origin side in the fromJson constructor then the object field is set on the origin side.', () {
    var child = Child(id: 2);
    var parent = Parent(id: 1, childId: 2, child: child);

    var protocol = Protocol();
    var jsonString = SerializationManager.encode(parent.toJson());

    var fromJson = Parent.fromJson(jsonDecode(jsonString), protocol);

    expect(fromJson.child?.parent, fromJson);
  });
}
