/// The input and output tokens TypeSafe counted for one Request.
///
/// TypeSafe may leave a count out, so both are nullable.
final class TJevUsage {
  const TJevUsage({this.inputTokens, this.outputTokens});

  /// The billable input tokens.
  final int? inputTokens;

  /// The output tokens, currently free of charge.
  final int? outputTokens;
}
