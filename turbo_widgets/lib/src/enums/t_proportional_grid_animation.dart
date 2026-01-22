/// Animation type for TProportionalGrid layout transitions.
enum TProportionalGridAnimation {
  /// Cards smoothly slide and resize to new positions.
  slide,

  /// Cards fade out, layout recalculates, then fade in.
  fade,

  /// Cards scale down, layout recalculates, then scale up.
  scale,

  /// Instant layout change with no animation.
  none,
}
