enum BoxKey {
  isLightMode,
  language;

  String genId({required Object? id, String? userId}) => '$userId-${id?.toString()}-$this';
}

