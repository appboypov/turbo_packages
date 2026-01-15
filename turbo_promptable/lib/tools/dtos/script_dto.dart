import 'package:json_annotation/json_annotation.dart';

import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';

part 'script_dto.g.dart';

/// Represents an executable script tool.
///
/// Extends [TurboPromptable] with script-specific properties including
/// input/output types and execution instructions.
@JsonSerializable(
    includeIfNull: true, explicitToJson: true, genericArgumentFactories: true,)
class ScriptDto<INPUT, OUTPUT> extends TurboPromptable {
  /// Creates a [ScriptDto] with the given properties.
  ScriptDto({
    super.metaData,
    this.input,
    this.output,
    this.instructions,
  });

  final INPUT? input;
  final OUTPUT? output;
  final String? instructions;

  List<TurboPromptable>? get children => null;

  factory ScriptDto.fromJson(
    Map<String, dynamic> json,
    INPUT Function(Object? json) fromJsonINPUT,
    OUTPUT Function(Object? json) fromJsonOUTPUT,
  ) =>
      _$ScriptDtoFromJson(json, fromJsonINPUT, fromJsonOUTPUT);

  /// JSON serialization method for generic types.
  /// Requires converters for INPUT and OUTPUT types.
  Map<String, dynamic> toJsonWithConverters(
    Object? Function(INPUT value) toJsonINPUT,
    Object? Function(OUTPUT value) toJsonOUTPUT,
  ) =>
      _$ScriptDtoToJson(this, toJsonINPUT, toJsonOUTPUT);

  @override
  Map<String, dynamic>? toJsonMap() {
    // For generic types, toJsonMap() cannot be implemented without type converters.
    // Use toJsonWithConverters() instead with appropriate converters.
    throw UnimplementedError(
      'ScriptDto.toJsonMap() requires type converters. Use toJsonWithConverters() instead.',
    );
  }
}
