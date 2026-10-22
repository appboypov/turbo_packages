import 't_jev_environment_keys.dart';
import 't_jev_http.dart';
import 't_jev_limits.dart';

/// The texts of the exceptions [TJev] throws and of the failures it returns.
abstract final class TJevMessages {
  /// Why the client refuses to run in a browser.
  static const browser =
      'TJev runs in a browser, which shows the API key to anyone using '
      'the page. Call TypeSafe from a server instead, or pass '
      'dangerouslyAllowBrowser: true if you understand the risk.';

  /// No API key was found.
  static const missingApiKey =
      'No API key was provided. Pass apiKey or set the '
      '${TJevEnvironmentKeys.apiKey} environment variable.';

  /// The API key holds other than printable ASCII without spaces.
  static const invalidApiKey =
      'The API key must hold only printable ASCII without spaces.';

  /// [timeout] is zero or negative.
  static String invalidTimeout(Duration timeout) =>
      'A timeout must be positive, not $timeout.';

  /// The `maxRetries` of a retry policy is negative.
  static const negativeMaxRetries = 'maxRetries must not be negative.';

  /// The `initialBackoff` of a retry policy is negative.
  static const negativeInitialBackoff = 'initialBackoff must not be negative.';

  /// The `maxBackoff` of a retry policy is negative.
  static const negativeMaxBackoff = 'maxBackoff must not be negative.';

  /// The `maxRetryAfter` of a retry policy is negative.
  static const negativeMaxRetryAfter = 'maxRetryAfter must not be negative.';

  /// The `jitter` of a retry policy is out of its range.
  static const jitterOutOfRange =
      'jitter must be between ${TJevLimits.minJitter} and '
      '${TJevLimits.maxJitter}.';

  /// A status of a retry policy is out of the HTTP status range.
  static const statusOutOfRange =
      'statuses must be HTTP statuses from ${TJevLimits.minHttpStatus} to '
      '${TJevLimits.maxHttpStatus}.';

  /// The `budget` of a retry policy is zero or negative.
  static const nonPositiveBudget = 'budget must be positive.';

  /// A Request has no Question.
  static const noQuestions = 'A Request needs at least one Question.';

  /// Two Questions of a Request share [id].
  static String duplicateQuestionId(String id) =>
      'Two Questions share the id $id.';

  /// A Box is asked of [modelId], which is none of [boxModelIds].
  static String unsupportedBoxModel({
    required Iterable<String> boxModelIds,
    required String modelId,
  }) => 'A Box needs a model of ${boxModelIds.join(' or ')}, not $modelId.';

  /// The Question of [type] with [id] in a Request breaks the rule [reason]
  /// says.
  static String invalidQuestion(Type type, String id, String reason) =>
      'The $type with id $id is invalid: $reason';

  /// A Noul has no Instructions and no meaning of true or false.
  static const meaninglessNoul =
      'A Noul needs Instructions or a meaning of true or false.';

  /// A Choice has [count] Options, outside the allowed range.
  static String optionCount(int count) =>
      'A Choice needs 1 to ${TJevLimits.maxOptions} Options, not $count.';

  /// Two Options of a Choice have the wire key [key].
  static String duplicateOptionKey(String key) =>
      'Two Options have the wire key $key.';

  /// A Score has [count] Levels, outside the allowed range.
  static String levelCount(int count) =>
      'A Score needs 1 to ${TJevLimits.maxLevels} Levels, not $count.';

  /// Two Levels of a Score have the wire key [key].
  static String duplicateLevelKey(String key) =>
      'Two Levels have the wire key $key.';

  /// The location of the State in a content text.
  static const stateLocation = 'The State';

  /// The location of the extra body fields of a Request in a content text.
  static const extraBodyLocation = 'The extra body';

  /// The location of the Instructions of a Question in a content text.
  static const instructionsLocation = 'The Instructions';

  /// The location of the description of Option [key] of a Choice in a
  /// content text.
  static String optionDescriptionLocation(String key) =>
      'The description of Option $key';

  /// The location of the meaning of true of a Noul in a content text.
  static const trueMeaningLocation = 'The meaning of true';

  /// The location of the meaning of false of a Noul in a content text.
  static const falseMeaningLocation = 'The meaning of false';

  /// The location of the description of Level [number] of a Score in a
  /// content text.
  static String levelDescriptionLocation(int number) =>
      'The description of Level $number';

