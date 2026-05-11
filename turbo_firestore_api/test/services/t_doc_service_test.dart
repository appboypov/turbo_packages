// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_firestore_api/abstracts/t_model.dart';
import 'package:turbo_firestore_api/apis/t_firestore_api.dart';
import 'package:turbo_firestore_api/enums/t_timestamp_type.dart';
import 'package:turbo_firestore_api/models/t_firestore_collection.dart';
import 'package:turbo_firestore_api/services/t_doc_service.dart';
import 'package:turbo_response/turbo_response.dart';
import 'package:turbo_serializable/abstracts/t_writeable.dart';
import 'package:turbo_serializable/abstracts/t_writeable_id.dart';

/// Hand-rolled DTO that returns a preset map from [toJson].
class _TestDto extends TWriteableId {
  _TestDto({required this.id, required this.values});

  @override
  final String id;
  final Map<String, dynamic> values;

  @override
  Map<String, dynamic> toJson() => Map<String, dynamic>.from(values);

  _TestDto copyWith({Map<String, dynamic>? values}) =>
      _TestDto(id: id, values: values ?? this.values);
}

/// Wrapper writeable produced by the [remoteUpdateRequestBuilder] in tests so
/// the recorded `previousWriteable` payload differs from the raw DTO.
class _WrappedWriteable extends TWriteable {
  _WrappedWriteable(this._inner);

  final _TestDto _inner;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'wrapped': _inner.toJson(),
      };
}

class _TestModel extends TModel<_TestDto> {
  const _TestModel({required super.dto});
}

/// [TFirestoreApi] subclass that records every [updateDoc] call so the test
/// can inspect the [previousWriteable] argument the service passed in.
class _RecordingFirestoreApi extends TFirestoreApi<_TestDto> {
  _RecordingFirestoreApi({
    required super.firebaseFirestore,
    required super.collectionPath,
  });

  TWriteable? recordedWriteable;
  TWriteable? recordedPreviousWriteable;
  bool didRecordCall = false;
  int updateCallCount = 0;

  @override
  Future<TurboResponse<DocumentReference>> updateDoc({
    required TWriteable writeable,
    required String id,
    TWriteable? previousWriteable,
    WriteBatch? writeBatch,
    TTimestampType timestampType = TTimestampType.updatedAt,
    String? collectionPathOverride,
    Transaction? transaction,
    bool includeDeletes = false,
  }) async {
    updateCallCount++;
    didRecordCall = true;
    recordedWriteable = writeable;
    recordedPreviousWriteable = previousWriteable;
    final ref = getDocRefById(id: id);
    return TurboResponse.success(result: ref);
  }
}

/// Public-API wrapper that exposes the protected [updateDoc] for tests.
class _TestableDocService extends TDocService<_TestDto, _TestModel> {
  _TestableDocService({
    required super.defaultValue,
    required super.modelBuilder,
    required super.apiBuilder,
    super.initialValue,
    required TFirestoreCollection<_TestDto> collection,
  }) : super(collection: collection, initialiseStream: false);

  Future<TurboResponse<_TestDto>> publicUpdateDoc({
    required String id,
    required _TestDto Function(_TestModel current) update,
    TWriteable Function(_TestDto doc)? remoteUpdateRequestBuilder,
  }) {
    return updateDoc(
      id: id,
      doc: (current, _) => update(current),
      remoteUpdateRequestBuilder: remoteUpdateRequestBuilder,
    );
  }
}

TFirestoreCollection<_TestDto> _buildCollection() => TFirestoreCollection<_TestDto>(
      apiName: 'test',
      collectionName: 'tests',
      fromJson: (json) =>
          _TestDto(id: json['id'] as String, values: Map<String, dynamic>.from(json)),
      toJson: (dto) => dto.toJson(),
    );

