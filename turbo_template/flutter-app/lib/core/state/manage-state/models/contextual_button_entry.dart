import 'package:turbo_widgets/turbo_widgets.dart';

typedef ContextualButtonsBuilder = List<ContextualButtonEntry>? Function();

class ContextualButtonEntry {
  const ContextualButtonEntry({
    required this.config,
    this.position = TContextualPosition.bottom,
    this.variation = TContextualVariation.primary,
  });

  final TButtonConfig config;
  final TContextualPosition position;
  final TContextualVariation variation;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContextualButtonEntry &&
          runtimeType == other.runtimeType &&
          config == other.config &&
          position == other.position &&
          variation == other.variation;

  @override
  int get hashCode => Object.hash(config, position, variation);
}
