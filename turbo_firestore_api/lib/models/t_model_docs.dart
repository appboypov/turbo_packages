import 'package:turbo_firestore_api/abstracts/t_model.dart';
import 'package:turbo_firestore_api/abstracts/t_sort_option.dart';
import 'package:turbo_firestore_api/models/t_filter_input.dart';
import 'package:turbo_firestore_api/models/t_list.dart';
import 'package:turbo_firestore_api/typedefs/t_id_map_def.dart';
import 'package:turbo_firestore_api/typedefs/t_model_builder_def.dart';
import 'package:turbo_serializable/abstracts/t_writeable_id.dart';

class TModelDocs<DTO extends TWriteableId, MODEL extends TModel<DTO>> {
  const TModelDocs({
    required TIdMapDef<MODEL> idMap,
    required TList<DTO, MODEL> list,
    required this.modelBuilder,
  }) : _list = list,
       _idMap = idMap;

  factory TModelDocs.empty({
    required TModelBuilderDef<DTO, MODEL> modelBuilder,
  }) => TModelDocs(
    idMap: {},
    modelBuilder: modelBuilder,
    list: TList.empty(),
  );

  factory TModelDocs.fromDtos({
    required List<DTO> dtos,
    required TModelBuilderDef<DTO, MODEL> modelBuilder,
    required TSortOption? sort,
    required Set<TFilterInput>? filters,
  }) {
    final idMap = <String, MODEL>{};
    final models = <MODEL>[];
    for (final dto in dtos) {
      final model = modelBuilder(dto);
      models.add(model);
      idMap[model.id] = model;
    }
    return TModelDocs<DTO, MODEL>(
      idMap: idMap,
      modelBuilder: modelBuilder,
      list: TList(
        filters: filters,
        sort: sort,
        models: models,
      ),
    );
  }

  final TModelBuilderDef<DTO, MODEL> modelBuilder;
  final TIdMapDef<MODEL> _idMap;
  final TList<DTO, MODEL> _list;

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  bool get isNotEmpty => _idMap.isNotEmpty;
  bool get isEmpty => _idMap.isEmpty;
  bool exists(String id) => _idMap.containsKey(id);
  DTO? dto(String? id) => _idMap[id]?.dto;
  MODEL? get(String? id) => _idMap[id];
  MODEL? remove(String id) {
    _list.remove(id);
    return _idMap.remove(id);
  }

  Iterable<String> get ids => _idMap.keys;
  Iterable<MODEL> get docs => _idMap.values;
  List<MODEL> get list => _list.values;
  TSortOption? get sort => _list.sort;
  Set<TFilterInput>? get filters => _list.filters;

  Iterable<MODEL> findWhere(bool Function(MODEL model) test) => _idMap.values.where(test);

  List<MODEL> listByIds(Iterable<String> ids) {
    final models = <MODEL>[];
    for (final id in ids) {
      final model = _idMap[id];
      if (model != null) {
        models.add(model);
      }
    }
    return models;
  }

  List<MODEL> upsertDtos(Iterable<DTO> newValues) {
    final models = <MODEL>[];
    for (final newValue in newValues) {
      final model = upsertDto(newValue);
      models.add(model);
      _list.add(model);
    }
    return models;
  }

  List<MODEL> upsertValues(Iterable<MODEL> newValues) {
    final models = <MODEL>[];
    for (final newValue in newValues) {
      final model = upsertValue(newValue);
      models.add(model);
    }
    return models;
  }

  MODEL upsertDto(DTO newValue) {
    final model = upsertValue(modelBuilder(newValue));
    _list.add(model);
    return model;
  }

  MODEL upsertValue(MODEL newValue) {
    _idMap[newValue.id] = newValue;
    return newValue;
  }

  int get length => _idMap.length;

  void updateSort(TSortOption<MODEL> sort) => _list.updateSort(sort: sort);
  void updateFilters(Set<TFilterInput> filters) => _list.updateFilters(
    filters: filters,
    models: docs,
  );
}
