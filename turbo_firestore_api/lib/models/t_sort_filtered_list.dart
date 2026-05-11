import 'package:turbo_firestore_api/abstracts/t_model.dart';
import 'package:turbo_firestore_api/typedefs/t_sort_filter_defs.dart';
import 'package:turbo_serializable/abstracts/t_writeable_id.dart';

class TSortFilteredList<DTO extends TWriteableId, MODEL extends TModel<DTO>> {
  TSortFilteredList({
    this.filters,
    this.sort,
    List<MODEL>? values,
  }) : _values = values ?? [];

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\
  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  final List<TFilterPredicate<MODEL>>? filters;
  final TSortPredicate<MODEL>? sort;

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\

  List<MODEL> _values = [];

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  List<MODEL> get values => _values;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  Iterable<MODEL> _filtered(Iterable<MODEL> models) =>
      models.where((element) => filters!.every((predicate) => predicate(element)));

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  List<MODEL> apply(Iterable<MODEL> models) {
    final filtered = filters == null || filters!.isEmpty
        ? models.toList()
        : _filtered(models).toList();
    if (sort != null) {
      filtered.sort(sort);
    }
    _values = filtered;
    return _values;
  }

  List<MODEL> add(MODEL model) {
    if (filters?.every((element) => element(model)) ?? true) {
      _values.add(model);
      if (sort != null) {
        _values.sort(sort);
      }
    }
    return _values;
  }

  List<MODEL> remove(String id) => _values..removeWhere((dto) => dto.id == id);

  TSortFilteredList<DTO, MODEL> copyWith({
    List<TFilterPredicate<MODEL>>? filters,
    TSortPredicate<MODEL>? sort,
    List<MODEL>? values,
  }) => TSortFilteredList<DTO, MODEL>(
    filters: filters ?? this.filters,
    sort: sort ?? this.sort,
    values: values ?? this.values,
  );
}
