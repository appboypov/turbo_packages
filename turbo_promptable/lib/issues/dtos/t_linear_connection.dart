import 'package:json_annotation/json_annotation.dart';

part 't_linear_connection.g.dart';

/// Linear GraphQL connection wrapping a list of [nodes].
@JsonSerializable(
  includeIfNull: false,
  explicitToJson: true,
  genericArgumentFactories: true,
)
class TLinearConnectionDto<T> {
  const TLinearConnectionDto({
    required this.nodes,
  });

  final List<T> nodes;

  factory TLinearConnectionDto.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$TLinearConnectionDtoFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$TLinearConnectionDtoToJson(this, toJsonT);
}
