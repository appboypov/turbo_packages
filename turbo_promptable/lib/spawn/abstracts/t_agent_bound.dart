import 'package:turbo_promptable/spawn/abstracts/t_spawnable.dart';

/// Spawnable work item that can name the agent that runs it.
abstract interface class TAgentBound implements TSpawnable {
  /// Id of the agent that runs this item; the default agent runs it when null.
  String? get agentId;
}
