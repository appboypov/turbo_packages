import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_context.dart';

part 't_documentation.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TDocumentation extends TContext {
  const TDocumentation({
    required super.name,
  });

  factory TDocumentation.fromJson(Map<String, dynamic> json) =>
      _$TDocumentationFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TDocumentationToJson(this);
}
