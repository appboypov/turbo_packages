import 'package:turbo_promptable/turbo_promptable.dart';

final addAnInstructionsFieldToTrigger =
    TTask.create(
      id: 'add_an_instructions_field_to_trigger',
      title: 'Add an instructions field to trigger kinds',
      body:
          'Add an optional instructions string to trigger kinds. When it is '
          'set, every firing of the kind shows it as <user_instructions> '
          'inside the trigger message.',
    ).toDone().withResult(
      result: TResult(
        dto: TResultDto(
          summary:
              'TTriggerKind, TCommandTriggerKind and TStreamTriggerKind take '
              'instructions. TTriggerContents carries them and renders '
              '<user_instructions> right after the opening <trigger> tag when '
              'not null. plx reads instructions from the trigger settings and '
              'passes them into every firing. Tests cover both packages. '
              'No Brainspace kind sets instructions yet.',
          completedAt: DateTime(2026, 9, 26, 15, 40, 0),
        ),
      ),
    );
