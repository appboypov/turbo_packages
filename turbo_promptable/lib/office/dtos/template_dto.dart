import 'package:json_annotation/json_annotation.dart';

import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';

part 'template_dto.g.dart';

/// Represents a template in the Pew Pew Plaza hierarchy.
///
/// Templates are reusable patterns such as issue templates,
/// code snippets, or document structures that can be instantiated
/// with variables.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class TemplateDto extends TurboPromptable {
  /// Creates a [TemplateDto] with the given properties.
  TemplateDto({
    super.metaData,
    this.variables,
  });

  /// Template variables.
  ///
  /// A map of variable names to their default values or descriptions.
  final Map<String, String>? variables;

  static const fromJsonFactory = _$TemplateDtoFromJson;
  factory TemplateDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateDtoFromJson(json);
  static const toJsonFactory = _$TemplateDtoToJson;
  @override
  Map<String, dynamic> toJsonImpl() => _$TemplateDtoToJson(this);

  TemplateDto copyWith({
    MetaDataDto? metaData,
    Map<String, String>? variables,
  }) {
    return TemplateDto(
      metaData: metaData ?? this.metaData,
      variables: variables ?? this.variables,
    );
  }
}
