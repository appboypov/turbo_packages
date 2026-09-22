import 'package:json_annotation/json_annotation.dart';

part 't_linear_cycle.g.dart';

/// Cycle a Linear issue is planned in.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TLinearCycleDto {
  const TLinearCycleDto({
    required this.id,
    required this.number,
    this.name,
    required this.isActive,
    required this.isNext,
    required this.isPrevious,
    required this.isFuture,
    required this.isPast,
  });

  final String id;
  final int number;
  final String? name;
  final bool isActive;
  final bool isNext;
  final bool isPrevious;
  final bool isFuture;
  final bool isPast;

  factory TLinearCycleDto.fromJson(Map<String, dynamic> json) =>
      _$TLinearCycleDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TLinearCycleDtoToJson(this);
}
