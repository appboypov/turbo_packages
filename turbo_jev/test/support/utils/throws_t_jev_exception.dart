import 'package:test/test.dart';
import 'package:turbo_jev/turbo_jev.dart';

/// Matches a function that throws a [T] that is a [TJevException] with a
/// message.
Matcher throwsTJevException<T>() => throwsA(
  allOf(
    isA<T>(),
    isA<TJevException>().having(
      (exception) => exception.message,
      'message',
      isNotEmpty,
    ),
  ),
);
