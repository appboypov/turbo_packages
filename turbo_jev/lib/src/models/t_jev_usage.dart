import 'package:json_annotation/json_annotation.dart';

part 't_jev_usage.g.dart';

/// The input and output tokens TypeSafe counted for one Request.
///
/// TypeSafe may leave a count out, so both are nullable.
@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
final class TJevUsage {
  const TJevUsage({this.inputTokens, this.outputTokens});

  factory TJevUsage.fromJson(Map<String, dynamic> json) =>
      _$TJevUsageFromJson(json);

  /// The billable input tokens.
  final int? inputTokens;

  /// The output tokens, currently free of charge.
  final int? outputTokens;
}
