import 'package:turbo_firestore_api/turbo_firestore_api.dart';
import 'package:turbo_serializable/abstracts/t_writeable_id.dart';

class TList<DTO extends TWriteableId, MODEL extends TModel<DTO>> {
  TList({
    required Iterable<MODEL> models,
    required List<TFilter<MODEL>>? filters,
    required TSort<MODEL>? sort,
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

  List<TFilter<MODEL>>? _filters;
  TSort<MODEL>? _sort;

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\

  List<MODEL> _values = [];

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  List<MODEL> get values => _values;
  TSort<MODEL>? get sort => _sort;
  List<TFilter<MODEL>>? get filters => _filters;

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
      (filter) => filter.value.filter(
        model: model,
        input: filter.input,
      ),
    ),
  );

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void add(MODEL model) {
    if (_filters?.every(
          (filter) => filter.value.filter(
            model: model,
            input: filter.input,
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

  void updateSort({required TSort<MODEL> sort}) {
    _sort = sort;
    final List<MODEL> _newValues = List.from(_values);
    _newValues.sort(_sort!.compare);
    _values = _newValues;
  }

  void updateFilters({
    required List<TFilter<MODEL>> filters,
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
