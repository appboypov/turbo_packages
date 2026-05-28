import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

part 't_reference.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TReference extends TPromptable {
  const TReference({
    required super.name,
    super.metaData,
  });

  factory TReference.fromJson(Map<String, dynamic> json) =>
      _$TReferenceFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TReferenceToJson(this);
}
