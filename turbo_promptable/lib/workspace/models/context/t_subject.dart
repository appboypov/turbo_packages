import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_context.dart';

part 't_subject.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TSubject extends TContext {
  const TSubject({
    required super.name,
  });

  factory TSubject.fromJson(Map<String, dynamic> json) =>
      _$TSubjectFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TSubjectToJson(this);
}
