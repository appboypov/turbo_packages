enum BoxKey {
  isLightMode,
  language,
  bottomNavigationIndex,
  userSettings,
  skippedVerifyEmailDate,
  lastChangelogVersionRead,
  taskSortType,
  didHappen,
  didSee;

  String genId({required Object? id, String? userId}) => '$userId-${id?.toString()}-$this';
}
