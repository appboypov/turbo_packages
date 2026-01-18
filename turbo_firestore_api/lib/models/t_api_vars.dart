/// An abstract class that defines the core variables required for Turbo Firestore documents.
///
/// [id] - The unique identifier for the document
/// [now] - The timestamp when the document was created/updated
class TApiVars {
  const TApiVars({
    required this.id,
    required this.now,
  });

  final String id;
  final DateTime now;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TApiVars && runtimeType == other.runtimeType && id == other.id && now == other.now;

  @override
  int get hashCode => id.hashCode ^ now.hashCode;

  @override
  String toString() {
    return 'TurboApiVars{id: $id, now: $now}';
  }
}
