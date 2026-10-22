import '../results/t_jev_failure.dart';

/// Decides whether a [TJevRetryPolicy] retries [failure]: `true` retries it.
typedef TJevRetryPredicate = bool Function(TJevFailure failure);
