import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_issues.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_mockups.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_prds.dart';
import 'package:turbo_promptable/workspace/abstracts/t_of_prototypes.dart';
import 'package:turbo_promptable/workspace/models/root/t_spec.dart';

part 't_task.g.dart';

/// A unit of work derived from issues, PRDs, mockups, and prototypes.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TTask extends TSpec
    implements TOfIssues, TOfPrds, TOfMockups, TOfPrototypes {
  const TTask({
    required super.name,
    super.metaData,
    this.issueIds,
    this.prdIds,
    this.mockupIds,
    this.prototypeIds,
  });

  @override
  final List<String>? issueIds;
  @override
  final List<String>? prdIds;
  @override
  final List<String>? mockupIds;
  @override
  final List<String>? prototypeIds;

  factory TTask.fromJson(Map<String, dynamic> json) => _$TTaskFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TTaskToJson(this);
}
