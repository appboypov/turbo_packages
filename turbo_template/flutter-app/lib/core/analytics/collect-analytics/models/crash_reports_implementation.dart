import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:turbo_flutter_template/core/shared/constants/t_keys.dart';
import 'package:turbo_flutter_template/core/shared/constants/t_values.dart';
import 'package:turbolytics/turbolytics.dart';

/// Implementation of crash reporting functionality using Firebase Crashlytics and PostHog.
///
/// This class handles error logging, custom data tracking, and user identification
/// for crash reporting purposes. It sends reports to both Firebase Crashlytics and PostHog
/// for comprehensive error tracking and analysis.
class CrashReportsImplementation implements CrashReportsInterface {
  // 📍 LOCATOR
  // 🧩 DEPENDENCIES
  // 🎬 INIT & DISPOSE
  // 👂 LISTENERS
  // ⚡️ OVERRIDES

  FirebaseCrashlytics get _crashlytics {
    if (Firebase.apps.isEmpty) {
      throw StateError('Firebase must be initialized before using Crashlytics');
    }
    return FirebaseCrashlytics.instance;
  }

  /// Logs a message to the crash reporting service.
  ///
  /// Captures [message] as a Firebase Crashlytics log entry.
  @override
  Future<void> log(String message) async {
    // Firebase Crashlytics is not supported on web
    if (kIsWeb) return;
    await _crashlytics.log(message);
  }

  /// Records an error with the crash reporting service.
  ///
  /// Captures [exception] and [stack] as a Firebase Crashlytics event with additional
  /// context from [information], [reason], and [fatal] flag.
  /// The [printDetails] parameter is unused but maintained for interface compatibility.
  @override
  Future<void> recordError(
    Object? exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<DiagnosticsNode> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) async {

    // Firebase Crashlytics is not supported on web
    if (kIsWeb) return;

    final extraInfo = <String, String>{
      for (var node in information) node.toString(): node.toDescription(),
    };

    if (exception is FlutterErrorDetails) {
      await setCustomKey(TKeys.exception, exception.exceptionAsString());
      await _crashlytics.recordFlutterFatalError(exception);
      // Add additional context as custom keys
      if (reason != null) {
        await setCustomKey(TKeys.reason, reason.toString());
      }
      for (var node in information) {
        await setCustomKey(node.toString(), node.toDescription());
      }
    } else {
      await setCustomKey(TKeys.exception, exception.toString());
      await _crashlytics.recordError(exception, stack, fatal: fatal);
    }

    // Add extra context
    for (final entry in extraInfo.entries) {
      await setCustomKey(entry.key, entry.value);
    }

    if (reason != null) {
      await setCustomKey(TKeys.reason, reason.toString());
    }
  }

  /// Sets a custom key-value pair for crash reports.
  ///
  /// Associates [key] with [value] in Firebase Crashlytics custom keys. If [value] is null,
  /// uses a predefined null value constant.
  @override
  Future<void> setCustomKey(String key, String? value) async {
    // Firebase Crashlytics is not supported on web
    if (kIsWeb) return;
    await _crashlytics.setCustomKey(key, value ?? TValues.nullValue);
  }

  /// Sets the user identifier for crash reports.
  ///
  /// Associates all future crash reports with the user specified by [identifier].
  /// Note: PostHog user identification is handled by AnalyticsImplementation.setUserId()
  @override
  Future<void> setUserIdentifier(String identifier) async {
    // Firebase Crashlytics is not supported on web
    if (kIsWeb) return;
    // Only set in Firebase Crashlytics
    // PostHog identification is handled centrally by AnalyticsImplementation
    await _crashlytics.setUserIdentifier(identifier);
  }

  // 🎩 STATE
  // 🛠 UTIL
  // 🧲 FETCHERS
  // 🏗️ HELPERS
  // 🪄 MUTATORS
}
