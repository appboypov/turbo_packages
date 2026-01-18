import 'package:json_annotation/json_annotation.dart';
import 'package:roomy_mobile/auth/enums/user_level.dart';
import 'package:roomy_mobile/data/globals/g_now.dart';
import 'package:roomy_mobile/firebase/firestore/converters/duration_days_converter.dart';
import 'package:roomy_mobile/firebase/firestore/converters/timestamp_converter.dart';

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
