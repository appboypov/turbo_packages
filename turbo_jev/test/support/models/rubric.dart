import 'package:json_annotation/json_annotation.dart';

part 'rubric.g.dart';

/// An object whose `toJson` holds its [weight].
@JsonSerializable(createFactory: false)
final class Rubric {
  const Rubric(this.weight);

  final double weight;

  Map<String, dynamic> toJson() => _$RubricToJson(this);
}
