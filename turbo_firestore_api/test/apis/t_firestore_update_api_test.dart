// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_firestore_api/apis/t_firestore_api.dart';
import 'package:turbo_response/turbo_response.dart';
import 'package:turbo_serializable/abstracts/t_writeable.dart';

/// Hand-rolled writeable that returns a preset map from [toJson].
class _MapWriteable extends TWriteable {
  _MapWriteable(this._json);

  final Map<String, dynamic> _json;

  @override
  Map<String, dynamic> toJson() => _json;
}

/// Captures `update(...)` calls on a delegated [DocumentReference] so tests
/// can inspect the exact map passed to Firestore.
// ignore: must_be_immutable
class _RecordingDocumentReference
    implements DocumentReference<Map<String, dynamic>> {
  _RecordingDocumentReference(this._inner);

  final DocumentReference<Map<String, dynamic>> _inner;
  Map<Object, Object?>? capturedUpdate;
  int updateCallCount = 0;

  @override
  Future<void> update(Map<Object, Object?> data) async {
    updateCallCount++;
    capturedUpdate = Map<Object, Object?>.from(data);
  }

  @override
  String get id => _inner.id;

  @override
  String get path => _inner.path;

  @override
  FirebaseFirestore get firestore => _inner.firestore;

  @override
  CollectionReference<Map<String, dynamic>> get parent => _inner.parent;

  @override
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) =>
      _inner.collection(collectionPath);

  @override
  Future<void> delete() => _inner.delete();

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([GetOptions? options]) =>
      _inner.get(options);

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots({
    bool includeMetadataChanges = false,
    ListenSource source = ListenSource.defaultSource,
  }) => _inner.snapshots(
    includeMetadataChanges: includeMetadataChanges,
    source: source,
  );

  @override
  Future<void> set(Map<String, dynamic> data, [SetOptions? options]) =>
      _inner.set(data, options);

  @override
  DocumentReference<R> withConverter<R>({
    required FromFirestore<R> fromFirestore,
    required ToFirestore<R> toFirestore,
  }) => _inner.withConverter<R>(
    fromFirestore: fromFirestore,
    toFirestore: toFirestore,
  );

  @override
  bool operator ==(Object other) =>
      other is _RecordingDocumentReference && other._inner == _inner;

  @override
  int get hashCode => _inner.hashCode;
}

/// Captures `update(...)` calls enqueued onto a [WriteBatch] so tests can
/// inspect the payload without committing.
class _RecordingWriteBatch implements WriteBatch {
  _RecordingWriteBatch();

  Map<Object, Object?>? capturedUpdate;
  int updateCallCount = 0;

  @override
  void update(DocumentReference<Object?> document, Map<Object, Object?> data) {
    updateCallCount++;
    capturedUpdate = Map<Object, Object?>.from(data);
  }

  @override
  Future<void> commit() async {}

  @override
  void delete(DocumentReference<Object?> document) {}

  @override
  void set<T>(
    DocumentReference<T> document,
    T data, [
    SetOptions? options,
  ]) {}
}

/// [TFirestoreApi] subclass that always hands out the same recording
/// [DocumentReference], so tests can capture the exact `update(...)` payload.
class _RecordingApi extends TFirestoreApi<TWriteable> {
  _RecordingApi({
    required super.firebaseFirestore,
    required super.collectionPath,
    required this.recordingRef,
  });

  final _RecordingDocumentReference recordingRef;

