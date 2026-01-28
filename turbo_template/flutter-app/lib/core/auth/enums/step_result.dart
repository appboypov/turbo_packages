/// Represents the result of a step execution.
///
/// Used to determine whether a step resulted in navigation or did nothing.
///
/// ```dart
/// final result = StepResult.didNavigate;
/// if (result == StepResult.didNavigate) {
///   print('Navigation occurred');
/// }
/// ```
enum StepResult { didNavigate, didNothing }
