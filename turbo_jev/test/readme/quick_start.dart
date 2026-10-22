// The code samples of the README, checked by readme_test.dart.
// ignore_for_file: avoid_print

// #docregion quick-start
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
// #enddocregion quick-start
