import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

/// A utility class for computing Firestore-friendly diffs between two map
/// snapshots.
///
/// Returns a Firestore update()-ready map of dot-notation field paths
/// representing the difference between [before] and [after].
///
/// - [before] null  -> shallow copy of [after]
/// - deeply equal   -> {} (caller skips write)
/// - nested maps    -> flattened with dot notation (siblings preserved)
/// - lists          -> atomic replace if not deep-equal
/// - removed keys   -> FieldValue.delete() ONLY when [includeDeletes] is true
class TMapDiff {
  /// Returns a Firestore update()-ready map of dot-notation field paths
  /// representing the difference between [before] and [after].
  ///
  /// Behavior:
  /// - When [before] is `null`, returns a shallow copy of [after] (top-level
  ///   keys emitted as-is, no flattening).
  /// - When [before] is deeply equal to [after], returns an empty map so
  ///   callers can skip the write entirely.
  /// - For each key in [after]:
  ///   - If [before] does not contain the key, emits `{key: afterValue}` at
  ///     the current dot-notation path (no recursion when one side is absent).
  ///   - If both `beforeValue` and `afterValue` are `Map<String, dynamic>`,
  ///     recurses with prefix `${currentPath}.${key}`.
  ///   - Else if `DeepCollectionEquality().equals(beforeValue, afterValue)`,
  ///     skips the entry.
  ///   - Else emits `{path: afterValue}`.
  /// - When [includeDeletes] is `true`, also walks keys present in [before]
  ///   but missing from [after] and emits `{path: FieldValue.delete()}`.
  /// - Lists are not recursed into; they are compared atomically by
  ///   [DeepCollectionEquality] and replaced wholesale if not equal.
  static Map<String, Object?> diff({
    required Map<String, dynamic>? before,
    required Map<String, dynamic> after,
    bool includeDeletes = false,
  }) {
    if (before == null) {
      return Map<String, Object?>.from(after);
    }
    const equality = DeepCollectionEquality();
    if (equality.equals(before, after)) {
      return <String, Object?>{};
    }
    final result = <String, Object?>{};
    _collect(
      before: before,
      after: after,
      prefix: '',
      includeDeletes: includeDeletes,
      result: result,
      equality: equality,
    );
    return result;
  }

  static void _collect({
    required Map<String, dynamic> before,
    required Map<String, dynamic> after,
    required String prefix,
    required bool includeDeletes,
    required Map<String, Object?> result,
    required DeepCollectionEquality equality,
  }) {
    for (final entry in after.entries) {
      final key = entry.key;
      final afterValue = entry.value;
      final path = prefix.isEmpty ? key : '$prefix.$key';
      if (!before.containsKey(key)) {
        result[path] = afterValue;
        continue;
      }
      final beforeValue = before[key];
      if (beforeValue is Map<String, dynamic> &&
          afterValue is Map<String, dynamic>) {
        _collect(
          before: beforeValue,
          after: afterValue,
          prefix: path,
          includeDeletes: includeDeletes,
          result: result,
          equality: equality,
        );
        continue;
      }
      if (equality.equals(beforeValue, afterValue)) {
        continue;
      }
      result[path] = afterValue;
    }
    if (includeDeletes) {
      for (final key in before.keys) {
        if (after.containsKey(key)) continue;
        final path = prefix.isEmpty ? key : '$prefix.$key';
        result[path] = FieldValue.delete();
      }
    }
  }
}
