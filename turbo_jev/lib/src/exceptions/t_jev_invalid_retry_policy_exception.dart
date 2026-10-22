part of '../abstracts/t_jev_exception.dart';

/// Thrown when a [TJevRetryPolicy] is created with an invalid value.
final class TJevInvalidRetryPolicyException extends TJevException {
  const TJevInvalidRetryPolicyException({required this.message});

  /// What is wrong with the policy.
  @override
  final String message;

  @override
  String toString() => 'TJevInvalidRetryPolicyException{message: $message}';
}
