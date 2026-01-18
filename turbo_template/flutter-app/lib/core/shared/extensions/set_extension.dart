extension SetExtensionExtension<T> on Set<T> {
  bool isDeepSame(Set<T> other) {
    if (length != other.length) return false;
    for (final item in this) {
      if (!other.contains(item)) return false;
    }
    return true;
  }
}
