import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

export 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

part 't_spec.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TSpec extends TPromptable {
  const TSpec({
    required super.name,
    super.metaData,
  });

  factory TSpec.fromJson(Map<String, dynamic> json) => _$TSpecFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TSpecToJson(this);
}
