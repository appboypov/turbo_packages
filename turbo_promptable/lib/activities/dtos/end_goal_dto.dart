import 'package:json_annotation/json_annotation.dart';

import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';

part 'end_goal_dto.g.dart';

/// Represents an end goal in the Pew Pew Plaza hierarchy.
///
/// Defines the desired outcome with acceptance criteria and constraints.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class EndGoalDto extends TurboPromptable {
  /// Creates an [EndGoalDto] with the given properties.
  EndGoalDto({
    super.metaData,
    this.acceptanceCriteria,
    this.constraints,
  });

  final List<String>? acceptanceCriteria;
  final List<String>? constraints;

  static const fromJsonFactory = _$EndGoalDtoFromJson;
  factory EndGoalDto.fromJson(Map<String, dynamic> json) =>
      _$EndGoalDtoFromJson(json);
  static const toJsonFactory = _$EndGoalDtoToJson;
  @override
  Map<String, dynamic> toJsonImpl() => _$EndGoalDtoToJson(this);

  EndGoalDto copyWith({
    MetaDataDto? metaData,
    List<String>? acceptanceCriteria,
    List<String>? constraints,
  }) {
    return EndGoalDto(
      metaData: metaData ?? this.metaData,
      acceptanceCriteria: acceptanceCriteria ?? this.acceptanceCriteria,
      constraints: constraints ?? this.constraints,
    );
  }
}
