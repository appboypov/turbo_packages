// The code samples of the README, checked by readme_test.dart.
// ignore_for_file: avoid_print

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:turbo_jev/turbo_jev.dart';

const billing = TJevNoul(instructions: 'Is this message about billing?');

void setUp(String myApiKey) {
  // #docregion client-default
  final jev = TJev();
  // #enddocregion client-default
  jev.close();

  // #docregion client-options
  final configured = TJev(
    apiKey: myApiKey,
    defaultModel: TJevModel.jevPreview,
    timeout: const Duration(seconds: 20),
    defaultHeaders: {'X-Team': 'support'},
    longContext: true,
  );
  // #enddocregion client-options
  configured.close();
}

Future<void> requestOptions(TJev jev, String message) async {
  // #docregion request-options
  final response = await jev.ask(
    state: message,
    questions: [billing],
    model: TJevModel.jev1_14_0,
    headers: {'X-Trace': 'ticket-1042'},
    longContext: true,
  );
  // #enddocregion request-options
  print(response.isSuccess);
}

void readResult(TJevResult result) {
  // #docregion result
  print(result.model.id); // jev-1.13.0 when you asked for jev-latest
  print(result.usage.inputTokens);
  print(result.requestId);
  print(result.nouls); // every Noul with its Answer
  // #enddocregion result
}

Future<void> listModels(TJev jev) async {
  // #docregion models
  final response = await jev.models();
  for (final card in response.result ?? const <TJevModelCard>[]) {
    print('${card.name.id} from ${card.releaseDate}: ${card.description}');
  }
  // #enddocregion models
}

// #docregion failures
String describe(TurboResponse<TJevResult> response) => response.when(
  success: (success) {
    final answer = success.result.answer(billing);
    return 'Billing: ${answer.probability}';
  },
  fail: (fail) => switch (fail.error as TJevFailure) {
    TJevAuthenticationFailure() => 'Check your API key.',
    TJevRateLimitFailure(:final retryAfter) => 'Try again after $retryAfter.',
    TJevUnprocessableEntityFailure(:final details) => 'Invalid: $details',
    TJevHttpFailure(:final status, :final message) => '$status: $message',
    TJevResponseValidationFailure(:final reason) => 'Odd Answer: $reason',
    TJevConnectionFailure(:final message) => 'Offline: $message',
    TJevTimeoutFailure(:final timeout) => 'No response within $timeout.',
    TJevAbortedFailure() => 'Stopped.',
  },
);
// #enddocregion failures

Future<void> retries(String message) async {
  // #docregion retry-client
  final jev = TJev(
    timeout: const Duration(seconds: 20),
    retry: TJevRetryPolicy(
      maxRetries: 4,
      initialBackoff: const Duration(seconds: 1),
      budget: const Duration(minutes: 1),
    ),
  );
  // #enddocregion retry-client

  // #docregion retry-call
  final response = await jev.ask(
    state: message,
    questions: [billing],
    timeout: const Duration(seconds: 5),
    retry: TJevRetryPolicy(maxRetries: 0),
  );
  // #enddocregion retry-call
  print(response.isSuccess);

  // #docregion abort
  final stop = Completer<void>();
  final pending = jev.ask(
    state: message,
    questions: [billing],
    abortTrigger: stop.future,
  );
  stop.complete(); // The user left the screen.
  final stopped = await pending; // A fail with a TJevAbortedFailure.
  // #enddocregion abort
  print(stopped.isSuccess);
  jev.close();
}

void logging() {
  // #docregion logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (record.object case final TJevRequestSummary summary) {
      print('${summary.status} after ${summary.retries} retries');
    }
  });

  final jev = TJev(logLevel: TJevLogLevel.info);
  // #enddocregion logging
  jev.close();
}

void web(String sessionToken) {
  // #docregion web
  final jev = TJev(
    baseUrl: 'https://my-app.example/typesafe',
    apiKey: sessionToken,
    dangerouslyAllowBrowser: true,
  );
  // #enddocregion web
  jev.close();
}
