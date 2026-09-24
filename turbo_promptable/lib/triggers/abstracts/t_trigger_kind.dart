import 'package:turbo_promptable/triggers/models/t_trigger_contents.dart';
import 'package:turbo_promptable/workspace/models/root/t_agent.dart';
import 'package:turbo_promptable/workspace/models/root/t_role.dart';

/// One kind of text trigger: the pattern that finds it in a line.
///
/// A kind is either a [TCommandTriggerKind] or a [TStreamTriggerKind].
sealed class TTriggerKind {
  const TTriggerKind({
    required this.name,
    required this.start,
    this.contains,
    required this.end,
  });

  /// Unique name of the kind, such as `task`.
  final String name;

  /// Literal marker that begins the trigger, such as `//`.
  final String start;

  /// Literal marker that must follow [start], such as `#TASK`.
  final String? contains;

  /// Literal marker that finishes the trigger when it ends the line, such as
  /// `;`.
  final String end;
}

/// A kind the plx server acts on by running a shell command.
///
/// When the kind fires, plx calls [command] with the fired trigger, [agent]
/// and [role], and runs the returned line through `/bin/sh -c` in the watched
/// folder. plx never fills in an agent or role.
final class TCommandTriggerKind extends TTriggerKind {
  const TCommandTriggerKind({
    required super.name,
    required super.start,
    super.contains,
    required super.end,
    this.agent,
    this.role,
    required this.command,
  });

  /// Agent handed to [command], if any.
  final TAgent? agent;

  /// Role handed to [command], if any.
  final TRole? role;

  /// Builds the shell command line. `"$trigger"` gives the whole `<trigger>`
  /// body.
  final String Function(TTriggerContents trigger, TAgent? agent, TRole? role)
  command;
}

/// A kind without a command. One agent claims it with `plx claim trigger`
/// and receives its fired triggers; while unclaimed, plx only logs it.
final class TStreamTriggerKind extends TTriggerKind {
  const TStreamTriggerKind({
    required super.name,
    required super.start,
    super.contains,
    required super.end,
  });
}
