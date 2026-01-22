import 'package:turbo_widgets/turbo_widgets.dart';

typedef ContextualButtonsBuilder = List<ContextualButtonEntry>? Function();

class ContextualButtonEntry {
  const ContextualButtonEntry({
    required this.config,
    this.id,
    this.position = TContextualPosition.bottom,
    this.variation = TContextualVariation.primary,
  });

  final TButtonConfig config;
  final String? id;
  final TContextualPosition position;
  final TContextualVariation variation;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContextualButtonEntry &&
          runtimeType == other.runtimeType &&
          _identityKey == other._identityKey;

  @override
  int get hashCode => _identityKey.hashCode;

  Object get _identityKey => id ?? Object.hash(config, position, variation);
}