  @override
  DocumentReference<Map<String, dynamic>> getDocRefById({
    required String id,
    String? collectionPathOverride,
  }) {
    return recordingRef;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeFirebaseFirestore firestore;
  late _RecordingDocumentReference recordingRef;
  late _RecordingApi api;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    // Seed the document so `update()` would succeed on a real Firestore;
    // for the recording proxy this is purely to keep state realistic.
    final realRef = firestore.collection('users').doc('user-1');
    await realRef.set(<String, dynamic>{'a': 1, 'b': 2, 'c': 3});
    recordingRef = _RecordingDocumentReference(realRef);
    api = _RecordingApi(
      firebaseFirestore: firestore,
      collectionPath: () => 'users',
      recordingRef: recordingRef,
    );
  });

  group('TFirestoreApi.updateDoc', () {
    test(
      'Given previous and new writeables differ in one primitive, '
      'when updateDoc is called with previousWriteable, '
      'then the captured update receives only the changed key plus updatedAt',
      () async {
        final previous = _MapWriteable(<String, dynamic>{
          'a': 1,
          'b': 2,
          'c': 3,
        });
        final next = _MapWriteable(<String, dynamic>{'a': 1, 'b': 2, 'c': 99});

        final response = await api.updateDoc(
          writeable: next,
          previousWriteable: previous,
          id: 'user-1',
        );

        expect(response.isSuccess, isTrue);
        expect(recordingRef.updateCallCount, 1);
        final captured = recordingRef.capturedUpdate!;
        expect(captured['c'], 99);
        expect(captured.containsKey('a'), isFalse);
        expect(captured.containsKey('b'), isFalse);
        expect(captured.containsKey('updatedAt'), isTrue);
      },
    );

    test(
      'Given previous and new writeables produce identical maps, '
      'when updateDoc is called with previousWriteable, '
      'then update is never invoked and the response is success',
      () async {
        final previous = _MapWriteable(<String, dynamic>{'a': 1, 'b': 2});
        final next = _MapWriteable(<String, dynamic>{'a': 1, 'b': 2});

        final response = await api.updateDoc(
          writeable: next,
          previousWriteable: previous,
          id: 'user-1',
        );

        expect(response.isSuccess, isTrue);
        expect(recordingRef.updateCallCount, 0);
        expect(recordingRef.capturedUpdate, isNull);
      },
    );

    test(
      'Given a nested map differs only in one sibling, '
      'when updateDoc is called with previousWriteable, '
      'then the captured update uses dot notation and omits unchanged siblings',
      () async {
        final previous = _MapWriteable(<String, dynamic>{
          'profile': <String, dynamic>{
            'name': 'A',
            'email': 'a@x',
          },
        });
        final next = _MapWriteable(<String, dynamic>{
          'profile': <String, dynamic>{
            'name': 'B',
            'email': 'a@x',
          },
        });

        final response = await api.updateDoc(
          writeable: next,
          previousWriteable: previous,
          id: 'user-1',
        );

        expect(response.isSuccess, isTrue);
        final captured = recordingRef.capturedUpdate!;
        expect(captured['profile.name'], 'B');
        expect(captured.containsKey('profile.email'), isFalse);
        expect(captured.containsKey('profile'), isFalse);
      },
    );

    test(
      'Given previousWriteable is omitted, '
      'when updateDoc is called, '
      'then the captured update contains every key from the new payload',
      () async {
        final next = _MapWriteable(<String, dynamic>{
          'a': 1,
          'b': 2,
          'c': 99,
        });

        final response = await api.updateDoc(
          writeable: next,
          id: 'user-1',
        );

        expect(response.isSuccess, isTrue);
        final captured = recordingRef.capturedUpdate!;
        expect(captured['a'], 1);
        expect(captured['b'], 2);
        expect(captured['c'], 99);
        expect(captured.containsKey('updatedAt'), isTrue);
      },
    );

    test(
      'Given includeDeletes is true and a key is removed in the new map, '
      'when updateDoc is called with previousWriteable, '
      'then the captured update emits a FieldValue for the removed key',
      () async {
        final previous = _MapWriteable(<String, dynamic>{'a': 1, 'b': 2});
        final next = _MapWriteable(<String, dynamic>{'a': 1});

        final response = await api.updateDoc(
          writeable: next,
          previousWriteable: previous,
          id: 'user-1',
          includeDeletes: true,
        );

        expect(response.isSuccess, isTrue);
        final captured = recordingRef.capturedUpdate!;
        expect(captured['b'], isA<FieldValue>());
        expect(captured.containsKey('a'), isFalse);
      },
    );
  });

  group('TFirestoreApi.updateDocInBatch', () {
    test(
      'Given previous and new writeables produce identical maps, '
      'when updateDocInBatch is called with previousWriteable, '
      'then the batch is never enqueued and the response is success',
      () async {
        final previous = _MapWriteable(<String, dynamic>{'a': 1, 'b': 2});
        final next = _MapWriteable(<String, dynamic>{'a': 1, 'b': 2});
        final recordingBatch = _RecordingWriteBatch();

        final response = await api.updateDocInBatch(
          writeable: next,
          previousWriteable: previous,
          id: 'user-1',
          writeBatch: recordingBatch,
        );

        expect(response.isSuccess, isTrue);
        expect(recordingBatch.updateCallCount, 0);
        expect(recordingBatch.capturedUpdate, isNull);
      },
    );
  });
}
