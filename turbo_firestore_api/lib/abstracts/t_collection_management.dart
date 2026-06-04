import 'package:flutter/foundation.dart';
import 'package:turbo_firestore_api/models/t_filter_input.dart';
import 'package:turbo_firestore_api/turbo_firestore_api.dart';
import 'package:turbo_notifiers/t_notifier.dart';
import 'package:turbo_serializable/abstracts/t_writeable_id.dart';

mixin TCollectionManagement<DTO extends TWriteableId, MODEL extends TModel<DTO>>
    on TCollectionService<DTO, MODEL> {
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\

  @override
  TSortOption get initialSort;

  @override
  Set<TFilterInput> get initialFilters;

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  late final _activeSort = TNotifier<TSortOption>(initialSort);
  late final _activeFilters = TNotifier<Set<TFilterInput>>(
    initialFilters,
    forceUpdate: true,
  );

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  ValueListenable<TSortOption> get activeSort => _activeSort;
  ValueListenable<Set<TFilterInput>> get activeFilters => _activeFilters;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void updateSort(TSortOption<MODEL> sort) {
    _activeSort.update(sort);
    docsNotifier.updateCurrent((docs) => docs..updateSort(sort));
  }

  void updateFilters(Set<TFilterInput> filters) {
    _activeFilters.update(filters);
    docsNotifier.updateCurrent(
      (docs) => docs..updateFilters(filters),
    );
  }

  void onFilterToggled(TFilterInput filter) {
    final Set<TFilterInput> activeFilters = Set.from(_activeFilters.value);
    final isActive = activeFilters.contains(filter);
    if (isActive) {
      activeFilters.remove(filter);
    } else {
      activeFilters.add(filter);
    }
    updateFilters(activeFilters);
  }
}
