// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TJevUsage _$TJevUsageFromJson(Map<String, dynamic> json) => $checkedCreate(
  'TJevUsage',
  json,
  ($checkedConvert) {
    final val = TJevUsage(
      inputTokens: $checkedConvert('input_tokens', (v) => (v as num?)?.toInt()),
      outputTokens: $checkedConvert(
        'output_tokens',
        (v) => (v as num?)?.toInt(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'inputTokens': 'input_tokens',
    'outputTokens': 'output_tokens',
  },
);
