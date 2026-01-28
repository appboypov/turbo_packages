import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_flutter_template/core/auth/enums/user_level.dart';
import 'package:turbo_flutter_template/core/auth/globals/g_now.dart';
import 'package:turbo_flutter_template/core/storage/converters/duration_days_converter.dart';
import 'package:turbo_flutter_template/core/storage/converters/timestamp_converter.dart';

part 'user_level_dto.g.dart';

@JsonSerializable(includeIfNull: true, explicitToJson: true)
class UserLevelDto {
  UserLevelDto({
    required this.startedAt,
    required this.updatedAt,
    required this.userLevel,
    required this.userLevelDurationInDays,
  });

  factory UserLevelDto.defaultValue() {
    final now = gNow;
    return UserLevelDto(
      startedAt: now,
      updatedAt: now,
      userLevel: UserLevel.free,
      userLevelDurationInDays: null,
    );
  }

  @TimestampConverter()
  final DateTime startedAt;
  @TimestampConverter()
  final DateTime updatedAt;
  final UserLevel userLevel;
  @DurationDaysConverter()
  final Duration? userLevelDurationInDays;

  static const fromJsonFactory = _$UserLevelDtoFromJson;
  factory UserLevelDto.fromJson(Map<String, dynamic> json) => _$UserLevelDtoFromJson(json);
  static const toJsonFactory = _$UserLevelDtoToJson;
  Map<String, dynamic> toJson() => _$UserLevelDtoToJson(this);

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  bool get isExpired =>
      userLevelDurationInDays != null && startedAt.add(userLevelDurationInDays!).isBefore(gNow);
}
