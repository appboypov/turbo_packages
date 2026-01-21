import 'package:turbo_serializable/turbo_serializable.dart';

import 'user_profile_dto.dart';

class CreateProfileRequest extends TWriteable {
  CreateProfileRequest({required this.profileDto});

  final UserProfileDto profileDto;

  @override
  Map<String, dynamic> toJson() => profileDto.toJson();
}
