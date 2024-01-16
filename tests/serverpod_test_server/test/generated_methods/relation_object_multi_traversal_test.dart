import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Constructor - ', () {
    group(
        'Given two double linked objects when setting the origin side object in the constructor',
        () {
      var post3 = Post(id: 3, content: 'Post 3');
      var post2 = Post(id: 2, content: 'Post 2', next: post3);
      var post1 = Post(id: 1, content: 'Post 1', next: post2);

      test('then the id link is setup.', () {
        expect(post1.next?.nextId, 3);
        expect(post1.next?.previous?.nextId, 2);
      });

      test('then it is possible to traverse the chain forward multiple steps.',
          () {
        expect(post1.next?.next, post3);
      });

      test(
          'then it is possible to traverse the chain forward and backward ending up with the original object',
          () {
        expect(post1.next?.previous, post1);
      });

      test(
          'then it is possible to traverse the chain forward multiple times and then backwards.',
          () {
        expect(post1.next?.next?.previous, post2);
      });

      test(
          'then it is possible to start in the middle of the chain go back and then forward.',
          () {
        expect(post2.previous?.next?.next, post3);
      });

      test(
          'then it is possible to start at the end and traverse backwards to the start',
          () {
        expect(post3.previous?.previous, post1);
      });
    });

    group(
        'Given two double linked objects when setting the none origin side object in the constructor',
        () {
      var post1 = Post(id: 1, content: 'Post 1');
      var post2 = Post(id: 2, content: 'Post 2', previous: post1);
      var post3 = Post(id: 3, content: 'Post 3', previous: post2);

      test('then the id link is setup.', () {
        expect(post1.next?.nextId, 3);
        expect(post1.next?.previous?.nextId, 2);
      });

      test('then it is possible to traverse the chain forward multiple steps.',
          () {
        expect(post1.next?.next, post3);
      });

      test(
          'then it is possible to traverse the chain forward and backward ending up with the original object',
          () {
        expect(post1.next?.previous, post1);
      });

      test(
          'then it is possible to traverse the chain forward multiple times and then backwards.',
          () {
        expect(post1.next?.next?.previous, post2);
      });

      test(
          'then it is possible to start in the middle of the chain go back and then forward.',
          () {
        expect(post2.previous?.next?.next, post3);
      });

      test(
          'then it is possible to start at the end and traverse backwards to the start',
          () {
        expect(post3.previous?.previous, post1);
      });
    });
  });

  group('copyWith - ', () {
    group(
        'Given two double linked objects when setting the origin side object with the copyWith method',
        () {
      var post1 = Post(id: 1, content: 'Post 1');
      var post2 = Post(id: 2, content: 'Post 2');
      var post3 = Post(id: 3, content: 'Post 3');

      var clone1 = post1.copyWith(next: post2.copyWith(next: post3));
      var clone2 = post2.copyWith(previous: post1, next: post3);
      var clone3 = post3.copyWith(previous: post2.copyWith(previous: post1));

      test('then the id link is setup.', () {
        expect(clone1.next?.nextId, 3);
        expect(clone1.next?.previous?.nextId, 2);
      });

      test('then it is possible to traverse the chain forward multiple steps.',
          () {
        expect(clone1.next?.next?.content, 'Post 3');
      });

      test(
          'then it is possible to traverse the chain forward and backward ending up with the original object',
          () {
        expect(clone1.next?.previous?.content, 'Post 1');
      });

      test(
          'then it is possible to traverse the chain forward multiple times and then backwards.',
          () {
        expect(clone1.next?.next?.previous?.content, 'Post 2');
      });

      test(
          'then it is possible to start in the middle of the chain go back and then forward.',
          () {
        expect(clone2.previous?.next?.next?.content, 'Post 3');
      });

      test(
          'then it is possible to start at the end and traverse backwards to the start',
          () {
        expect(clone3.previous?.previous?.content, 'Post 1');
      });
    });
  });

  group('Setter - ', () {
    group(
        'Given two double linked objects when setting the origin side object with the setter method',
        () {
      var post1 = Post(id: 1, content: 'Post 1');
      var post2 = Post(id: 2, content: 'Post 2');
      var post3 = Post(id: 3, content: 'Post 3');

      post1.next = post2;
      post2.next = post3;

      test('then the id link is setup.', () {
        expect(post1.next?.nextId, 3);
        expect(post1.next?.previous?.nextId, 2);
      });

      test('then it is possible to traverse the chain forward multiple steps.',
          () {
        expect(post1.next?.next, post3);
      });

      test(
          'then it is possible to traverse the chain forward and backward ending up with the original object',
          () {
        expect(post1.next?.previous, post1);
      });

      test(
          'then it is possible to traverse the chain forward multiple times and then backwards.',
          () {
        expect(post1.next?.next?.previous, post2);
      });

      test(
          'then it is possible to start in the middle of the chain go back and then forward.',
          () {
        expect(post2.previous?.next?.next, post3);
      });

      test(
          'then it is possible to start at the end and traverse backwards to the start',
          () {
        expect(post3.previous?.previous, post1);
      });
    });

    group(
        'Given two double linked objects when setting the none origin side object with the setter method',
        () {
      var post1 = Post(id: 1, content: 'Post 1');
      var post2 = Post(id: 2, content: 'Post 2');
      var post3 = Post(id: 3, content: 'Post 3');

      post3.previous = post2;
      post2.previous = post1;

      test('then the id link is setup.', () {
        expect(post1.next?.nextId, 3);
        expect(post1.next?.previous?.nextId, 2);
      });

      test('then it is possible to traverse the chain forward multiple steps.',
          () {
        expect(post1.next?.next, post3);
      });

      test(
          'then it is possible to traverse the chain forward and backward ending up with the original object',
          () {
        expect(post1.next?.previous, post1);
      });

      test(
          'then it is possible to traverse the chain forward multiple times and then backwards.',
          () {
        expect(post1.next?.next?.previous, post2);
      });

      test(
          'then it is possible to start in the middle of the chain go back and then forward.',
          () {
        expect(post2.previous?.next?.next, post3);
      });

      test(
          'then it is possible to start at the end and traverse backwards to the start',
          () {
        expect(post3.previous?.previous, post1);
      });
    });
  });

  group('fromJson - ', () {
    group(
        'Given two double linked objects when setting the origin side object in the constructor',
        () {
      var post3 = Post(id: 3, content: 'Post 3');
      var post2 = Post(id: 2, content: 'Post 2', next: post3);
      var post1 = Post(id: 1, content: 'Post 1', next: post2);

      var protocol = Protocol();

      var jsonString1 = SerializationManager.encode(post1);

      print(jsonString1);

      var fromJson1 = Post.fromJson(jsonDecode(jsonString1), protocol);

      test('then the id link is setup.', () {
        expect(fromJson1.next?.nextId, 3);
        expect(fromJson1.next?.previous?.nextId, 2);
      });

      test('then it is possible to traverse the chain forward multiple steps.',
          () {
        expect(fromJson1.next?.next?.content, 'Post 3');
      });

      test(
          'then it is possible to traverse the chain forward and backward ending up with the original object',
          () {
        expect(fromJson1.next?.previous?.content, 'Post 1');
      });

      test(
          'then it is possible to traverse the chain forward multiple times and then backwards.',
          () {
        expect(fromJson1.next?.next?.previous?.content, 'Post 2');
      });

      test(
          'then it is possible to start in the middle of the chain go back and then forward.',
          () {
        var jsonString2 = SerializationManager.encode(post2.toJson());

        var fromJson2 = Post.fromJson(jsonDecode(jsonString2), protocol);

        print(fromJson2);

        expect(fromJson2.previous?.next?.next?.content, 'Post 3');
      });

      test(
          'then it is possible to start at the end and traverse backwards to the start',
          () {
        var jsonString3 = SerializationManager.encode(post3.toJson());

        print(jsonString3);

        var fromJson3 = Post.fromJson(jsonDecode(jsonString3), protocol);

        expect(fromJson3.previous?.previous?.content, 'Post 1');
      });
    });
  });
}
