import 'dart:ui';

/// Computed layout result for a single item in the proportional grid.
class ProportionalLayoutResult {
  const ProportionalLayoutResult({
    required this.index,
    required this.position,
    required this.size,
  });

  final int index;
  final Offset position;
  final Size size;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProportionalLayoutResult &&
          index == other.index &&
          position == other.position &&
          size == other.size;

  @override
  int get hashCode => Object.hash(index, position, size);
}
