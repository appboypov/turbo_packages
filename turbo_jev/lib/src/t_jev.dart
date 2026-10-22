import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:turbo_response/turbo_response.dart';

import 'abstracts/t_jev_question.dart';
import 'apis/t_jev_api.dart';
import 'config/t_jev_config.dart';
import 'config/t_jev_retry_policy.dart';
import 'constants/t_jev_http.dart';
import 'constants/t_jev_logging.dart';
import 'constants/t_jev_messages.dart';
import 'enums/t_jev_http_method.dart';
import 'enums/t_jev_log_level.dart';
import 'exceptions/t_jev_api_key_exception.dart';
import 'exceptions/t_jev_browser_exception.dart';
import 'exceptions/t_jev_image_reference_exception.dart';
import 'exceptions/t_jev_invalid_question_exception.dart';
import 'exceptions/t_jev_invalid_timeout_exception.dart';
import 'models/t_jev_image.dart';
import 'models/t_jev_model_card.dart';
import 'models/t_jev_request_log.dart';
import 'models/t_jev_request_summary.dart';
import 'models/t_jev_response_log.dart';
import 'models/t_jev_result.dart';
import 'requests/t_jev_system_one_request_dto.dart';
import 'responses/t_jev_models_response_dto.dart';
import 'results/t_jev_failure.dart';
import 'services/t_jev_request_trace_service.dart';
import 'services/t_jev_system_one_body_service.dart';
import 'types/t_jev_model.dart';
import 'utils/t_jev_process_environment.dart';
import 'utils/t_jev_response_json_object.dart';

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
  /// [retry] decides when a failed Request is sent again and defaults to
  /// [TJevRetryPolicy] with its defaults: 2 retries of 408, 429, 5xx,
  /// connection failures and timeouts.
  ///
  /// The client logs to the `turbo_jev` logger of `package:logging`, and
  /// the app decides where its records go. [logLevel] comes from this
  /// argument first, from `TYPESAFE_LOG_LEVEL` in [environment] second and
  /// is [TJevLogLevel.warning] without either; the client skips records
  /// below it. At info it logs one [TJevRequestSummary] per Request, and at
  /// debug a [TJevRequestLog] per attempt and a [TJevResponseLog] per
  /// response, with each secret header value replaced in full. The
  /// `package:logging` level must let these records through as well, such
  /// as `Logger.root.level = Level.ALL` for debug.
  ///
  /// With [redactLoggedBodies] on, the default, the JSON of a logged body,
  /// the whole body or the `request` part of a multipart Request, has the
  /// value of each object field whose name holds `token`, `secret`,
  /// `password` or an API key spelling (`api_key`, `api-key`, `apikey`), in
  /// any case and at any depth, replaced in full before the body is cut at
  /// 4096 bytes. Image parts and bodies that are no JSON are logged as they
  /// are. Turn it off to see the bodies as sent and received; secret header
  /// values stay replaced either way.
  ///
  /// The client closes [httpClient] only when it created it.
  ///
  /// In a browser the API key is visible to anyone using the page, so the
  /// client is built there only with [dangerouslyAllowBrowser] on, such as
  /// behind a proxy that holds the real key. A browser Request leaves out
  /// the `User-Agent` and `X-TypeSafe-*` headers, which TypeSafe's CORS
  /// rules do not allow, and sends its body uncompressed.
  ///
  /// Throws [TJevBrowserException] in a browser without
  /// [dangerouslyAllowBrowser], [TJevApiKeyException] when no API key is
  /// found or the key is not printable ASCII without spaces, and
  /// [TJevInvalidTimeoutException] when [timeout] is not positive.
  factory TJev({
    String? apiKey,
    String? baseUrl,
    TJevModel? defaultModel,
    Duration? timeout,
    Map<String, String>? defaultHeaders,
    bool longContext = false,
    TJevRetryPolicy? retry,
    TJevLogLevel? logLevel,
    bool redactLoggedBodies = true,
    http.Client? httpClient,
    Map<String, String>? environment,
    bool dangerouslyAllowBrowser = false,
  }) {
    if (_isBrowser && !dangerouslyAllowBrowser) {
      throw const TJevBrowserException(reason: TJevMessages.browser);
    }
    final config = TJevConfig.resolve(
      apiKey: apiKey,
      baseUrl: baseUrl,
      defaultModel: defaultModel,
      timeout: timeout,
      defaultHeaders: _withLongContext(
        defaultHeaders,
        longContext: longContext,
      ),
      retry: retry,
      logLevel: logLevel,
      redactLoggedBodies: redactLoggedBodies,
      environment: environment ?? processEnvironment,
    );
    final client = httpClient ?? http.Client();
    return TJev._(
      config: config,
      httpClient: client,
      ownsHttpClient: httpClient == null,
      api: TJevApi(
        config: config,
        httpClient: client,
        trace: TJevRequestTraceService(
          logger: Logger(TJevLogging.loggerName),
          level: config.logLevel,
          redactBodies: config.redactLoggedBodies,
        ),
        random: Random(),
      ),
      bodyService: const TJevSystemOneBodyService(),
    );
  }

  TJev._({
    required TJevConfig config,
    required http.Client httpClient,
    required bool ownsHttpClient,
    required TJevApi api,
    required TJevSystemOneBodyService bodyService,
  }) : _config = config,
       _httpClient = httpClient,
       _api = api,
       _bodyService = bodyService,
       _ownsHttpClient = ownsHttpClient;

  // 🧩 DEPENDENCIES

  final TJevConfig _config;
  final http.Client _httpClient;
  final TJevApi _api;
  final TJevSystemOneBodyService _bodyService;

  // 🎬 INIT & DISPOSE

  /// Frees the connections of the HTTP client this client created.
  void close() {
    if (_ownsHttpClient) _httpClient.close();
  }

  // 🎩 STATE

  /// Whether this client created [_httpClient] and so closes it.
  final bool _ownsHttpClient;

  // 🏗️ HELPERS

  /// Whether the client runs in a browser.
  static const _isBrowser = bool.fromEnvironment('dart.library.js_interop');

  /// [headers] with the long-context Danger Zone header when [longContext] is
  /// on.
  static Map<String, String> _withLongContext(
    Map<String, String>? headers, {
    required bool longContext,
  }) => {
    ...?headers,
    if (longContext) TJevHttp.longContextHeader: TJevHttp.dangerZoneOptIn,
  };

  /// Keys [questions] by their ids; missing ids become `q0`, `q1` and so on
  /// in Request order.
  static Map<String, TJevQuestion> _questionsById(
    List<TJevQuestion> questions,
  ) {
    if (questions.isEmpty) {
      throw const TJevInvalidQuestionException(
        reason: TJevMessages.noQuestions,
      );
    }
    var generatedIds = 0;
    final questionsById = <String, TJevQuestion>{};
    for (final question in questions) {
      final id = question.id ?? 'q${generatedIds++}';
      if (questionsById.containsKey(id)) {
        throw TJevInvalidQuestionException(
          reason: TJevMessages.duplicateQuestionId(id),
        );
      }
      questionsById[id] = question;
    }
    return questionsById;
  }

  /// The model cards of a 2xx models [response].
  ///
  /// Throws a [FormatException] or a `CheckedFromJsonException` when the
  /// body is no models list.
  static List<TJevModelCard> _modelCardsOf(http.Response response) => [
    for (final card in TJevModelsResponseDto.fromJson(
      responseJsonObject(response),
    ).models)
      TJevModelCard(
        name: card.name,
        description: card.description,
        releaseDate: card.releaseDate,
      ),
  ];

  // 🪄 MUTATORS

  /// Asks Jev [questions] about [state].
  ///
  /// [state] is content, the same as Instructions and Criteria: strings,
  /// numbers, booleans, Images, maps with string keys, lists and objects
  /// with `toJson`.
  ///
  /// An Image placed as an object anywhere in [state], Instructions or
  /// Criteria, also inside the `toJson` of another object, is sent on its
  /// own. An Image interpolated in a string is written as its Image
  /// Reference and must be listed in [images]. A Request with an Image is
  /// sent as multipart and opts in to the Images Danger Zone.
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
  /// client timeout for each attempt of this Request and a [retry] policy
  /// replaces the client policy. When [abortTrigger] completes before the
  /// Request ends, the Request stops, also while it waits to retry. A failed
  /// Request returns a fail holding a [TJevFailure]: a [TJevHttpFailure] for a
  /// non-2xx response, a [TJevResponseValidationFailure] for a 2xx response
  /// whose body does not fit the Request, a [TJevConnectionFailure], a
  /// [TJevTimeoutFailure] or a [TJevAbortedFailure].
  ///
  /// Throws before sending: [TJevInvalidQuestionException] when [questions]
  /// is empty, two Questions share an id, a Question is invalid, [state] is
  /// no content or holds a non-finite number, or a [TJevBox] is asked of a
  /// model not in [TJevModel.boxModels],
  /// [TJevImageReferenceException] when the content holds the Image
  /// Reference of an Image neither placed nor listed or no content uses an
  /// Image in [images], and [TJevInvalidTimeoutException] when [timeout] is
  /// not positive.
  Future<TurboResponse<TJevResult>> ask({
    required Object state,
    required List<TJevQuestion> questions,
    List<TJevImage> images = const [],
    Duration? timeout,
    TJevRetryPolicy? retry,
    Future<void>? abortTrigger,
    TJevModel? model,
    Map<String, Object?>? extraBody,
    Map<String, String>? headers,
    bool longContext = false,
  }) {
    final questionsById = _questionsById(questions);
    final askedModel = model ?? _config.defaultModel;
    final hasBox = questions.any((question) => question is TJevBox);
    if (hasBox && !askedModel.supportsBox) {
      throw TJevInvalidQuestionException(
        reason: TJevMessages.unsupportedBoxModel(
          boxModelIds: TJevModel.boxModels.map((model) => model.id),
          modelId: askedModel.id,
        ),
      );
    }
    final body = _bodyService.build(
      request: TJevSystemOneRequestDto(
        model: askedModel.id,
        state: state,
        questions: {
          for (final MapEntry(key: id, value: question)
              in questionsById.entries)
            id: question.toDto(id: id),
        },
      ),
      extraBody: extraBody,
      listed: images,
    );
    return _api.send(
      method: TJevHttpMethod.post,
      path: TJevHttp.systemOnePath,
      headers: {
        ..._withLongContext(headers, longContext: longContext),
        if (hasBox || body.images.isNotEmpty)
          TJevHttp.imagesHeader: TJevHttp.dangerZoneOptIn,
      },
      timeout: timeout == null
          ? _config.timeout
          : TJevConfig.checkedTimeout(timeout),
      retry: retry ?? _config.retry,
      abortTrigger: abortTrigger,
      json: body.json,
      images: body.images,
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
  /// replaces the client timeout for each attempt of this Request and a
  /// [retry] policy replaces the client policy. When [abortTrigger] completes
  /// before the Request ends, the Request stops, also while it waits to retry.
  /// A failed Request returns a fail holding a [TJevFailure]: a
  /// [TJevHttpFailure] for a non-2xx response, a
  /// [TJevResponseValidationFailure] for a 2xx response
  /// whose body is no models list, a [TJevConnectionFailure], a
  /// [TJevTimeoutFailure] or a [TJevAbortedFailure].
  ///
  /// Throws [TJevInvalidTimeoutException] when [timeout] is not positive.
  Future<TurboResponse<List<TJevModelCard>>> models({
    Map<String, String>? headers,
    Duration? timeout,
    TJevRetryPolicy? retry,
    Future<void>? abortTrigger,
  }) => _api.send(
    method: TJevHttpMethod.get,
    path: TJevHttp.modelsPath,
    headers: headers ?? const {},
    timeout: timeout == null
        ? _config.timeout
        : TJevConfig.checkedTimeout(timeout),
    retry: retry ?? _config.retry,
    abortTrigger: abortTrigger,
    onSuccess: _modelCardsOf,
  );
}
