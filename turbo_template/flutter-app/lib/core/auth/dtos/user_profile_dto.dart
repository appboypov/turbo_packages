import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_flutter_template/core/auth/globals/g_now.dart';
import 'package:turbo_flutter_template/core/storage/converters/timestamp_converter.dart';
import 'package:turbo_serializable/turbo_serializable.dart';

part 'user_profile_dto.g.dart';

@JsonSerializable(includeIfNull: true, explicitToJson: true)
class UserProfileDto extends TWriteableId {
  UserProfileDto({
    required this.id,
    required this.bio,
    required this.birthDate,
    required this.createdAt,
    required this.name,
    required this.imageUrl,
    required this.userId,
    required this.updatedAt,
    required this.username,
    required this.email,
  });

  factory UserProfileDto.defaultValue({required String userId, required String username}) {
    final now = gNow;
    return UserProfileDto(
      id: userId,
      userId: userId,
      createdAt: now,
      updatedAt: now,
      name: null,
      bio: '',
      birthDate: null,
      imageUrl: null,
      username: username,
      email: null,
    );
  }

  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  final String id;

  final String userId;
  final String bio;
  final String? imageUrl;
  final String? name;
  final String? username;
  final String? email;
  @TimestampConverter()
  final DateTime? birthDate;

  @TimestampConverter()
  final DateTime createdAt;
  @TimestampConverter()
  final DateTime updatedAt;

  static const fromJsonFactory = _$UserProfileDtoFromJson;
  factory UserProfileDto.fromJson(Map<String, dynamic> json) => _$UserProfileDtoFromJson(json);
  static const toJsonFactory = _$UserProfileDtoToJson;
  @override
  Map<String, dynamic> toJson() => _$UserProfileDtoToJson(this);

  UserProfileDto copyWith({
    final String? userId,
    final String? bio,
    final String? imageUrl,
    final String? name,
    final String? username,
    final String? email,
    final DateTime? birthDate,
  }) => UserProfileDto(
    id: id,
    userId: userId ?? this.userId,
    bio: bio ?? this.bio,
    imageUrl: imageUrl ?? this.imageUrl,
    name: name ?? this.name,
    username: username ?? this.username,
    email: email ?? this.email,
    birthDate: birthDate ?? this.birthDate,
    createdAt: createdAt,
    updatedAt: gNow,
  );
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class UpdateUserProfileDtoRequest extends TWriteable {
  UpdateUserProfileDtoRequest({
    this.bio,
    this.imageUrl,
    this.name,
    this.username,
    this.email,
    this.birthDate,
  });

  final String? bio;
  final String? imageUrl;
  final String? name;
  final String? username;
  final String? email;
  @TimestampConverter()
  final DateTime? birthDate;

  static const fromJsonFactory = _$UpdateUserProfileDtoRequestFromJson;
  factory UpdateUserProfileDtoRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserProfileDtoRequestFromJson(json);
  static const toJsonFactory = _$UpdateUserProfileDtoRequestToJson;
  @override
  Map<String, dynamic> toJson() => _$UpdateUserProfileDtoRequestToJson(this);
}