_TestableDocService _buildService({
  required _RecordingFirestoreApi recordingApi,
  _TestDto? initialDto,
}) {
  final collection = _buildCollection();
  return _TestableDocService(
    collection: collection,
    apiBuilder: (_, __, ___, ____) => recordingApi,
    defaultValue: (vars, _, __) =>
        _TestDto(id: vars.defaultId, values: const <String, dynamic>{}),
    initialValue: initialDto == null ? null : (_, __, ___) => initialDto,
    modelBuilder: (_, __, dto) => _TestModel(dto: dto),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeFirebaseFirestore firestore;
  late _RecordingFirestoreApi recordingApi;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    recordingApi = _RecordingFirestoreApi(
      firebaseFirestore: firestore,
      collectionPath: () => 'tests',
    );
  });

  group('TDocService.updateDoc', () {
    test(
      'Given the notifier holds a DTO with a known shape, '
      'when updateDoc mutates one field, '
      'then the recorded previousWriteable serializes to the pre-mutation map',
      () async {
        final initial = _TestDto(
          id: 'doc-1',
          values: const <String, dynamic>{'a': 1, 'b': 2},
        );
        final service = _buildService(
          recordingApi: recordingApi,
          initialDto: initial,
        );

        final response = await service.publicUpdateDoc(
          id: 'doc-1',
          update: (current) => current.dto.copyWith(
            values: <String, dynamic>{'a': 1, 'b': 3},
          ),
        );

        expect(response.isSuccess, isTrue);
        expect(recordingApi.updateCallCount, 1);
        expect(recordingApi.recordedPreviousWriteable, isNotNull);
        expect(
          recordingApi.recordedPreviousWriteable!.toJson(),
          <String, dynamic>{'a': 1, 'b': 2},
        );
        expect(
          recordingApi.recordedWriteable!.toJson(),
          <String, dynamic>{'a': 1, 'b': 3},
        );

        await service.dispose();
      },
    );

    test(
      'Given no initial DTO is provided so the notifier holds the default value, '
      'when updateDoc is called, '
      'then the recorded previousWriteable is the default DTO captured before the local mutation',
      () async {
        final service = _buildService(recordingApi: recordingApi);

        final response = await service.publicUpdateDoc(
          id: 'doc-1',
          update: (current) => current.dto.copyWith(
            values: <String, dynamic>{'a': 1},
          ),
        );

        expect(response.isSuccess, isTrue);
        expect(recordingApi.updateCallCount, 1);
        // The default DTO is captured prior to the local mutation; its payload
        // must be the empty default map, not the post-mutation map.
        expect(recordingApi.recordedPreviousWriteable, isNotNull);
        expect(
          recordingApi.recordedPreviousWriteable!.toJson(),
          isEmpty,
        );
        expect(
          recordingApi.recordedWriteable!.toJson(),
          <String, dynamic>{'a': 1},
        );

        await service.dispose();
      },
    );

    test(
      'Given a remoteUpdateRequestBuilder that wraps the DTO into a different shape, '
      'when updateDoc is called against an existing previous DTO, '
      'then the recorded previousWriteable is the builder output for the previous DTO (not the raw DTO)',
      () async {
        final initial = _TestDto(
          id: 'doc-1',
          values: const <String, dynamic>{'a': 1},
        );
        final service = _buildService(
          recordingApi: recordingApi,
          initialDto: initial,
        );

        final response = await service.publicUpdateDoc(
          id: 'doc-1',
          update: (current) => current.dto.copyWith(
            values: <String, dynamic>{'a': 2},
          ),
          remoteUpdateRequestBuilder: _WrappedWriteable.new,
        );

        expect(response.isSuccess, isTrue);
        expect(recordingApi.updateCallCount, 1);
        expect(recordingApi.recordedPreviousWriteable, isA<_WrappedWriteable>());
        expect(
          recordingApi.recordedPreviousWriteable!.toJson(),
          <String, dynamic>{
            'wrapped': <String, dynamic>{'a': 1},
          },
        );
        expect(recordingApi.recordedWriteable, isA<_WrappedWriteable>());
        expect(
          recordingApi.recordedWriteable!.toJson(),
          <String, dynamic>{
            'wrapped': <String, dynamic>{'a': 2},
          },
        );

        await service.dispose();
      },
    );
  });
}
