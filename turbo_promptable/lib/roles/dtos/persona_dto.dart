import 'package:json_annotation/json_annotation.dart';

import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';

part 'persona_dto.g.dart';

/// Represents an agent's identity and personality.
///
/// Contains personality traits, communication tone, and behavioral constraints.
/// Can be used as a property of [SubAgentDto] or [RoleDto] for composition.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class PersonaDto extends TurboPromptable {
  /// Creates a [PersonaDto] with the given properties.
  PersonaDto({
    super.metaData,
    this.achievements,
    this.background,
    this.communicationStyle,
    this.nickname,
    this.preferences,
    this.resume,
    this.values,
  });

  final List<String>? achievements;
  final List<String>? preferences;
  final List<String>? resume;
  final List<String>? values;
  final String? background;
  final String? communicationStyle;
  final String? nickname;

  static const fromJsonFactory = _$PersonaDtoFromJson;
  factory PersonaDto.fromJson(Map<String, dynamic> json) =>
      _$PersonaDtoFromJson(json);
  static const toJsonFactory = _$PersonaDtoToJson;
  @override
  Map<String, dynamic> toJsonImpl() => _$PersonaDtoToJson(this);

  PersonaDto copyWith({
    MetaDataDto? metaData,
    List<String>? achievements,
    List<String>? preferences,
    List<String>? resume,
    List<String>? values,
    String? background,
    String? communicationStyle,
    String? nickname,
  }) {
    return PersonaDto(
      metaData: metaData ?? this.metaData,
      achievements: achievements ?? this.achievements,
      preferences: preferences ?? this.preferences,
      resume: resume ?? this.resume,
      values: values ?? this.values,
      background: background ?? this.background,
      communicationStyle: communicationStyle ?? this.communicationStyle,
      nickname: nickname ?? this.nickname,
    );
  }
}
