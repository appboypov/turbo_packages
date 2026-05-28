// ignore_for_file: avoid_print

import 'package:turbo_promptable/turbo_promptable.dart';

void main() {
  const instruction = TInstruction(
    'Code Quality',
    rules: ['No unused imports', 'All public API must have dartdoc'],
    principles: ['Clarity over cleverness'],
  );

  const workflow = TWorkflow(
    endGoal: TEndGoal(
      'Produce a comprehensive analysis report highlighting code quality issues and providing actionable suggestions for improvement.',
      name: 'Code Quality Analysis',
    ),
    name: 'Review Workflow',
    steps: [
      TStep(
        name: 'Analyse',
        instructions:
            'Review the source code for quality issues based on the provided instructions.',
        input: TInput(
          name: 'Source Code',
        ),
        output: TOutput(
          name: 'Analysis Report',
          schema: 'A detailed report of code quality issues and suggestions.',
        ),
      ),
    ],
  );

  const role = TRole(
    name: 'Code Reviewer',
    expertise: 'Static analysis and code quality',
    instructions: [instruction],
  );

  print(role.toMd());
  print(workflow.toMd());
}
