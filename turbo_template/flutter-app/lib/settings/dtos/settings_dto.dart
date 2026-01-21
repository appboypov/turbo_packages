import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_firestore_api/turbo_firestore_api.dart';
import 'package:turbo_flutter_template/core/auth/globals/g_now.dart';
import 'package:turbo_flutter_template/core/storage/converters/timestamp_converter.dart';
import 'package:turbo_serializable/turbo_serializable.dart';

part '../../core/settings/dtos/settings_dto.g.dart';

@JsonSerializable(includeIfNull: true, explicitToJson: true)
class SettingsDto extends TWriteableId {
  SettingsDto({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.skippedVerifyEmailDate,
    required this.verifyEmailSnoozeCount,
  });

  factory SettingsDto.create({required TAuthVars vars}) {
    return SettingsDto(
      userId: vars.userId,
      id: vars.userId,
      createdAt: vars.now,
      updatedAt: vars.now,
      skippedVerifyEmailDate: null,
      verifyEmailSnoozeCount: 0,
    );
  }

  @TimestampConverter()
  final DateTime createdAt;
  @TimestampConverter()
  final DateTime updatedAt;
  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  final String id;
  final String userId;

  @TimestampConverter()
  final DateTime? skippedVerifyEmailDate;
  @JsonKey(defaultValue: 0)
  final int verifyEmailSnoozeCount;

  @override
  Map<String, dynamic> toJson() => _$SettingsDtoToJson(this);
  factory SettingsDto.fromJson(Map<String, dynamic> json) => _$SettingsDtoFromJson(json);
  static const fromJsonFactory = _$SettingsDtoFromJson;
  static const toJsonFactory = _$SettingsDtoToJson;

  SettingsDto copyWith({
    String? userId,
    DateTime? skippedVerifyEmailDate,
    int? verifyEmailSnoozeCount,
  }) => SettingsDto(
    createdAt: createdAt,
    updatedAt: gNow,
    id: userId ?? id,
    userId: userId ?? this.userId,
    skippedVerifyEmailDate: skippedVerifyEmailDate ?? this.skippedVerifyEmailDate,
    verifyEmailSnoozeCount: verifyEmailSnoozeCount ?? this.verifyEmailSnoozeCount,
  );
}

extension SettingsDtoExtension on SettingsDto {
  UpdateSettingsDtoRequest get asUpdateSkippedVerifyEmailDateRequest => UpdateSettingsDtoRequest(
    skippedVerifyEmailDate: skippedVerifyEmailDate,
    verifyEmailSnoozeCount: verifyEmailSnoozeCount,
  );
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class UpdateSettingsDtoRequest extends TWriteable {
  UpdateSettingsDtoRequest({this.skippedVerifyEmailDate, this.verifyEmailSnoozeCount});

  @TimestampConverter()
  final DateTime? skippedVerifyEmailDate;
  final int? verifyEmailSnoozeCount;

  static const fromJsonFactory = _$UpdateSettingsDtoRequestFromJson;
  factory UpdateSettingsDtoRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateSettingsDtoRequestFromJson(json);
  static const toJsonFactory = _$UpdateSettingsDtoRequestToJson;
  @override
  Map<String, dynamic> toJson() => _$UpdateSettingsDtoRequestToJson(this);
}
