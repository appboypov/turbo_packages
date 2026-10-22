import 'dart:math';

import 'package:meta/meta.dart';

import '../exceptions/t_jev_invalid_retry_policy_exception.dart';
import '../results/t_jev_failure.dart';
import '../typedefs/t_jev_retry_predicate.dart';
import '../utils/retry_after.dart';

/// When a client sends a failed Request again and how long it waits first.
///
/// ```dart
/// final jev = TJev(retry: TJevRetryPolicy(maxRetries: 4));
/// ```
final class TJevRetryPolicy {
  /// Creates a policy; every argument has the default of both official SDKs.
  ///
  /// A failure is retried when its HTTP status is in [statuses], when it is
  /// a [TJevConnectionFailure] and [retryConnectionFailures] is on, when it
  /// is a [TJevTimeoutFailure] and [retryTimeouts] is on, or when
  /// [predicate] returns `true` for it. A [TJevAbortedFailure] is never
  /// retried.
  ///
  /// Throws [TJevInvalidRetryPolicyException] when [maxRetries] or a delay
  /// is negative, [jitter] is outside 0 to 1, a status is outside 100 to 999
  /// or [budget] is not positive.
  TJevRetryPolicy({
    this.maxRetries = 2,
    this.initialBackoff = const Duration(milliseconds: 500),
    this.maxBackoff = const Duration(seconds: 5),
    this.jitter = 0.25,
    Set<int>? statuses,
    this.respectRetryAfter = true,
    this.maxRetryAfter = const Duration(seconds: 60),
    this.retryConnectionFailures = true,
    this.retryTimeouts = true,
    this.predicate,
    this.budget = const Duration(seconds: 30),
  }) : statuses = Set.unmodifiable(
         statuses ??
             {408, 429, for (var status = 500; status < 600; status++) status},
       ) {
    if (maxRetries < 0) _fail('maxRetries must not be negative.');
    if (initialBackoff.isNegative) {
      _fail('initialBackoff must not be negative.');
    }
    if (maxBackoff.isNegative) _fail('maxBackoff must not be negative.');
    if (maxRetryAfter.isNegative) _fail('maxRetryAfter must not be negative.');
    if (!(jitter >= 0 && jitter <= 1)) _fail('jitter must be between 0 and 1.');
    if (this.statuses.any((status) => status < 100 || status > 999)) {
      _fail('statuses must be HTTP statuses from 100 to 999.');
    }
    if (budget case final budget? when budget <= Duration.zero) {
      _fail('budget must be positive.');
    }
  }

  /// How many times a failed Request is sent again; `0` turns retries off.
  final int maxRetries;

  /// The backoff before the first retry, doubled for each next retry.
  final Duration initialBackoff;

  /// The longest backoff, before [jitter].
  final Duration maxBackoff;

  /// The fraction of each backoff that is randomly taken off, from 0 to 1.
  final double jitter;

  /// The HTTP statuses that are retried, by default 408, 429 and 500 to 599.
  final Set<int> statuses;

  /// Whether a delay TypeSafe asks for, in `retry-after-ms` or
  /// `Retry-After`, replaces the backoff when it is at most [maxRetryAfter].
  final bool respectRetryAfter;

  /// The longest delay TypeSafe may ask for; a longer one falls back to the
  /// backoff.
  final Duration maxRetryAfter;

  /// Whether a [TJevConnectionFailure] is retried.
  final bool retryConnectionFailures;

  /// Whether a [TJevTimeoutFailure] is retried.
  final bool retryTimeouts;

  /// Retries a failure the other rules leave out when it returns `true`.
  final TJevRetryPredicate? predicate;

  /// The total time of a call, its attempts and waits included, that no
  /// retry starts past: retries stop before a wait that would reach it.
  /// `null` turns the limit off.
  final Duration? budget;

  /// Whether [failure] is sent again, retries left aside.
  @internal
  bool retries(TJevFailure failure) => switch (failure) {
    TJevAbortedFailure() => false,
    _ => _retriesByRule(failure) || (predicate?.call(failure) ?? false),
  };

  /// How long to wait after [failure] of the zero-based [attempt] before the
  /// next attempt.
  ///
  /// It is the delay TypeSafe asks for when [respectRetryAfter] allows it,
  /// else `min(initialBackoff * 2^attempt, maxBackoff)` with up to [jitter]
  /// of it taken off at random.
  @internal
  Duration delayAfter({
    required int attempt,
    required TJevFailure failure,
    required Random random,
  }) {
    if (respectRetryAfter && failure is TJevHttpFailure) {
      final serverDelay = retryAfterOf(failure.headers);
      if (serverDelay != null && serverDelay <= maxRetryAfter) {
        return serverDelay;
      }
    }
    return _backoff(attempt) * (1 - random.nextDouble() * jitter);
  }

  bool _retriesByRule(TJevFailure failure) => switch (failure) {
    TJevHttpFailure(:final status) => statuses.contains(status),
    TJevConnectionFailure() => retryConnectionFailures,
    TJevTimeoutFailure() => retryTimeouts,
    TJevResponseValidationFailure(:final status) => statuses.contains(status),
    TJevAbortedFailure() => false,
  };

  /// `min(initialBackoff * 2^attempt, maxBackoff)`, doubled step by step so
  /// that many retries cannot overflow.
  Duration _backoff(int attempt) {
    var backoff = initialBackoff;
    for (var step = 0; step < attempt && backoff < maxBackoff; step++) {
      backoff *= 2;
    }
    return backoff < maxBackoff ? backoff : maxBackoff;
  }

  static Never _fail(String reason) =>
      throw TJevInvalidRetryPolicyException(reason: reason);
}
