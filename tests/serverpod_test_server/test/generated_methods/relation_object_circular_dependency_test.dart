import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a circular relational dependency graph from the origin side when converting object to json then an explicit error is thrown describing that it is not supported.',
      () {
    var post3 = Post(content: 'Post 3');
    var post2 = Post(content: 'Post 2', next: post3);
    var post1 = Post(content: 'Post 1', next: post2);

    post3.next = post1;

    expect(() => post1.toJson(), throwsA(isA<StateError>()));
  });

  test(
      'Given a circular relational dependency graph from the none-origin side when converting object to json then an explicit error is thrown describing that it is not supported.',
      () {
    var post1 = Post(content: 'Post 1');
    var post2 = Post(content: 'Post 2', previous: post1);
    var post3 = Post(content: 'Post 3', previous: post2);

    post1.previous = post3;

    expect(() => post1.toJson(), throwsA(isA<StateError>()));
  });

  test(
      'Given a none self-relational object structure with a circular dependency graph when converting to json then an error is thrown.',
      () {
    var town = Town(id: 1, name: 'Stockholm');
    var company = Company(
      id: 2,
      name: 'Serverpod',
      townId: town.id!,
      town: town,
    );
    var oldCompany = Company(
      id: 3,
      name: 'Old Company',
      townId: town.id!,
      town: town,
    );
    Citizen(
      name: 'Bob',
      companyId: company.id!,
      company: company,
      oldCompany: oldCompany,
    );
    var mayor = Citizen(
      name: 'Alice',
      companyId: oldCompany.id!,
      company: oldCompany,
    );
    town.mayor = mayor;

    expect(() => town.toJson(), throwsA(isA<StateError>()));
  });
}
