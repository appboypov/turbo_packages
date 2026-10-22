// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_jev_usage_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TJevUsageDto _$TJevUsageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'TJevUsageDto',
      json,
      ($checkedConvert) {
        final val = TJevUsageDto(
          inputTokens: $checkedConvert(
            'input_tokens',
            (v) => (v as num?)?.toInt(),
          ),
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
