import 'package:turbo_flutter_template/core/auth/authenticate-users/dtos/user_dto.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/dtos/user_profile_dto.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/dtos/username_dto.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/services/user_service.dart';
import 'package:turbo_flutter_template/core/settings/dtos/settings_dto.dart';

enum FirestoreCollection {
  users,
  userProfiles,
  usernames,
  settings;

  bool get tryAddLocalDocumentReference {
    switch (this) {
      case FirestoreCollection.usernames:
        return true;
      case FirestoreCollection.users:
      case FirestoreCollection.userProfiles:
      case FirestoreCollection.settings:
        return false;
    }
  }

  bool get isCollectionGroup {
    switch (this) {
      case FirestoreCollection.users:
      case FirestoreCollection.userProfiles:
      case FirestoreCollection.usernames:
      case FirestoreCollection.settings:
        return false;
    }
  }

  Map<String, dynamic> Function(T value)? toJson<T>() => switch (this) {
        FirestoreCollection.users => UserDto.toJsonFactory,
        FirestoreCollection.userProfiles => UserProfileDto.toJsonFactory,
        FirestoreCollection.usernames => UsernameDto.toJsonFactory,
        FirestoreCollection.settings => SettingsDto.toJsonFactory,
      } as Map<String, dynamic> Function(T value)?;

  T Function(Map<String, dynamic> json)? fromJson<T>() => switch (this) {
        FirestoreCollection.users => UserDto.fromJsonFactory,
        FirestoreCollection.userProfiles => UserProfileDto.fromJsonFactory,
        FirestoreCollection.usernames => UsernameDto.fromJsonFactory,
        FirestoreCollection.settings => SettingsDto.fromJsonFactory,
      } as T Function(Map<String, dynamic> json)?;

  String get collectionName {
    switch (this) {
      case FirestoreCollection.users:
      case FirestoreCollection.userProfiles:
      case FirestoreCollection.usernames:
      case FirestoreCollection.settings:
        return name;
    }
  }

  String get apiName {
    switch (this) {
      case FirestoreCollection.users:
        return 'UsersApi';
      case FirestoreCollection.userProfiles:
        return 'ProfilesApi';
      case FirestoreCollection.usernames:
        return 'UsernamesApi';
      case FirestoreCollection.settings:
        return 'SettingsApi';
    }
  }

  String path({
    String? householdId,
    String? userId,
    String? cleaningTaskId,
    String? cleaningScheduleId,
  }) {
    switch (this) {
      case FirestoreCollection.users:
      case FirestoreCollection.userProfiles:
      case FirestoreCollection.usernames:
        return collectionName;
      case FirestoreCollection.settings:
        return '${FirestoreCollection.users.path()}/$userId/$collectionName';
    }
  }

  static Future<List> get isAppReady {
    final List<Future> futures = [];
    for (final collection in FirestoreCollection.values) {
      switch (collection) {
        case FirestoreCollection.users:
          futures.add(UserService.locate.isReady);
          break;
        case FirestoreCollection.userProfiles:
        case FirestoreCollection.usernames:
        case FirestoreCollection.settings:
          break;
      }
    }
    return Future.wait(futures);
  }
}
