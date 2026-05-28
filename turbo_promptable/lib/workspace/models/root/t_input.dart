import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/models/root/t_context.dart';
import 'package:turbo_promptable/workspace/models/root/t_end_goal.dart';
import 'package:turbo_promptable/workspace/models/root/t_issue.dart';
import 'package:turbo_promptable/workspace/models/root/t_spec.dart';

part 't_input.g.dart';

/// The request side of a [TStep] or [Activity]: a prose [request] describing
/// exactly what the step receives, plus optional structured context.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TInput extends TPromptable {
  const TInput({
    required super.name,
    this.context,
    this.goals,
    this.issues,
    this.specs,
    this.parameters,
  });

  final List<TContext>? context;
  final List<TEndGoal>? goals;
  final List<TIssue>? issues;
  final List<TSpec>? specs;
  final Map<String, Object>? parameters;

  factory TInput.fromJson(Map<String, dynamic> json) => _$TInputFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TInputToJson(this);
}
