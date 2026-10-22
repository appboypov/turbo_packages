part of '../abstracts/t_jev_failure.dart';

/// TypeSafe found the Request body does not match its schema (422).
final class TJevUnprocessableEntityFailure extends TJevHttpFailure {
  const TJevUnprocessableEntityFailure._({
    required super.status,
    required super.message,
    required super.requestId,
    required super.headers,
    required super.body,
    required this.details,
  });

  /// Each problem TypeSafe found, with its location in the Request; empty
  /// when the body lists none.
  final List<TJevValidationDetail> details;
}
