import 'dart:math';

import 'package:meta/meta.dart';

import '../constants/t_jev_defaults.dart';
import '../constants/t_jev_limits.dart';
import '../constants/t_jev_messages.dart';
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
  /// A failure is retried by default when its HTTP status is in [statuses],
  /// when it is a [TJevConnectionFailure] and [retryConnectionFailures] is
  /// on, or when it is a [TJevTimeoutFailure] and [retryTimeouts] is on. A
  /// [predicate] gets that default decision and its answer decides instead.
  /// A [TJevAbortedFailure] is never retried, and [maxRetries] and [budget]
  /// stop retries whatever [predicate] answers.
  ///
  /// Throws [TJevInvalidRetryPolicyException] when [maxRetries] or a delay
  /// is negative, [jitter] is outside 0 to 1, a status is outside 100 to 999
  /// or [budget] is not positive.
  TJevRetryPolicy({
    this.maxRetries = TJevDefaults.maxRetries,
    this.initialBackoff = TJevDefaults.initialBackoff,
    this.maxBackoff = TJevDefaults.maxBackoff,
    this.jitter = TJevDefaults.jitter,
    Set<int>? statuses,
    this.respectRetryAfter = TJevDefaults.respectRetryAfter,
    this.maxRetryAfter = TJevDefaults.maxRetryAfter,
    this.retryConnectionFailures = TJevDefaults.retryConnectionFailures,
    this.retryTimeouts = TJevDefaults.retryTimeouts,
    this.predicate,
    this.budget = TJevDefaults.retryBudget,
  }) : statuses = Set.unmodifiable(statuses ?? TJevDefaults.retryStatuses) {
    if (maxRetries < 0) _fail(TJevMessages.negativeMaxRetries);
    if (initialBackoff.isNegative) _fail(TJevMessages.negativeInitialBackoff);
    if (maxBackoff.isNegative) _fail(TJevMessages.negativeMaxBackoff);
    if (maxRetryAfter.isNegative) _fail(TJevMessages.negativeMaxRetryAfter);
    if (!(jitter >= TJevLimits.minJitter && jitter <= TJevLimits.maxJitter)) {
      _fail(TJevMessages.jitterOutOfRange);
    }
    if (this.statuses.any(
      (status) =>
          status < TJevLimits.minHttpStatus ||
          status > TJevLimits.maxHttpStatus,
    )) {
      _fail(TJevMessages.statusOutOfRange);
    }
    if (budget case final budget? when budget <= Duration.zero) {
      _fail(TJevMessages.nonPositiveBudget);
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

  /// Decides whether a failure is retried, given what the other rules
  /// decide; without it, the other rules decide.
  final TJevRetryPredicate? predicate;

  /// The total time of a call, its attempts and waits included, that no
  /// retry starts past: retries stop before a wait that would reach it.
  /// `null` turns the limit off.
  final Duration? budget;

  /// Whether [failure] is sent again, retries left aside.
  @internal
  bool retries(TJevFailure failure) {
    if (failure is TJevAbortedFailure) return false;
    final retriesByDefault = _retriesByRule(failure);
    return predicate?.call(failure, retriesByDefault) ?? retriesByDefault;
  }

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
      backoff *= TJevDefaults.backoffMultiplier;
    }
    return backoff < maxBackoff ? backoff : maxBackoff;
  }

  static Never _fail(String reason) =>
      throw TJevInvalidRetryPolicyException(reason: reason);
}
