// The code samples of the README, checked by readme_test.dart.

import 'package:turbo_jev/turbo_jev.dart';

// #docregion fan-out
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
// #enddocregion fan-out

void escalateToEngineering(String ticket) {}

void addToBugBacklog(String ticket) {}

void routeToBilling(String ticket, {required bool refundLikely}) {}

void logFeatureRequest(String ticket) {}

void flagForPriority(String ticket) {}

// #docregion confidence-routing
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
// #enddocregion confidence-routing

void routeToSupportAgent() {}

void showBalance() {}

void approveTransfer() {}

void askUserToConfirm() {}

// #docregion composite-scoring
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
// #enddocregion composite-scoring

// #docregion presence-location
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
// #enddocregion presence-location
