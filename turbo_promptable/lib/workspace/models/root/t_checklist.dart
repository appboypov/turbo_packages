import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

export 'package:turbo_promptable/workspace/models/meta/t_promptable.dart';

part 't_checklist.g.dart';

/// A named list of string [items] used for acceptance criteria, constraints, etc.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TChecklist extends TPromptable {
  const TChecklist({
    required super.name,
    required this.items,
  });

  final List<String> items;

  factory TChecklist.fromJson(Map<String, dynamic> json) =>
      _$TChecklistFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TChecklistToJson(this);
}
