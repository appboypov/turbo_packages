import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:turbo_firestore_api/models/t_filter_input.dart';
import 'package:turbo_firestore_api/turbo_firestore_api.dart';
import 'package:turbo_serializable/abstracts/t_writeable_id.dart';

class TFirestoreCollection<DTO extends TWriteableId> {
  const TFirestoreCollection({
    required this.apiName,
    required this.collectionName,
    required this.fromJson,
    required this.toJson,
    this.createdAtFieldName = TFirestoreApiDefaults.createdAtFieldName,
    this.documentReferenceFieldName =
        TFirestoreApiDefaults.documentReferenceFieldName,
    this.fromJsonError,
    this.idFieldName = TFirestoreApiDefaults.idFieldName,
    this.isCollectionGroup = TFirestoreApiDefaults.isCollectionGroup,
    this.tryAddLocalDocumentReference =
        TFirestoreApiDefaults.tryAddLocalDocumentReference,
    this.tryAddLocalId = TFirestoreApiDefaults.tryAddLocalId,
    this.updatedAtFieldName = TFirestoreApiDefaults.updatedAtFieldName,
    this.defaultIdValue = TFirestoreApiDefaults.defaultIdValue,
    this.unknownIdValue = TFirestoreApiDefaults.unknownValueValue,
    this.userIdFieldName = TFirestoreApiDefaults.userIdFieldName,
    this.tryCache = false,
    this.forceCacheRefresh = false,
    this.unknownValueValue = TFirestoreApiDefaults.unknownValueValue,
  });

  final DTO Function(Map<String, dynamic> json) fromJson;
  final DTO Function(Map<String, dynamic> json)? fromJsonError;
  final Map<String, dynamic> Function(DTO value) toJson;
  final String apiName;
  final String collectionName;
  final String createdAtFieldName;
  final String defaultIdValue;
  final String documentReferenceFieldName;
  final String idFieldName;
  final String unknownIdValue;
  final String unknownValueValue;
  final String updatedAtFieldName;
  final String userIdFieldName;
  final bool isCollectionGroup;
  final bool tryAddLocalDocumentReference;
  final bool tryAddLocalId;
  final bool tryCache;
  final bool forceCacheRefresh;

  TFirestoreApi<DTO> api({
    FirebaseFirestore? firebaseFirestore,
    GetOptions? getOptions,
    String Function(String collectionName)? path,
    TFirestoreLogger? logger,
    bool? isCollectionGroup,
    IFirestoreCacheService? firestoreCacheService,
    bool? forceCacheRefresh,
  }) => TFirestoreApi<DTO>(
    firestoreCache: firestoreCacheService != null
        ? TFirestoreCache(
            firestoreCacheService: firestoreCacheService,
            forceCacheRefresh: forceCacheRefresh ?? this.forceCacheRefresh,
          )
        : null,
    userIdFieldName: userIdFieldName,
    defaultIdValue: defaultIdValue,
    unknownIdValue: unknownIdValue,
    collectionPath: () => path?.call(collectionName) ?? collectionName,
    createdAtFieldName: createdAtFieldName,
    documentReferenceFieldName: documentReferenceFieldName,
    firebaseFirestore: firebaseFirestore ?? FirebaseFirestore.instance,
    fromJson: fromJson,
    fromJsonError: fromJsonError,
    getOptions: getOptions,
    idFieldName: idFieldName,
    isCollectionGroup: isCollectionGroup ?? this.isCollectionGroup,
    logger: logger,
    toJson: toJson,
    tryAddLocalDocumentReference: tryAddLocalDocumentReference,
    tryAddLocalId: tryAddLocalId,
    updatedAtFieldName: updatedAtFieldName,
  );

  TCollectionService<DTO, MODEL> collectionService<MODEL extends TModel<DTO>>({
    required TCollectionModelBuilderDef<DTO, MODEL> modelBuilder,
    TModelDocsBuilderDef<DTO, MODEL>? modelDocsBuilder,
    TCollectionApiBuilderDef<DTO, MODEL>? apiBuilder,
    TCollectionStreamBuilderDef<DTO, MODEL>? streamBuilder,
    TCollectionValueBuilderDef<DTO, MODEL>? initialValue,
    TCollectionValueBuilderDef<DTO, MODEL>? defaultValue,
    IFirestoreCacheService? firestoreCacheService,
    bool initialiseStream = true,
    TSortOption? initialSort,
    Set<TFilterInput>? initialFilters,
    List<Future> Function(User user)? readyDeps,
  }) => TCollectionService<DTO, MODEL>(
    initialFilters: initialFilters,
    readyDeps: readyDeps,
    initialSort: initialSort,
    modelBuilder: modelBuilder,
    modelDocsBuilder: modelDocsBuilder,
    collection: this,
    firestoreCacheService: firestoreCacheService,
    apiBuilder: apiBuilder,
    defaultValue: defaultValue,
    initialValue: initialValue,
    streamBuilder: streamBuilder,
    initialiseStream: initialiseStream,
  );

  TDocService<DTO, MODEL> docService<MODEL extends TModel<DTO>>({
    required TDocValueBuilderDef<DTO, MODEL> defaultValue,
    required TDocModelBuilderDef<DTO, MODEL> modelBuilder,
    TDocApiBuilderDef<DTO, MODEL>? apiBuilder,
    TDocStreamBuilderDef<DTO, MODEL>? streamBuilder,
    TDocValueBuilderDef<DTO, MODEL>? initialValue,
    IFirestoreCacheService? firestoreCacheService,
    ValueChanged<DTO?>? afterLocalNotifyUpdate,
    ValueChanged<DTO?>? beforeLocalNotifyUpdate,
    bool initialiseStream = TFirestoreApiDefaults.initialiseStream,
    TDocValueBuilderDef<DTO, MODEL>? onMissingRemoteValue,
    List<Future> Function(User user)? readyDeps,
  }) => TDocService<DTO, MODEL>(
    modelBuilder: modelBuilder,
    readyDeps: readyDeps,
    collection: this,
    firestoreCacheService: firestoreCacheService,
    afterLocalNotifyUpdate: afterLocalNotifyUpdate,
    beforeLocalNotifyUpdate: beforeLocalNotifyUpdate,
    apiBuilder: apiBuilder,
    defaultValue: defaultValue,
    initialValue: initialValue,
    streamBuilder: streamBuilder,
    initialiseStream: initialiseStream,
    onMissingRemoteValue: onMissingRemoteValue,
  );
}
