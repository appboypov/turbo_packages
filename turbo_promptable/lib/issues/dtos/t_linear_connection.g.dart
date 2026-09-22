// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_linear_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TLinearConnectionDto<T> _$TLinearConnectionDtoFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => TLinearConnectionDto<T>(
  nodes: (json['nodes'] as List<dynamic>).map(fromJsonT).toList(),
);

Map<String, dynamic> _$TLinearConnectionDtoToJson<T>(
  TLinearConnectionDto<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{'nodes': instance.nodes.map(toJsonT).toList()};
