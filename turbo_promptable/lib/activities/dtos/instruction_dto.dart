import 'package:json_annotation/json_annotation.dart';

import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';

part 'instruction_dto.g.dart';

/// Represents an instruction in the Pew Pew Plaza hierarchy.
///
/// Instructions are how-to guides, behavioral rules, or procedural
/// documentation that guide agent behavior.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class InstructionDto extends TurboPromptable {
  /// Creates an [InstructionDto] with the given properties.

  static const fromJsonFactory = _$InstructionDtoFromJson;
  factory InstructionDto.fromJson(Map<String, dynamic> json) => _$InstructionDtoFromJson(json);
  static const toJsonFactory = _$InstructionDtoToJson;
  @override
  Map<String, dynamic> toJson() => _$InstructionDtoToJson(this);
}
