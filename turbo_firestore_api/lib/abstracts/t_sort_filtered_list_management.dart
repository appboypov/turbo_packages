import 'package:flutter/foundation.dart';
import 'package:turbo_firestore_api/abstracts/t_filter_type.dart';
import 'package:turbo_firestore_api/abstracts/t_model.dart';
import 'package:turbo_firestore_api/abstracts/t_sort_type.dart';
import 'package:turbo_firestore_api/services/t_collection_service.dart';
import 'package:turbo_firestore_api/typedefs/t_sort_filter_defs.dart';
import 'package:turbo_notifiers/t_notifier.dart';
import 'package:turbo_serializable/abstracts/t_writeable_id.dart';

mixin TSortFilterManagement<DTO extends TWriteableId, MODEL extends TModel<DTO>>
    on TCollectionService<DTO, MODEL> {
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\

  TSortType<MODEL> get initialSort;
  List<({TFilterType<MODEL> filter, dynamic input})> get initialFilters;

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  late final _activeSort = TNotifier<TSortType<MODEL>>(initialSort);
  late final _activeFilters = TNotifier<List<({TFilterType<MODEL> filter, dynamic input})>>(
    initialFilters,
  );

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  ValueListenable<TSortType<MODEL>> get activeSort => _activeSort;
  ValueListenable<List<({TFilterType<MODEL> filter, dynamic input})>> get activeFilters =>
      _activeFilters;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  List<TFilterPredicate<MODEL>> get _currentFilters => [
    for (final active in _activeFilters.value)
      (model) => active.filter.filter(
        value: model,
        input: active.input,
      ),
  ];

  @protected
  String get listId => 'TSortFilterManagement';

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void updateSort(TSortType<MODEL> sort) {
    _activeSort.update(sort);
    upsertList(
      listId,
      getSortFilteredList(listId).copyWith(
        sort: (a, b) => sort.sort(a: a, b: b),
      ),
    );
  }

  void updateFilters(List<({TFilterType<MODEL> filter, dynamic input})> filters) {
    _activeFilters.update(filters);
    upsertList(
      listId,
      getSortFilteredList(listId).copyWith(
        filters: _currentFilters,
      ),
    );
  }

  @override
  Future<void> dispose() {
    removeList(listId);
    return super.dispose();
  }
}
