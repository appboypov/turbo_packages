import 'package:turbo_promptable/core/globals/g_now.dart';
import 'package:turbo_promptable/results/dtos/t_result_dto.dart';

/// Outcome of finished work backed by a [TResultDto].
class TResult {
  const TResult({required this.dto});

  /// Creates a result finished now.
  factory TResult.create({
    required String summary,
    List<String> values = const [],
  }) => TResult(
    dto: TResultDto(summary: summary, completedAt: gNow, values: values),
  );

  final TResultDto dto;
}
