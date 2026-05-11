import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/test.dart';
import 'package:turbo_firestore_api/util/t_map_diff.dart';

void main() {
  group('TMapDiff.diff', () {
    test(
      'Given a key added in after, '
      'when diffed against before without that key, '
      'then the new key is emitted at the top level',
      () {
        final before = <String, dynamic>{'a': 1};
        final after = <String, dynamic>{'a': 1, 'b': 2};

        final result = TMapDiff.diff(before: before, after: after);

        expect(result, {'b': 2});
      },
    );

    test(
      'Given a key removed in after with includeDeletes false, '
      'when diffed, '
      'then the result is empty',
      () {
        final before = <String, dynamic>{'a': 1, 'b': 2};
        final after = <String, dynamic>{'a': 1};

        final result = TMapDiff.diff(before: before, after: after);

        expect(result, isEmpty);
      },
    );

    test(
      'Given a key removed in after with includeDeletes true, '
      'when diffed, '
      'then the path maps to a FieldValue.delete sentinel',
      () {
        final before = <String, dynamic>{'a': 1, 'b': 2};
        final after = <String, dynamic>{'a': 1};

        final result = TMapDiff.diff(
          before: before,
          after: after,
          includeDeletes: true,
        );

        // FieldValue does not implement value equality and the public
        // runtimeType resolves to the abstract `FieldValue` (the
        // delete-specific subtype is private). Asserting `isA<FieldValue>()`
        // on the only emitted entry is the cleanest signal that the diff
        // produced a Firestore deletion sentinel.
        expect(result.keys, ['b']);
        expect(result['b'], isA<FieldValue>());
      },
    );

    test(
      'Given a primitive value changed, '
      'when diffed, '
      'then the new value is emitted at the top-level key',
      () {
        final before = <String, dynamic>{'a': 1};
        final after = <String, dynamic>{'a': 2};

        final result = TMapDiff.diff(before: before, after: after);

        expect(result, {'a': 2});
      },
    );

    test(
      'Given a nested field changed, '
      'when diffed, '
      'then a single dot-notation entry is emitted',
      () {
        final before = <String, dynamic>{
          'profile': <String, dynamic>{'name': 'old', 'age': 30},
        };
        final after = <String, dynamic>{
          'profile': <String, dynamic>{'name': 'new', 'age': 30},
        };

        final result = TMapDiff.diff(before: before, after: after);

        expect(result, {'profile.name': 'new'});
      },
    );

    test(
      'Given a list value changed, '
      'when diffed, '
      'then the whole list replaces the top-level key atomically',
      () {
        final before = <String, dynamic>{
          'tags': <int>[1, 2, 3],
        };
        final after = <String, dynamic>{
          'tags': <int>[1, 2, 4],
        };

        final result = TMapDiff.diff(before: before, after: after);

        expect(result, {
          'tags': <int>[1, 2, 4],
        });
      },
    );

    test(
      'Given an unchanged list, '
      'when diffed, '
      'then the result is empty',
      () {
        final before = <String, dynamic>{
          'tags': <int>[1, 2, 3],
        };
        final after = <String, dynamic>{
          'tags': <int>[1, 2, 3],
        };

        final result = TMapDiff.diff(before: before, after: after);

        expect(result, isEmpty);
      },
    );

    test(
      'Given an unchanged nested map, '
      'when diffed, '
      'then the result is empty',
      () {
        final before = <String, dynamic>{
          'profile': <String, dynamic>{'name': 'same', 'age': 30},
        };
        final after = <String, dynamic>{
          'profile': <String, dynamic>{'name': 'same', 'age': 30},
        };

        final result = TMapDiff.diff(before: before, after: after);

        expect(result, isEmpty);
      },
    );

    test(
      'Given before is null, '
      'when diffed, '
      'then a shallow copy of after is returned',
      () {
        final after = <String, dynamic>{
          'a': 1,
          'profile': <String, dynamic>{'name': 'x'},
        };

        final result = TMapDiff.diff(before: null, after: after);

        expect(result, {
          'a': 1,
          'profile': <String, dynamic>{'name': 'x'},
        });
      },
    );

    test(
      'Given a change three levels deep, '
      'when diffed, '
      'then a single dot-notation entry like a.b.d is emitted',
      () {
        final before = <String, dynamic>{
          'a': <String, dynamic>{
            'b': <String, dynamic>{'c': 1, 'd': 2},
          },
        };
        final after = <String, dynamic>{
          'a': <String, dynamic>{
            'b': <String, dynamic>{'c': 1, 'd': 99},
          },
        };

        final result = TMapDiff.diff(before: before, after: after);

        expect(result, {'a.b.d': 99});
      },
    );

    test(
      'Given a value type changed from int to string, '
      'when diffed, '
      'then the new value is emitted at the top-level key',
      () {
        final before = <String, dynamic>{'a': 1};
        final after = <String, dynamic>{'a': '1'};

        final result = TMapDiff.diff(before: before, after: after);

        expect(result, {'a': '1'});
      },
    );

    test(
      'Given a new nested branch where the key is missing in before, '
      'when diffed, '
      'then the whole nested map is emitted at the top-level key without recursion',
      () {
        final before = <String, dynamic>{'a': 1};
        final after = <String, dynamic>{
          'a': 1,
          'profile': <String, dynamic>{'name': 'x', 'age': 30},
        };

        final result = TMapDiff.diff(before: before, after: after);

        expect(result, {
          'profile': <String, dynamic>{'name': 'x', 'age': 30},
        });
      },
    );
  });
}
