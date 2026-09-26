import 'package:json_annotation/json_annotation.dart';

part 't_repo_dto.g.dart';

/// A code repository that work happens in.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TRepoDto {
  const TRepoDto({
    required this.id,
    required this.name,
    required this.path,
    this.url,
  });

  /// Unique repo id.
  final String id;

  /// Name of the repo.
  final String name;

  /// Absolute path of the local checkout.
  final String path;

  /// Remote URL of the repo.
  final String? url;

  factory TRepoDto.fromJson(Map<String, dynamic> json) =>
      _$TRepoDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TRepoDtoToJson(this);
}
