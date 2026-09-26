import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/intents/dtos/t_organisation_dto.dart';
import 'package:turbo_promptable/intents/dtos/t_product_dto.dart';
import 'package:turbo_promptable/intents/dtos/t_question_dto.dart';
import 'package:turbo_promptable/intents/dtos/t_reference_dto.dart';
import 'package:turbo_promptable/intents/dtos/t_repo_dto.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_issue.dart';
import 'package:turbo_promptable/issues/dtos/t_linear_team.dart';

part 't_intent_dto.g.dart';

/// One outcome the user wants, with the user's own words kept apart from how
/// they are read.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TIntentDto {
  const TIntentDto({
    required this.id,
    required this.userRequests,
    required this.endGoal,
    this.team,
    this.product,
    this.repo,
    this.issue,
    this.changeId,
    this.conversation,
    this.reason,
    this.openQuestions = const [],
    this.material = const [],
  });

  /// Unique intent id, equal to the file name of the intent.
  final String id;

  /// The user's requests and corrections, word for word.
  final List<String> userRequests;

  /// The outcome the user asked for, without implementation choices.
  final String endGoal;

  /// Linear team the intent is for; a [TOrganisationDto] is also a team.
  final TLinearTeamDto? team;

  /// Product the intent is about.
  final TProductDto? product;

  /// Repository the work happens in.
  final TRepoDto? repo;

  /// Linear outcome issue that covers the intent.
  final TLinearIssueDto? issue;

  /// Id of the repository change, which stays valid after the change is
  /// archived, unlike its folder.
  final String? changeId;

  /// Reference to the conversation the intent came from.
  final String? conversation;

  /// Why the user wants the outcome.
  final String? reason;

  /// Questions about what the user wants, with their answers once given.
  final List<TQuestionDto> openQuestions;

  /// Preparation and delivered output of the intent.
  final List<TReferenceDto> material;

  factory TIntentDto.fromJson(Map<String, dynamic> json) =>
      _$TIntentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TIntentDtoToJson(this);
}
