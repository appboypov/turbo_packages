import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/dtos/user_level_dto.dart';
import 'package:turbo_flutter_template/core/auth/globals/g_now.dart';
import 'package:turbo_flutter_template/core/storage/converters/timestamp_converter.dart';
import 'package:turbo_serializable/turbo_serializable.dart';

part 'user_dto.g.dart';

@JsonSerializable(includeIfNull: true, explicitToJson: true)
class UserDto extends TWriteableId {
  UserDto({
    required this.acceptedPrivacyAndTermsAt,
    required this.createdAt,
    required this.email,
    required this.id,
    required this.tags,
    required this.updatedAt,
    required this.userLevel,
    this.lastChangelogVersionRead,
    this.emailVerifiedAt,
    this.welcomeEmailSent,
  });

  factory UserDto.create({
    required String userId,
    required String email,
    DateTime? acceptedPrivacyAndTermsAt,
  }) {
    final now = gNow;
    return UserDto(
      acceptedPrivacyAndTermsAt: acceptedPrivacyAndTermsAt,
      id: userId,
      updatedAt: now,
      createdAt: now,
      email: email,
      tags: [],
      userLevel: UserLevelDto.defaultValue(),
      lastChangelogVersionRead: null,
      emailVerifiedAt: null,
      welcomeEmailSent: null,
    );
  }

  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  final String id;
  @JsonKey(includeFromJson: true, includeToJson: false)
  @TimestampConverter()
  final DateTime createdAt;
  @TimestampConverter()
  final DateTime updatedAt;

  @TimestampConverter()
  final DateTime? acceptedPrivacyAndTermsAt;
  final String email;

  @JsonKey(defaultValue: [])
  final List<String> tags;
  final UserLevelDto? userLevel;

  final String? lastChangelogVersionRead;

  @TimestampConverter()
  final DateTime? emailVerifiedAt;
  @TimestampConverter()
  final DateTime? welcomeEmailSent;

  static const fromJsonFactory = _$UserDtoFromJson;
  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
  static const toJsonFactory = _$UserDtoToJson;
  @override
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  @override
  String toString() {
    return 'UserDto{id: $id, createdAt: $createdAt, updatedAt: $updatedAt, acceptedPrivacyAndTermsAt: $acceptedPrivacyAndTermsAt, email: $email, tags: $tags, userLevel: $userLevel, lastChangelogVersionRead: $lastChangelogVersionRead, emailVerifiedAt: $emailVerifiedAt, welcomeEmailSent: $welcomeEmailSent}';
  }

  UserDto copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? acceptedPrivacyAndTermsAt,
    String? email,
    List<String>? tags,
    UserLevelDto? userLevel,
    String? lastChangelogVersionRead,
    DateTime? emailVerifiedAt,
    DateTime? welcomeEmailSent,
  }) {
    return UserDto(
      id: id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      acceptedPrivacyAndTermsAt: acceptedPrivacyAndTermsAt ?? this.acceptedPrivacyAndTermsAt,
      email: email ?? this.email,
      tags: tags ?? this.tags,
      userLevel: userLevel ?? this.userLevel,
      lastChangelogVersionRead: lastChangelogVersionRead ?? this.lastChangelogVersionRead,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      welcomeEmailSent: welcomeEmailSent ?? this.welcomeEmailSent,
    );
  }
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class UpdateUserDtoRequest extends TWriteable {
  UpdateUserDtoRequest({
    this.email,
    this.tags,
    this.acceptedPrivacyAndTermsAt,
    this.lastChangelogVersionRead,
    this.emailVerifiedAt,
    this.welcomeEmailSent,
  });

  @TimestampConverter()
  final DateTime? acceptedPrivacyAndTermsAt;
  final String? email;
  final List<String>? tags;
  final String? lastChangelogVersionRead;
  @TimestampConverter()
  final DateTime? emailVerifiedAt;
  @TimestampConverter()
  final DateTime? welcomeEmailSent;

  static const fromJsonFactory = _$UpdateUserDtoRequestFromJson;
  factory UpdateUserDtoRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserDtoRequestFromJson(json);
  static const toJsonFactory = _$UpdateUserDtoRequestToJson;
  @override
  Map<String, dynamic> toJson() => _$UpdateUserDtoRequestToJson(this);
}
