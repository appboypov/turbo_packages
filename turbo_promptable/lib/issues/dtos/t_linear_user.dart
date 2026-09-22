import 'package:json_annotation/json_annotation.dart';

part 't_linear_user.g.dart';

/// Linear user or external user referenced by an issue or comment.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TLinearUserDto {
  const TLinearUserDto({
    required this.name,
    required this.displayName,
  });

  final String name;
  final String displayName;

  factory TLinearUserDto.fromJson(Map<String, dynamic> json) =>
      _$TLinearUserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TLinearUserDtoToJson(this);
}
