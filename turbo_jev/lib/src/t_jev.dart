import 'package:http/http.dart' as http;
import 'package:turbo_response/turbo_response.dart';

import 'abstracts/t_jev_question.dart';
import 'apis/t_jev_api.dart';
import 'config/t_jev_config.dart';
import 'constants/t_jev_http.dart';
import 'exceptions/t_jev_api_key_exception.dart';
import 'exceptions/t_jev_invalid_question_exception.dart';
import 'models/t_jev_model.dart';
import 'models/t_jev_result.dart';
import 'requests/t_jev_system_one_request_dto.dart';
import 'results/t_jev_failure.dart';
import 'utils/process_environment.dart';

/// A client that asks Jev typed Questions about State.
///
/// ```dart
/// const billing = TJevNoul(instructions: 'Is this message about billing?');
///
/// final jev = TJev();
/// final response = await jev.ask(
///   state: 'I was charged twice.',
///   questions: [billing],
/// );
/// response.when(
///   success: (success) => print(success.result.answer(billing).probability),
///   fail: (fail) => print(fail.error),
/// );
/// jev.close();
/// ```
final class TJev {
  /// Creates a client.
  ///
  /// [apiKey], [baseUrl] and [defaultModel] come from these arguments first
  /// and from [environment] second, through `TYPESAFE_API_KEY`,
  /// `TYPESAFE_BASE_URL` and `TYPESAFE_DEFAULT_MODEL`. [environment] defaults
  /// to the process environment. An explicit empty [apiKey] does not fall
  /// back to [environment]. Trailing slashes on [baseUrl] are ignored. The
  /// default model is [TJevModel.jevLatest].
  ///
  /// The client closes [httpClient] only when it created it.
  ///
  /// Throws [TJevApiKeyException] when no API key is found or the key is not
  /// printable ASCII without spaces.
  factory TJev({
    String? apiKey,
    String? baseUrl,
    TJevModel? defaultModel,
    http.Client? httpClient,
    Map<String, String>? environment,
  }) {
    final config = TJevConfig.resolve(
      apiKey: apiKey,
      baseUrl: baseUrl,
      defaultModel: defaultModel,
      environment: environment ?? processEnvironment,
    );
    return TJev._(
      config: config,
      httpClient: httpClient ?? http.Client(),
      ownsHttpClient: httpClient == null,
    );
  }

  TJev._({
    required TJevConfig config,
    required http.Client httpClient,
    required bool ownsHttpClient,
  }) : _config = config,
       _httpClient = httpClient,
       _ownsHttpClient = ownsHttpClient,
       _api = TJevApi(config: config, httpClient: httpClient);

  // 🧩 DEPENDENCIES

  final TJevConfig _config;
  final http.Client _httpClient;
  final bool _ownsHttpClient;
  final TJevApi _api;

  // 🎬 INIT & DISPOSE

  /// Frees the connections of the HTTP client this client created.
  void close() {
    if (_ownsHttpClient) _httpClient.close();
  }

  // 🪄 MUTATORS

  /// Asks Jev [questions] about [state].
  ///
  /// Read each Answer with [TJevResult.answer]. A non-2xx response returns a
  /// fail holding a [TJevHttpFailure].
  ///
  /// Throws [TJevInvalidQuestionException] before sending when [questions]
  /// is empty or two Questions share an id.
  Future<TurboResponse<TJevResult>> ask({
    required Object state,
    required List<TJevQuestion> questions,
  }) {
    final questionsById = _questionsById(questions);
    return _api.send(
      method: 'POST',
      path: TJevHttp.systemOnePath,
      json: TJevSystemOneRequestDto(
        model: _config.defaultModel.id,
        state: state,
        questions: {
          for (final MapEntry(key: id, value: question)
              in questionsById.entries)
            id: question.toDto(),
        },
      ),
      onSuccess: (response) => TJevResult.fromSystemOne(
        questions: questionsById,
        response: response,
      ),
    );
  }

  // 🏗️ HELPERS

  /// Keys [questions] by their ids; missing ids become `q0`, `q1` and so on
  /// in Request order.
  static Map<String, TJevQuestion> _questionsById(
    List<TJevQuestion> questions,
  ) {
    if (questions.isEmpty) {
      throw const TJevInvalidQuestionException(
        reason: 'A Request needs at least one Question.',
      );
    }
    var generatedIds = 0;
    final questionsById = <String, TJevQuestion>{};
    for (final question in questions) {
      final id = question.id ?? 'q${generatedIds++}';
      if (questionsById.containsKey(id)) {
        throw TJevInvalidQuestionException(
          reason: 'Two Questions share the id $id.',
        );
      }
      questionsById[id] = question;
    }
    return questionsById;
  }
}
