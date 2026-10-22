# turbo_jev

A typed Dart client for Jev. Jev is the System One model of [TypeSafe](https://typesafe.ai). It answers Questions about your content with Probabilities instead of generated text. turbo_jev lets you ask those Questions as typed Dart objects and read typed Answers.

It covers the features of the official JavaScript SDK 0.7.0 and Python SDK 0.7.5.

## Features

- Ask any mix of the four Question types in one Request.
- Read each Answer with the type of its Question through `result.answer(question)`.
- Send PNG and JPEG Images and find regions in them with a Box.
- Get failures as a `TurboResponse` fail with a sealed `TJevFailure` instead of an exception.
- Retry failed Requests with backoff and stop them with an abort trigger.
- Log each Request through `package:logging` without secrets.
- Compress large Request bodies with gzip outside the browser.
- Run on the Dart VM and in Flutter apps. Browsers go through your own proxy.

## Installation

```sh
dart pub add turbo_jev
```

Or add it to your `pubspec.yaml` yourself:

```yaml
dependencies:
  turbo_jev: ^0.1.0
```

## Setup

Get an API key from [TypeSafe](https://typesafe.ai). Set it in your environment as `TYPESAFE_API_KEY`:

```sh
export TYPESAFE_API_KEY=your-key
```

The client reads it from there:

```dart
final jev = TJev();
```

You can also pass the key and other settings yourself. Arguments win over the environment.

```dart
final configured = TJev(
  apiKey: myApiKey,
  defaultModel: TJevModel.jevPreview,
  timeout: const Duration(seconds: 20),
  defaultHeaders: {'X-Team': 'support'},
  longContext: true,
);
```

| Argument | Environment variable | Default |
| - | - | - |
| `apiKey` | `TYPESAFE_API_KEY` | None |
| `baseUrl` | `TYPESAFE_BASE_URL` | `https://api.typesafe.ai` |
| `defaultModel` | `TYPESAFE_DEFAULT_MODEL` | `jev-latest` |
| `logLevel` | `TYPESAFE_LOG_LEVEL` | `warning` |
| `timeout` | None | 10 seconds per attempt |
| `retry` | None | 2 retries |

The constructor throws a `TJevApiKeyException` when it finds no key. `defaultHeaders` go with every Request. `longContext: true` opts every Request in to the long-context Danger Zone. It raises the context limits to 262k tokens.

Call `close()` when you are done with the client. You can pass your own `http.Client` as `httpClient`. The client then leaves closing it to you.

## Quick Start

```dart
import 'package:turbo_jev/turbo_jev.dart';

Future<void> main() async {
  const billing = TJevNoul(instructions: 'Is this message about billing?');

  final jev = TJev();
  final response = await jev.ask(
    state: 'I was charged twice for order 1042.',
    questions: [billing],
  );
  response.when(
    success: (success) {
      final answer = success.result.answer(billing);
      print('Billing: ${answer.probability}');
    },
    fail: (fail) => print('Failed: ${fail.error}'),
  );
  jev.close();
}
```

`ask` sends one Request. It returns a `TurboResponse<TJevResult>` from [turbo_response](https://pub.dev/packages/turbo_response). turbo_jev exports that package for you.

## Questions

A Request holds State and one or more Questions. State is the content you ask about. It can be text or a number or a map or a list. Any object with a `toJson` works too. Each Question is a const object that also serves as the key of its typed Answer.

### Noul

A Noul gives the Probability that a statement about the State is true. `trueMeans` and `falseMeans` are optional. They say what counts as true and what counts as false.

```dart
const refund = TJevNoul(
  instructions: 'Does the customer ask for their money back?',
  trueMeans: 'The customer asks for a refund or a chargeback',
  falseMeans: 'The customer asks for anything else',
);
```

```dart
final answer = result.answer(refund);
print(answer.probability); // from 0 to 1
print(answer.confidence); // 0 at a probability of 0.5
```

### Choice

A Choice picks one Option from a set of 1 to 255 Options. An Option can be an enum value or any other value. Each Option has a description or `null`.

```dart
enum Team { returns, billing, shipping }

const team = TJevChoice<Team>(
  instructions: 'Which team should handle this message?',
  options: {
    Team.returns: 'Exchanges and wrong or damaged items',
    Team.billing: 'Charges and invoices and payment problems',
    Team.shipping: 'Late or lost parcels',
  },
);
```

```dart
final answer = result.answer(team);
print(answer.choice); // Team.shipping
print(answer.probabilities[Team.billing]);
print(answer.confidence); // 0 when spread evenly and 1 when sure
print(answer.margin); // the top Probability over the runner-up
```

### Score

A Score places the State on 1 to 10 ordered Levels from low to high. Map each Level to its description. Use `TJevScore.list` when each description is its own Level.

```dart
enum Severity { cosmetic, annoying, blocking }

const severity = TJevScore<Severity>(
  instructions: 'How severe is the reported bug?',
  levels: {
    Severity.cosmetic: 'Cosmetic with no impact on what the app does',
    Severity.annoying: 'Annoying but a workaround exists',
    Severity.blocking: 'Blocking with no workaround',
  },
);

const frustration = TJevScore.list(
  instructions: 'How frustrated is the customer?',
  levels: ['calm', 'irritated', 'angry'],
);
```

```dart
final answer = result.answer(severity);
print(answer.score); // from 0 to 2 and it can fall between Levels
print(answer.normalizedScore); // from 0 to 1
print(answer.mostLikelyLevel); // Severity.blocking
print(answer.probabilities[Severity.annoying]);
```

### Box

A Box finds one region in an Image. Only `jev-preview` and `jev-1.14.0` answer a Box. Set one of them on the Request or as the default model of the client.

```dart
const mug = TJevBox(instructions: 'the coffee mug in `photo`');
```

```dart
final photo = await TJevImage.fromFile('kitchen.jpg');
final response = await jev.ask(
  state: {'photo': photo},
  questions: [mug],
  model: TJevModel.jevPreview,
);
final box = response.result?.answer(mug);
print('${box?.left} ${box?.top} ${box?.right} ${box?.bottom}');
```

Each edge is a fraction of the Image from its top left corner. A Box always answers with a region. Ask a Noul next to it to learn whether the thing is there at all. [Presence Plus Location](#presence-plus-location) shows how.

### Many Questions in One Request

Put every Question you need in one Request. Jev answers them in parallel. So each extra Question adds little time.

```dart
final response = await jev.ask(
  state: message,
  questions: [refund, team, severity, frustration],
);
```

A Question can have an `id`. Without one it gets `q0`, `q1` and so on in Request order. An id only makes logged JSON easier to read.

### Reading the Result

`result.answer(question)` returns the Answer with the type of its Question. It throws a `TJevUnaskedQuestionException` for a Question the Request did not ask. The result also tells you more about the Request:

```dart
print(result.model.id); // jev-1.13.0 when you asked for jev-latest
print(result.usage.inputTokens);
print(result.requestId);
print(result.nouls); // every Noul with its Answer
```

`choices` and `scores` and `boxes` work the same way as `nouls`.

### Request Options

`ask` takes a few more options for one Request:

```dart
final response = await jev.ask(
  state: message,
  questions: [billing],
  model: TJevModel.jev1_14_0,
  headers: {'X-Trace': 'ticket-1042'},
  longContext: true,
);
```

`model` replaces the default model of the client. `headers` go after the default headers of the client. `extraBody` adds fields to the body for API features this package does not know yet.

## Images

A Request can send PNG and JPEG Images. Make an Image from a file or base64 text or bytes:

```dart
final door = await TJevImage.fromFile('door-camera.jpg');
final badge = TJevImage.fromBase64(badgeBase64);
final scan = TJevImage(scanBytes);

final response = await jev.ask(
  state: {'door': door, 'scan': scan},
  questions: [
    TJevNoul(instructions: 'Is the person in `door` the one on $badge?'),
  ],
  images: [badge],
);
```

Place an Image as an object in State or Instructions or Criteria, also inside the `toJson` of your own model. The client then sends it for you. An Image inside a string turns into its Image Reference. List that Image in `images` so the client sends it too. The client throws a `TJevImageReferenceException` when a reference has no Image or a listed Image is not used.

A Request with an Image goes out as multipart. It opts in to the Images Danger Zone for you. Each side of an Image must be 280 to 1568 pixels. `TJevImage.fromFile` needs `dart:io` and so does not work in a browser.

## Failures

Normal failures do not throw. A failed Request returns a `TurboResponse` fail. Its `error` is a sealed `TJevFailure`. Switch on it to handle each case:

```dart
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
```

| Failure | When |
| - | - |
| `TJevBadRequestFailure` | TypeSafe rejected the Request as invalid (400). |
| `TJevAuthenticationFailure` | TypeSafe did not accept the API key (401). |
| `TJevPermissionDeniedFailure` | The key may not use what the Request asks for (403). |
| `TJevNotFoundFailure` | TypeSafe did not find what the Request asks for (404). |
| `TJevUnprocessableEntityFailure` | The body does not match the schema (422). `details` lists each problem. |
| `TJevRateLimitFailure` | The rate limit was reached (429). `retryAfter` holds the wait TypeSafe asks for. |
| `TJevInternalServerFailure` | TypeSafe failed to handle the Request (5xx). |
| `TJevOtherStatusFailure` | Any other status that is not 2xx. |
| `TJevResponseValidationFailure` | A 2xx body does not fit the Request. |
| `TJevConnectionFailure` | TypeSafe could not be reached. |
| `TJevTimeoutFailure` | An attempt took longer than its timeout. |
| `TJevAbortedFailure` | The abort trigger stopped the Request. |

The HTTP failures share the sealed `TJevHttpFailure`. It holds the `status` and `message` and `requestId` and `headers` and `body` of the response.

Mistakes in your own code throw before anything goes out:

| Exception | When |
| - | - |
| `TJevApiKeyException` | No API key is found or the key holds spaces or characters outside ASCII. |
| `TJevBrowserException` | The client is built in a browser without `dangerouslyAllowBrowser`. |
| `TJevInvalidQuestionException` | A Question is invalid or two Questions share an id. A Box for a model without Box throws it too. |
| `TJevImageReferenceException` | A reference has no Image or a listed Image is not used. |
| `TJevInvalidImageException` | Image data is empty or no PNG or JPEG file. |
| `TJevInvalidTimeoutException` | A timeout is zero or negative. |
| `TJevInvalidRetryPolicyException` | A retry setting is out of range. |
| `TJevUnaskedQuestionException` | `result.answer` gets a Question the Request did not ask. |

## Retries and Timeouts

Each attempt of a Request gets 10 seconds by default. A failed Request is retried twice by default. The client retries the statuses 408 and 429 and 500 to 599. It also retries connection failures and timeouts. Each wait starts at half a second and doubles up to 5 seconds with some random jitter. A wait that TypeSafe asks for in `Retry-After` wins when it is 60 seconds or less. No retry starts once a Request has run for 30 seconds.

Set your own policy on the client:

```dart
final jev = TJev(
  timeout: const Duration(seconds: 20),
  retry: TJevRetryPolicy(
    maxRetries: 4,
    initialBackoff: const Duration(seconds: 1),
    budget: const Duration(minutes: 1),
  ),
);
```

Or replace the timeout and the policy for one Request:

```dart
final response = await jev.ask(
  state: message,
  questions: [billing],
  timeout: const Duration(seconds: 5),
  retry: TJevRetryPolicy(maxRetries: 0),
);
```

`TJevRetryPolicy` also takes the `statuses` to retry. Its `predicate` gets each failure with the decision of the built-in rules and has the final say. So you add or remove a single case and keep the rest:

```dart
final careful = TJevRetryPolicy(
  predicate: (failure, retriesByDefault) => switch (failure) {
    TJevHttpFailure(status: 409) => true,
    TJevHttpFailure(status: 503) => false,
    _ => retriesByDefault,
  },
);
```

An aborted Request is never retried, and `maxRetries` and `budget` stop retries whatever the predicate says.

Pass a future as `abortTrigger` to stop a Request. Complete the future and the Request stops at once. This works while the Request waits for a retry too.

```dart
final stop = Completer<void>();
final pending = jev.ask(
  state: message,
  questions: [billing],
  abortTrigger: stop.future,
);
stop.complete(); // The user left the screen.
final stopped = await pending; // A fail with a TJevAbortedFailure.
```

## Logging

The client logs to the `turbo_jev` logger of [package:logging](https://pub.dev/packages/logging). Your app decides where the records go. `logLevel` sets how much the client logs:

| Level | Logs |
| - | - |
| `debug` | The headers and body of each attempt and each response. |
| `info` | One `TJevRequestSummary` per Request. |
| `warning` | Only warnings and errors. This is the default. |
| `error` | Only errors. |
| `off` | Nothing. |

Each level also logs what the levels below it in this table log. Add `logging` to your own dependencies to read the records:

```dart
Logger.root.level = Level.ALL;
Logger.root.onRecord.listen((record) {
  if (record.object case final TJevRequestSummary summary) {
    print('${summary.status} after ${summary.retries} retries');
  }
});

final jev = TJev(logLevel: TJevLogLevel.info);
```

The `object` of a record holds the typed log. It is a `TJevRequestSummary` or a `TJevRequestLog` or a `TJevResponseLog`. A log never shows the API key or any other secret header value. The level of `package:logging` must let the records through as well.

A debug record holds at most 4096 bytes of each body. Before the cut, the JSON of a body has the value of each field whose name holds `token`, `secret`, `password`, `api_key`, `api-key` or `apikey`, in any case and at any depth, replaced with `***`. That JSON is the whole body, or the `request` part of the multipart body of a Request with Images. Image parts and bodies that are no JSON are logged as they are. `redactLoggedBodies: false` logs the bodies as sent and received. Secret header values stay hidden either way:

```dart
final unredacted = TJev(
  logLevel: TJevLogLevel.debug,
  redactLoggedBodies: false,
);
```

## Models

`TJevModel.jevLatest` is the default model. `TJevModel.jevPreview` points to the next model. Pin a version with `TJevModel.jev1_14_0` or `TJevModel('jev-1.14.0')`. List the models your account can use:

```dart
final response = await jev.models();
for (final card in response.result ?? const <TJevModelCard>[]) {
  print('${card.name.id} from ${card.releaseDate}: ${card.description}');
}
```

`result.model` tells you which model answered a Request.

## Web Use Through a Proxy

In a browser anyone who opens the page can read the API key. So `TJev` throws a `TJevBrowserException` on the web by default. Keep your TypeSafe key on a server you control and let the browser call that server:

```dart
final jev = TJev(
  baseUrl: 'https://my-app.example/typesafe',
  apiKey: sessionToken,
  dangerouslyAllowBrowser: true,
);
```

The client sends `sessionToken` as `Authorization: Bearer <token>` to paths under `baseUrl`. Your proxy then does four things:

1. It checks the session token of the user.
2. It forwards `/v1/systemone` and `/v1/models` to `https://api.typesafe.ai`.
3. It replaces the `Authorization` header with your TypeSafe key.
4. It allows the `Authorization` and `Content-Type` and `TypeSafe-Danger-Zone-*` headers in its CORS rules.

Pass the body and its `Content-Type` through unchanged. Requests with Images are multipart. In a browser the client leaves out the `User-Agent` and `X-TypeSafe-*` headers and sends bodies uncompressed.

## Patterns

These patterns come from the [TypeSafe docs](https://docs.typesafe.ai/patterns).

### Speculative Fan-Out

Ask every Question you might need in one Request. Then let your code pick what matters. Jev answers all Questions in parallel. So the extra Questions cost little time. Read more in [Speculative fan-out](https://docs.typesafe.ai/patterns/fan-out).

```dart
enum Category { bugReport, billing, featureRequest }

const category = TJevChoice<Category>(
  instructions: 'What is this ticket about?',
  options: {
    Category.bugReport: 'Something in the product does not work',
    Category.billing: 'Charges and invoices and refunds',
    Category.featureRequest: 'A wish for something new',
  },
);
const bugSeverity = TJevScore.list(
  instructions: 'How severe is the bug?',
  levels: ['minor', 'major', 'critical'],
);
const reproSteps = TJevNoul(
  instructions: 'Does the ticket give steps to reproduce the bug?',
);
const refund = TJevNoul(instructions: 'Does the customer ask for a refund?');
const frustration = TJevScore.list(
  instructions: 'How frustrated is the customer?',
  levels: ['calm', 'irritated', 'angry'],
);

Future<void> triage(TJev jev, String ticket) async {
  final response = await jev.ask(
    state: ticket,
    questions: [category, bugSeverity, reproSteps, refund, frustration],
  );
  final result = response.result;
  if (result == null) return;

  switch (result.answer(category).choice) {
    case Category.bugReport:
      if (result.answer(bugSeverity).score > 1.5 &&
          result.answer(reproSteps).probability > 0.6) {
        escalateToEngineering(ticket);
      } else {
        addToBugBacklog(ticket);
      }
    case Category.billing:
      routeToBilling(
        ticket,
        refundLikely: result.answer(refund).probability > 0.7,
      );
    case Category.featureRequest:
      logFeatureRequest(ticket);
  }
  if (result.answer(frustration).score > 1.5) flagForPriority(ticket);
}
```

### Confidence-Gated Routing

The Answer tells you what. Its confidence tells you whether to act on it. Give risky actions a higher bar. Read more in [Confidence-gated routing](https://docs.typesafe.ai/patterns/confidence-routing).

```dart
enum Intent { checkBalance, approveTransfer, other }

const intent = TJevChoice<Intent>(
  instructions: 'What does the user want to do?',
  options: {
    Intent.checkBalance: 'Hear the balance of their account',
    Intent.approveTransfer: 'Approve a pending transfer',
    Intent.other: 'Anything else',
  },
);

Future<void> handleCommand(TJev jev, String command) async {
  final response = await jev.ask(state: command, questions: [intent]);
  final answer = response.result?.answer(intent);
  if (answer == null || answer.confidence < 0.6) {
    routeToSupportAgent();
    return;
  }
  switch (answer.choice) {
    case Intent.checkBalance:
      showBalance();
    case Intent.approveTransfer when answer.confidence > 0.85:
      approveTransfer();
    case Intent.approveTransfer:
      askUserToConfirm();
    case Intent.other:
      routeToSupportAgent();
  }
}
```

### Composite Scoring

Split a complex judgment into separate Scores. Then weigh them in your own code. `normalizedScore` puts each Score on a scale from 0 to 1. Read more in [Composite scoring](https://docs.typesafe.ai/patterns/composite-scoring).

```dart
const depth = ['none', 'basic', 'solid', 'strong', 'expert'];

const python = TJevScore.list(
  instructions: 'How deep is the Python experience?',
  levels: depth,
);
const leadership = TJevScore.list(
  instructions: 'How much team leadership does the resume show?',
  levels: depth,
);
const design = TJevScore.list(
  instructions: 'How strong is the system design experience?',
  levels: depth,
);
const generalist = TJevScore.list(
  instructions: 'How broad is the experience across fields?',
  levels: depth,
);

Future<({double seniorEngineer, double manager})?> rank(
  TJev jev,
  String resume,
) async {
  final response = await jev.ask(
    state: resume,
    questions: [python, leadership, design, generalist],
  );
  final result = response.result;
  if (result == null) return null;

  double score(TJevScore<String> question) =>
      result.answer(question).normalizedScore;
  return (
    seniorEngineer:
        0.40 * score(python) +
        0.10 * score(leadership) +
        0.40 * score(design) +
        0.10 * score(generalist),
    manager:
        0.15 * score(python) +
        0.40 * score(leadership) +
        0.20 * score(design) +
        0.25 * score(generalist),
  );
}
```

### Presence Plus Location

A Box always answers with a region. Even a thing that is not in the Image gets one. Ask a Noul in the same Request whether the thing is there. Ignore the Box when the Noul is low. Read more in [Box](https://docs.typesafe.ai/primitives/box).

```dart
const mugVisible = TJevNoul(instructions: 'Is there a coffee mug in `photo`?');
const mug = TJevBox(instructions: 'the coffee mug in `photo`');

Future<TJevBoxAnswer?> findMug(TJev jev, TJevImage photo) async {
  final response = await jev.ask(
    state: {'photo': photo},
    questions: [mugVisible, mug],
    model: TJevModel.jevPreview,
  );
  final result = response.result;
  if (result == null || result.answer(mugVisible).probability < 0.5) {
    return null;
  }
  return result.answer(mug);
}
```

## Example

The [example](https://github.com/appboypov/turbo_packages/tree/main/turbo_jev/example) sends one Request of each Question type to the live API. It prints each Answer:

```sh
cd example
TYPESAFE_API_KEY=your-key dart run
```

```text
Noul (jev-1.13.0, 284 input tokens): billing: probability 0.99
Choice (jev-1.13.0, 348 input tokens): team: shipping with confidence 1.00 from returns 0.00 billing 0.00 shipping 1.00
Score (jev-1.13.0, 330 input tokens): severity: score 2.00 most likely blocking with confidence 1.00
Box (jev-1.14.0, 661 input tokens): red circle: present with probability 0.99 at top 0.15 bottom 0.51 left 0.62 right 0.88
```

## More Information

- [TypeSafe docs](https://docs.typesafe.ai/)
- [API reference](https://pub.dev/documentation/turbo_jev/latest/)

## License

MIT. See [LICENSE](https://github.com/appboypov/turbo_packages/blob/main/turbo_jev/LICENSE).
