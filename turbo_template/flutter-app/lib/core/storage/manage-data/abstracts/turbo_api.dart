import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:turbo_firestore_api/turbo_firestore_api.dart';
import 'package:turbo_flutter_template/core/shared/constants/t_values.dart';
import 'package:turbo_flutter_template/core/storage/manage-data/constants/firestore_collection.dart';

abstract class TurboApi<T extends Object> extends TFirestoreApi<T> {
  TurboApi({
    required FirestoreCollection firestoreCollection,
    String Function(FirestoreCollection firestoreCollection)? path,
  }) : super(
         firebaseFirestore: FirebaseFirestore.instance,
         collectionPath: () =>
             path?.call(firestoreCollection) ?? firestoreCollection.path(),
         documentReferenceFieldName: TValues.documentReference,
         fromJson: firestoreCollection.fromJson<T>(),
         isCollectionGroup: firestoreCollection.isCollectionGroup,
         logger: TFirestoreLogger(showSensitiveData: kDebugMode),
         toJson: firestoreCollection.toJson<T>(),
         tryAddLocalDocumentReference:
             firestoreCollection.tryAddLocalDocumentReference,
         tryAddLocalId: true,
       );
}
