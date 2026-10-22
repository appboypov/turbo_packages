import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:turbo_response/turbo_response.dart';

import 'abstracts/t_jev_question.dart';
import 'apis/t_jev_api.dart';
import 'config/t_jev_config.dart';
import 'constants/t_jev_http.dart';
import 'exceptions/t_jev_api_key_exception.dart';
import 'exceptions/t_jev_invalid_question_exception.dart';
import 'exceptions/t_jev_invalid_timeout_exception.dart';
import 'models/t_jev_model.dart';
import 'models/t_jev_model_card.dart';
import 'models/t_jev_result.dart';
import 'requests/t_jev_system_one_request_dto.dart';
import 'responses/t_jev_models_response_dto.dart';
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
  /// [timeout] limits each attempt of a Request, its whole response
  /// included, and defaults to 10 seconds.
  ///
  /// Every Request sends [defaultHeaders] first and its own headers second.
  /// Header names are case-insensitive and the last value wins. With
  /// [longContext] on, every Request opts in to the long-context Danger Zone,
  /// which raises the context limits to 262k tokens.
  ///
  /// The client closes [httpClient] only when it created it.
  ///
  /// Throws [TJevApiKeyException] when no API key is found or the key is not
  /// printable ASCII without spaces, and [TJevInvalidTimeoutException] when
  /// [timeout] is not positive.
  factory TJev({
    String? apiKey,
    String? baseUrl,
    TJevModel? defaultModel,
    Duration? timeout,
    Map<String, String>? defaultHeaders,
    bool longContext = false,
    http.Client? httpClient,
    Map<String, String>? environment,
  }) {
    final config = TJevConfig.resolve(
      apiKey: apiKey,
      baseUrl: baseUrl,
      defaultModel: defaultModel,
      timeout: timeout,
      defaultHeaders: _withLongContext(
        defaultHeaders,
        longContext: longContext,
      ),
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
  /// [model] overrides the client's default model for this Request.
  /// [extraBody] fields are merged into the Request body last, so a field of
  /// the same name sends the value in [extraBody].
  ///
  /// [headers] are sent after the client's default headers, so a name in
  /// both sends the value in [headers]. With [longContext] on, this Request
  /// opts in to the long-context Danger Zone.
  ///
  /// Read each Answer with [TJevResult.answer]. A [timeout] replaces the
  /// client timeout for this call. A failed call returns a fail holding a
  /// [TJevFailure]: a [TJevHttpFailure] for a non-2xx response, a
  /// [TJevConnectionFailure] or a [TJevTimeoutFailure].
  ///
  /// Throws [TJevInvalidQuestionException] before sending when [questions]
  /// is empty or two Questions share an id, and [TJevInvalidTimeoutException]
  /// when [timeout] is not positive.
  Future<TurboResponse<TJevResult>> ask({
    required Object state,
    required List<TJevQuestion> questions,
    Duration? timeout,
    TJevModel? model,
    Map<String, Object?>? extraBody,
    Map<String, String>? headers,
    bool longContext = false,
  }) {
    final questionsById = _questionsById(questions);
    return _api.send(
      method: 'POST',
      path: TJevHttp.systemOnePath,
      headers: _withLongContext(headers, longContext: longContext),
      timeout: timeout == null
          ? _config.timeout
          : TJevConfig.checkedTimeout(timeout),
      json: {
        ...TJevSystemOneRequestDto(
          model: (model ?? _config.defaultModel).id,
          state: state,
          questions: {
            for (final MapEntry(key: id, value: question)
                in questionsById.entries)
              id: question.toDto(),
          },
        ).toJson(),
        ...?extraBody,
      },
      onSuccess: (response) => TJevResult.fromSystemOne(
        questions: questionsById,
        response: response,
      ),
    );
  }

  /// Lists the models the account can ask, each with its name, description
  /// and release date.
  ///
  /// [headers] are sent after the client's default headers. A [timeout]
  /// replaces the client timeout for this call. A failed call returns a fail
  /// holding a [TJevFailure]: a [TJevHttpFailure] for a non-2xx response, a
  /// [TJevConnectionFailure] or a [TJevTimeoutFailure].
  ///
  /// Throws [TJevInvalidTimeoutException] when [timeout] is not positive.
  Future<TurboResponse<List<TJevModelCard>>> models({
    Map<String, String>? headers,
    Duration? timeout,
  }) => _api.send(
    method: 'GET',
    path: TJevHttp.modelsPath,
    headers: headers ?? const {},
    timeout: timeout == null
        ? _config.timeout
        : TJevConfig.checkedTimeout(timeout),
    onSuccess: (response) => TJevModelsResponseDto.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
    ).models,
  );

  // 🏗️ HELPERS

  /// [headers] with the long-context Danger Zone header when [longContext] is
  /// on.
  static Map<String, String> _withLongContext(
    Map<String, String>? headers, {
    required bool longContext,
  }) => {...?headers, if (longContext) TJevHttp.longContextHeader: 'true'};

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
