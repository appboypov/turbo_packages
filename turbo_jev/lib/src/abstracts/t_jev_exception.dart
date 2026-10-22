part '../exceptions/t_jev_api_key_exception.dart';
part '../exceptions/t_jev_browser_exception.dart';
part '../exceptions/t_jev_image_reference_exception.dart';
part '../exceptions/t_jev_invalid_image_exception.dart';
part '../exceptions/t_jev_invalid_question_exception.dart';
part '../exceptions/t_jev_invalid_retry_policy_exception.dart';
part '../exceptions/t_jev_invalid_timeout_exception.dart';
part '../exceptions/t_jev_unasked_question_exception.dart';

/// Thrown when [TJev] is misused, before anything is sent.
///
/// Callers catch it to handle every misuse of the client at once, or switch
/// on its type to handle each one.
sealed class TJevException implements Exception {
  const TJevException();

  /// What is wrong, in words.
  String get message;
}
