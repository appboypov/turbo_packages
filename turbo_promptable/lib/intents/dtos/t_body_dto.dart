import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/intents/enums/t_body_source.dart';
import 'package:turbo_promptable/intents/enums/t_content_type.dart';

part 't_body_dto.g.dart';

/// Content of a reference: where it is kept and what kind it is.
///
/// Follows the `bodies` table of Skuddy OS. Its `db` source is
/// [TBodySource.content] here, and its `media_type`, `filename` and
/// `body_bytes` are left out: they serve binary content in a database.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TBodyDto {
  const TBodyDto({
    required this.bodySource,
    required this.contentType,
    required this.body,
  });

  /// Where the body is kept.
  final TBodySource bodySource;

  /// What kind of content the body holds.
  final TContentType contentType;

  /// The content, the absolute path or the URL, per [bodySource].
  final String body;

  factory TBodyDto.fromJson(Map<String, dynamic> json) =>
      _$TBodyDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TBodyDtoToJson(this);
}
