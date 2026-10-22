import 'package:turbo_jev/turbo_jev.dart';

/// An ask of [TJev] about billing whose response is read under fake time.
final class PendingAsk {
  PendingAsk(
    TJev jev, {
    String state = 'I was charged twice.',
    TJevRetryPolicy? retry,
    Future<void>? abortTrigger,
    Map<String, String>? headers,
  }) {
    jev
        .ask(
          state: state,
          questions: const [TJevNoul(instructions: 'Is this about billing?')],
          retry: retry,
          abortTrigger: abortTrigger,
          headers: headers,
        )
        .then((value) => response = value);
  }

  TurboResponse<TJevResult>? response;

  Object? get error => response?.error;
}
