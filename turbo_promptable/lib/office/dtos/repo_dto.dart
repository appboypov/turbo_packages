import 'package:json_annotation/json_annotation.dart';

import '../../shared/abstracts/turbo_promptable.dart';
import '../../shared/dtos/meta_data_dto.dart';

part 'repo_dto.g.dart';

/// Represents a repository reference in the Pew Pew Plaza hierarchy.
///
/// Repos are references to code repositories, either local paths
/// or remote URLs.
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class RepoDto extends TurboPromptable {
  /// Creates a [RepoDto] with the given properties.
  RepoDto({
    this.url,
    this.projectKey,
    this.projectManagementUrl,
    this.readMe,
    this.architecture,
    this.instructions,
  });

  final String? url;
  final String? projectKey;
  final String? projectManagementUrl;
  final String? readMe;
  final String? architecture;
  final String? instructions;

  static const fromJsonFactory = _$RepoDtoFromJson;
  factory RepoDto.fromJson(Map<String, dynamic> json) =>
      _$RepoDtoFromJson(json);
  static const toJsonFactory = _$RepoDtoToJson;
  @override
  Map<String, dynamic> toJson() => _$RepoDtoToJson(this);

  RepoDto copyWith({
    String? url,
    String? projectKey,
    String? projectManagementUrl,
    String? readMe,
    String? architecture,
    String? instructions,
  }) {
    return RepoDto(
      url: url ?? this.url,
      projectKey: projectKey ?? this.projectKey,
      projectManagementUrl: projectManagementUrl ?? this.projectManagementUrl,
      readMe: readMe ?? this.readMe,
      architecture: architecture ?? this.architecture,
      instructions: instructions ?? this.instructions,
    );
  }

  @override
  String toString() => 'RepoDto{url: $url, projectKey: $projectKey, projectManagementUrl: $projectManagementUrl, readMe: $readMe, architecture: $architecture, instructions: $instructions}';
}
