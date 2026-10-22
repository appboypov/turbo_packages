// The code samples of the README, checked by readme_test.dart.
// ignore_for_file: avoid_print

import 'package:turbo_jev/turbo_jev.dart';

// #docregion noul
const refund = TJevNoul(
  instructions: 'Does the customer ask for their money back?',
  trueMeans: 'The customer asks for a refund or a chargeback',
  falseMeans: 'The customer asks for anything else',
);
// #enddocregion noul

// #docregion choice
enum Team { returns, billing, shipping }

const team = TJevChoice<Team>(
  instructions: 'Which team should handle this message?',
  options: {
    Team.returns: 'Exchanges and wrong or damaged items',
    Team.billing: 'Charges and invoices and payment problems',
    Team.shipping: 'Late or lost parcels',
  },
);
// #enddocregion choice

// #docregion score
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
// #enddocregion score

// #docregion box
const mug = TJevBox(instructions: 'the coffee mug in `photo`');
// #enddocregion box

Future<void> askAll(TJev jev, String message) async {
  // #docregion ask
  final response = await jev.ask(
    state: message,
    questions: [refund, team, severity, frustration],
  );
  // #enddocregion ask
  print(response.isSuccess);
}

void readNoul(TJevResult result) {
  // #docregion noul-answer
  final answer = result.answer(refund);
  print(answer.probability); // from 0 to 1
  print(answer.confidence); // 0 at a probability of 0.5
  // #enddocregion noul-answer
}

void readChoice(TJevResult result) {
  // #docregion choice-answer
  final answer = result.answer(team);
  print(answer.choice); // Team.shipping
  print(answer.probabilities[Team.billing]);
  print(answer.confidence); // 0 when spread evenly and 1 when sure
  print(answer.margin); // the top Probability over the runner-up
  // #enddocregion choice-answer
}

void readScore(TJevResult result) {
  // #docregion score-answer
  final answer = result.answer(severity);
  print(answer.score); // from 0 to 2 and it can fall between Levels
  print(answer.normalizedScore); // from 0 to 1
  print(answer.mostLikelyLevel); // Severity.blocking
  print(answer.probabilities[Severity.annoying]);
  // #enddocregion score-answer
}

Future<void> findMug(TJev jev) async {
  // #docregion box-ask
  final photo = await TJevImage.fromFile('kitchen.jpg');
  final response = await jev.ask(
    state: {'photo': photo},
    questions: [mug],
    model: TJevModel.jevPreview,
  );
  final box = response.result?.answer(mug);
  print('${box?.left} ${box?.top} ${box?.right} ${box?.bottom}');
  // #enddocregion box-ask
}

Future<void> images(
  TJev jev,
  String badgeBase64,
  List<int> scanBytes,
) async {
  // #docregion images
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
  // #enddocregion images
  print(response.isSuccess);
}
