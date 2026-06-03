import 'package:turbo_firestore_api/models/t_filter_input.dart';
import 'package:turbo_firestore_api/turbo_firestore_api.dart';
import 'package:turbo_serializable/abstracts/t_writeable_id.dart';

class TList<DTO extends TWriteableId, MODEL extends TModel<DTO>> {
  TList({
    required Iterable<MODEL> models,
    required Set<TFilterInput>? filters,
    required TSortOption? sort,
  }) : _sort = sort,
       _filters = filters {
    _apply(models: models);
  }

  factory TList.empty() => TList(
    filters: null,
    sort: null,
    models: [],
  );

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\
  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  Set<TFilterInput>? _filters;
  TSortOption? _sort;

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\

  List<MODEL> _values = [];

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  List<MODEL> get values => _values;
  TSortOption? get sort => _sort;
  Set<TFilterInput>? get filters => _filters;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  void _apply({required Iterable<MODEL> models}) {
    final filtered = _filters == null || _filters!.isEmpty
        ? models.toList()
        : _filtered(models).toList();
    if (_sort != null) {
      filtered.sort(_sort!.compare);
    }
    _values = filtered;
  }

  Iterable<MODEL> _filtered(Iterable<MODEL> models) => models.where(
    (model) => _filters!.every(
      (filter) => filter.isMatch(
        model,
      ),
    ),
  );

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void add(MODEL model) {
    if (_filters?.every(
          (filter) => filter.isMatch(
            model,
          ),
        ) ??
        true) {
      final List<MODEL> _newValues = List.from(_values);
      _newValues.add(model);
      if (_sort != null) {
        _newValues.sort(_sort!.compare);
      }
      _values = _newValues;
    }
  }

  void remove(String id) => _values.removeWhere((model) => model.id == id);

  void updateSort({required TSortOption sort}) {
    _sort = sort;
    final List<MODEL> _newValues = List.from(_values);
    _newValues.sort(_sort!.compare);
    _values = _newValues;
  }

  void updateFilters({
    required Set<TFilterInput> filters,
    required Iterable<MODEL> models,
  }) {
    _filters = filters;
    final List<MODEL> _newValues = List.from(_filtered(models));
    if (_sort != null) {
      _newValues.sort(_sort!.compare);
    }
    _values = _newValues;
  }
}
