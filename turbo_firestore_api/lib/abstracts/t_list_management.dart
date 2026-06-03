import 'package:flutter/foundation.dart';
import 'package:turbo_firestore_api/turbo_firestore_api.dart';
import 'package:turbo_notifiers/t_notifier.dart';
import 'package:turbo_serializable/abstracts/t_writeable_id.dart';

mixin TListManagement<DTO extends TWriteableId, MODEL extends TModel<DTO>>
    on TCollectionService<DTO, MODEL> {
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\

  @override
  TSort<MODEL> get initialSort;

  @override
  List<TFilter<MODEL>> get initialFilters;

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  late final _activeSort = TNotifier<TSort<MODEL>>(initialSort);
  late final _activeFilters = TNotifier<List<TFilter<MODEL>>>(initialFilters, forceUpdate: true);

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  ValueListenable<TSort<MODEL>> get activeSort => _activeSort;
  ValueListenable<List<TFilter<MODEL>>> get activeFilters => _activeFilters;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void updateSort(TSort<MODEL> sort) {
    _activeSort.update(sort);
    docsNotifier.updateCurrent((docs) => docs..updateSort(sort));
  }

  void updateFilters(List<TFilter<MODEL>> filters) {
    _activeFilters.update(filters);
    docsNotifier.updateCurrent((docs) => docs..updateFilters(filters));
  }

  void onFilterToggled(TFilter<MODEL> filter) {
    final Set<TFilter<MODEL>> activeFilters = Set.from(_activeFilters.value);
    final isActive = activeFilters.contains(filter);
    if (isActive) {
      activeFilters.remove(filter);
    } else {
      activeFilters.add(filter);
    }
    _activeFilters.update(activeFilters.toList());
  }
}
