/// Defines the type of Firestore operation being performed
///
/// This enum categorizes Firestore operations for enhanced error logging and debugging.
/// It helps identify what operation was being performed when an error occurred, making
/// it easier to diagnose permission issues, data access problems, and operation failures.
///
/// Example:
/// ```dart
/// try {
///   await api.createDoc(writeable: user);
/// } catch (error, stackTrace) {
///   final exception = TFirestoreException.fromFirestoreException(
///     error,
///     stackTrace,
///     path: 'users',
///     operationType: TOperationType.create,
///   );
///   // Exception will include operation type in error message
/// }
/// ```
enum TOperationType {
  /// Document or collection read operations
  ///
  /// Used for operations that retrieve data from Firestore without modifying it.
  /// Examples: `getById()`, `listAll()`, `listByQuery()`
  read,

  /// Generic write operations
  ///
  /// Used for operations that modify data in Firestore but don't fit into
  /// specific create/update/delete categories. This is a fallback for
  /// operations that perform writes.
  write,

  /// Document creation operations
  ///
  /// Used when creating new documents in Firestore.
  /// Examples: `createDoc()`, `createDocInBatch()`
  create,

  /// Document update operations
  ///
  /// Used when modifying existing documents in Firestore.
  /// Examples: `updateDoc()`, `updateDocInBatch()`
  update,

  /// Document deletion operations
  ///
  /// Used when removing documents from Firestore.
  /// Examples: `deleteDoc()`, `deleteDocInBatch()`
  delete,

  /// Real-time stream operations
  ///
  /// Used for operations that listen to real-time changes in Firestore.
  /// Examples: `streamAll()`, `streamByDocId()`, `streamDocByIdWithConverter()`
  stream,
}
