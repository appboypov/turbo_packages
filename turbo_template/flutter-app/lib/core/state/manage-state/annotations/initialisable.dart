/// Annotation to mark a class as requiring async initialization.
///
/// Classes marked with this annotation should implement the [Initialisable]
/// mixin to provide standardized initialization behavior.
///
/// Usage:
/// ```dart
/// @initialisable
/// class MyService with Initialisable {
///   @override
///   Future<void> initialise() async {
///     // Perform async initialization
///     await loadData();
///     completeInitialisation();
///   }
/// }
/// ```
const initialisable = InitialisableMeta._();

/// Annotation class for marking initialisable services.
class InitialisableMeta {
  const InitialisableMeta._();
}