  /// The content at [location] holds the non-finite number [content].
  static String nonFiniteNumber(String location, num content) =>
      '$location holds the non-finite number $content.';

  /// The content at [location] holds the map key [key], which is no String.
  static String nonStringMapKey(String location, Object? key) =>
      '$location holds the map key $key, which is no String.';

  /// The content at [location] holds a [type] that does not encode to JSON.
  static String unencodableContent(String location, Type type) =>
      '$location holds a $type, which does not encode to JSON content.';

  /// The content at [location] holds a list or map that contains itself.
  static String selfReferencingContent(String location) =>
      '$location holds a list or map that contains itself.';

  /// The content holds the Image [references] of no known Image.
  static String unknownImageReferences(Iterable<String> references) =>
      'The content holds the Image References ${references.join(', ')} of '
      'no known Image. List each Image interpolated in a string in images.';

  /// No content uses the listed Images of [references].
  static String unusedImages(Iterable<String> references) =>
      'No content uses the listed Images ${references.join(', ')}. '
      'Interpolate each listed Image in a string of the State, '
      'Instructions or Criteria.';

  /// The Image text is no base64, as [reason] says.
  static String invalidBase64(String reason) =>
      'The Image text is no base64: $reason.';

  /// The Image data is empty.
  static const emptyImage = 'The Image data is empty.';

  /// The Image data starts with no signature of a known format.
  static const unknownImageFormat = 'The Image data is no PNG or JPEG file.';

  /// The Image file at [path] cannot be read, as [reason] says.
  static String unreadableImageFile(String path, String reason) =>
      'The Image file $path cannot be read: $reason.';

  /// The Image file at [path] cannot be read without a file system.
  static String imageFileWithoutFileSystem(String path) =>
      'Reading the Image file $path needs dart:io. Create the Image from its '
      'bytes or base64 text instead.';

  /// A Result is asked the Answer of a Question of [type] and [id] that its
  /// Request did not ask.
  static String unaskedQuestion(Type type, String? id) =>
      'The Request did not ask this $type'
      '${id == null ? '' : ' with id $id'}.';

  /// A response body is no JSON object.
  static const noJsonObject = 'The body is no JSON object.';

  /// TypeSafe sent no Answer under Question [id].
  static String missingAnswer(String id) =>
      fieldMessage(_answerPath(id), 'TypeSafe sent no Answer.');

  /// The Answer under Question [id] does not fit, as [message] says from
  /// within the Answer.
  static String invalidAnswer(String id, String message) =>
      fieldPath([_answerPath(id), message]);

  /// A [expected] Question got an Answer of type [actual].
  static String answerTypeMismatch(String actual, String expected) =>
      fieldMessage(
        TJevHttp.typeKey,
        'a $expected Question got a $actual Answer.',
      );

  /// The keys of the Answer [field] are [actual] instead of [expected].
  static String unexpectedKeys(
    String field,
    Iterable<String> actual,
    Iterable<String> expected,
  ) => fieldMessage(
    field,
    'the keys ${actual.join(', ')} do not fit the expected keys '
    '${expected.join(', ')}.',
  );

  /// The chosen [choice] of a Choice Answer is none of its Options.
  static String unknownOption(Object? choice) =>
      'choice: $choice is not an Option.';

  /// [message] about the field at [path].
  static String fieldMessage(Object? path, Object? message) =>
      '$path: $message';

  /// The path of a field from its [parts], such as `questions.q0.criteria`.
  static String fieldPath(Iterable<Object?> parts) => parts.join('.');

  /// A connection error, as [reason] says.
  static String connectionError(String reason) => 'Connection error: $reason';

  /// The whole response did not arrive within [timeout].
  static String timedOut(Duration timeout) =>
      'The whole response did not arrive within $timeout.';

  /// The caller's abort trigger stopped the Request.
  static const aborted = 'The abort trigger stopped the Request.';

  /// The message of an HTTP failure without a body.
  static const noBody = 'status code (no body)';

  /// The text between the validation details of an HTTP failure message.
  static const validationDetailSeparator = '; ';

  /// The text after a raw body cut in an HTTP failure message.
  static const cutMarker = '…';

  static String _answerPath(String id) => fieldPath([TJevHttp.answersKey, id]);
}
