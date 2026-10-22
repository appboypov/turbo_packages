import 'package:meta/meta.dart';

import '../responses/t_jev_usage_dto.dart';

/// The input and output tokens TypeSafe counted for one Request.
///
/// TypeSafe may leave a count out, so both are nullable.
final class TJevUsage {
  const TJevUsage({this.inputTokens, this.outputTokens});

  /// The Usage of [dto].
  @internal
  factory TJevUsage.fromDto(TJevUsageDto dto) =>
      TJevUsage(inputTokens: dto.inputTokens, outputTokens: dto.outputTokens);

  /// The billable input tokens.
  final int? inputTokens;

  /// The output tokens, currently free of charge.
  final int? outputTokens;
}
