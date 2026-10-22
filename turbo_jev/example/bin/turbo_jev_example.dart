import 'dart:io';

import 'package:turbo_jev/turbo_jev.dart';
import 'package:turbo_jev_example/severity.dart';
import 'package:turbo_jev_example/shapes_photo.dart';
import 'package:turbo_jev_example/team.dart';

/// Asks Jev one Request of each Question type and prints each Answer.
///
/// Set `TYPESAFE_API_KEY` and run `dart run` in this folder.
Future<void> main() async {
  final TJev jev;
  try {
    jev = TJev();
  } on TJevApiKeyException catch (exception) {
    stderr.writeln('Set TYPESAFE_API_KEY to run this example.');
    stderr.writeln(exception.reason);
    exitCode = 64;
    return;
  }
  try {
    await askNoul(jev);
    await askChoice(jev);
    await askScore(jev);
    await askBox(jev);
  } finally {
    jev.close();
  }
}

/// Asks whether a message is about billing.
Future<void> askNoul(TJev jev) async {
  const billing = TJevNoul(instructions: 'Is this message about billing?');
  final response = await jev.ask(
    state: 'I was charged twice for order 1042.',
    questions: [billing],
  );
  report('Noul', response, (result) {
    final answer = result.answer(billing);
    return 'billing: probability ${fixed(answer.probability)}';
  });
}

/// Asks which team should handle a message.
Future<void> askChoice(TJev jev) async {
  const team = TJevChoice<Team>(
    instructions: 'Which team should handle this message?',
    options: {
      Team.returns: 'Exchanges and wrong or damaged items',
      Team.billing: 'Charges and invoices and payment problems',
      Team.shipping: 'Late or lost parcels',
    },
  );
  final response = await jev.ask(
    state: 'My parcel was due last Monday and the tracking has not moved.',
    questions: [team],
  );
  report('Choice', response, (result) {
    final answer = result.answer(team);
    return 'team: ${answer.choice.name} '
        'with confidence ${fixed(answer.confidence)} '
        'from ${probabilities(answer.probabilities)}';
  });
}

/// Asks how severe a bug report is.
Future<void> askScore(TJev jev) async {
  const severity = TJevScore<Severity>(
    instructions: 'How severe is the reported bug?',
    levels: {
      Severity.cosmetic: 'Cosmetic with no impact on what the app does',
      Severity.annoying: 'Annoying but a workaround exists',
      Severity.blocking: 'Blocking with no workaround',
    },
  );
  final response = await jev.ask(
    state: 'The app crashes every time I press Pay. I cannot check out.',
    questions: [severity],
  );
  report('Score', response, (result) {
    final answer = result.answer(severity);
    return 'severity: score ${fixed(answer.score)} '
        'most likely ${answer.mostLikelyLevel.name} '
        'with confidence ${fixed(answer.confidence)}';
  });
}

/// Asks whether a photo shows a red circle and where it is.
Future<void> askBox(TJev jev) async {
  final photo = TJevImage.fromBase64(shapesPhotoBase64);
  const visible = TJevNoul(instructions: 'Is there a red circle in `photo`?');
  const circle = TJevBox(instructions: 'the red circle in `photo`');
  final response = await jev.ask(
    state: {'photo': photo},
    questions: [visible, circle],
    model: TJevModel.jevPreview,
  );
  report('Box', response, (result) {
    final presence = result.answer(visible).probability;
    final box = result.answer(circle);
    return 'red circle: present with probability ${fixed(presence)} '
        'at top ${fixed(box.top)} bottom ${fixed(box.bottom)} '
        'left ${fixed(box.left)} right ${fixed(box.right)}';
  });
}

/// Prints the Answer [describe] reads from a successful [response], or why
/// the Request failed.
void report(
  String kind,
  TurboResponse<TJevResult> response,
  String Function(TJevResult result) describe,
) {
  response.when(
    success: (success) {
      final result = success.result;
      stdout.writeln(
        '$kind (${result.model.id}, '
        '${result.usage.inputTokens} input tokens): ${describe(result)}',
      );
    },
    fail: (fail) {
      stderr.writeln(
        '$kind failed: ${failureReason(fail.error as TJevFailure)}',
      );
      exitCode = 1;
    },
  );
}

/// Why a Request failed, in words.
String failureReason(TJevFailure failure) => switch (failure) {
  TJevAuthenticationFailure() => 'TypeSafe did not accept the API key.',
  TJevRateLimitFailure(:final retryAfter) =>
    'The rate limit was reached. Try again after $retryAfter.',
  TJevHttpFailure(:final status, :final message) =>
    'TypeSafe answered $status: $message',
  TJevResponseValidationFailure(:final reason) =>
    'The response did not fit the Request: $reason',
  TJevConnectionFailure(:final message) => 'No connection: $message',
  TJevTimeoutFailure(:final timeout) => 'No response within $timeout.',
  TJevAbortedFailure() => 'The Request was stopped.',
};

/// [value] with two decimals.
String fixed(double value) => value.toStringAsFixed(2);

/// Each Option or Level with its Probability.
String probabilities(Map<Enum, double> probabilities) => [
  for (final MapEntry(key: option, value: probability) in probabilities.entries)
    '${option.name} ${fixed(probability)}',
].join(' ');
