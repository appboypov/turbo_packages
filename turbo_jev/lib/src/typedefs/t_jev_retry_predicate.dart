import '../abstracts/t_jev_failure.dart';

/// Decides whether a [TJevRetryPolicy] retries [failure]: `true` retries it.
///
/// [retriesByDefault] is what the built-in rules of the policy decide for
/// [failure]: its statuses, connection failures and timeouts. The answer of
/// the predicate replaces that decision, so one place has the final say and
/// adding or removing a single case needs no copy of the built-in rules:
///
/// ```dart
/// TJevRetryPolicy(
///   predicate: (failure, retriesByDefault) => switch (failure) {
///     TJevHttpFailure(status: 409) => true,
///     TJevHttpFailure(status: 503) => false,
///     _ => retriesByDefault,
///   },
/// );
/// ```
///
/// A [TJevAbortedFailure] never reaches the predicate, and the max retries
/// and budget of the policy stop retries whatever it answers.
typedef TJevRetryPredicate =
    bool Function(
      TJevFailure failure,
      bool retriesByDefault,
    );
