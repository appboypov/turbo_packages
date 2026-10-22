/// Thrown when a [TJevRetryPolicy] is created with an invalid value.
final class TJevInvalidRetryPolicyException implements Exception {
  const TJevInvalidRetryPolicyException({required this.reason});

  /// What is wrong with the policy.
  final String reason;

  @override
  String toString() => 'TJevInvalidRetryPolicyException{reason: $reason}';
}
