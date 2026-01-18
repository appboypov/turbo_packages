import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

export 'package:cloud_firestore/cloud_firestore.dart';

class DocumentReferenceConverter implements JsonConverter<DocumentReference, DocumentReference> {
  const DocumentReferenceConverter();

  @override
  DocumentReference fromJson(DocumentReference json) => json;

  @override
  DocumentReference toJson(DocumentReference object) => object;
}

class DocumentReferenceConverterNullable
    implements JsonConverter<DocumentReference?, DocumentReference?> {
  const DocumentReferenceConverterNullable();

  @override
  DocumentReference? fromJson(DocumentReference? json) => json;

  @override
  DocumentReference? toJson(DocumentReference? object) => object;
}
