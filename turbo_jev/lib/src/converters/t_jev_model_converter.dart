import 'package:json_annotation/json_annotation.dart';

import '../types/t_jev_model.dart';

/// Maps a model id on the wire to a [TJevModel].
final class TJevModelConverter implements JsonConverter<TJevModel, String> {
  const TJevModelConverter();

  @override
  TJevModel fromJson(String json) => TJevModel(json);

  @override
  String toJson(TJevModel model) => model.id;
}
