enum BoxKey {
  isLightMode,
  language,
  bottomNavigationIndex,
  userSettings,
  skippedVerifyEmailDate,
  lastChangelogVersionRead,
  taskSortType,
  didHappen,
  didSee,
  lastEnvironment;

  String genId({required Object? id, String? userId}) => '$userId-${id?.toString()}-$this';
}
