import 'package:json_annotation/json_annotation.dart';

part 't_jev_noul_criteria_dto.g.dart';

/// The wire form of the meanings of true and false of a Noul.
@JsonSerializable(createFactory: false, includeIfNull: false)
final class TJevNoulCriteriaDto {
  const TJevNoulCriteriaDto({this.trueMeans, this.falseMeans});

  @JsonKey(name: 'true')
  final Object? trueMeans;

  @JsonKey(name: 'false')
  final Object? falseMeans;

  Map<String, dynamic> toJson() => _$TJevNoulCriteriaDtoToJson(this);
}
