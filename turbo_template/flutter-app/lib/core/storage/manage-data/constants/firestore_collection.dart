import 'package:turbo_flutter_template/core/auth/authenticate-users/dtos/user_dto.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/services/user_service.dart';

enum FirestoreCollection {
  users;

  bool get tryAddLocalDocumentReference {
    switch (this) {
      case FirestoreCollection.users:
        return false;
    }
  }

  bool get isCollectionGroup {
    switch (this) {
      case FirestoreCollection.users:
        return false;
    }
  }

  Map<String, dynamic> Function(T value)? toJson<T>() =>
      switch (this) {
            FirestoreCollection.users => UserDto.toJsonFactory,
          }
          as Map<String, dynamic> Function(T value)?;

  T Function(Map<String, dynamic> json)? fromJson<T>() =>
      switch (this) {
            FirestoreCollection.users => UserDto.fromJsonFactory,
          }
          as T Function(Map<String, dynamic> json)?;

  String get collectionName {
    switch (this) {
      case FirestoreCollection.users:
        return name;
    }
  }

  String get apiName {
    switch (this) {
      case FirestoreCollection.users:
        return 'UsersApi';
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
        return collectionName;
    }
  }

  static Future<List> get isAppReady {
    final List<Future> futures = [];
    for (final collection in FirestoreCollection.values) {
      switch (collection) {
        case FirestoreCollection.users:
          futures.add(UserService.locate.isReady);
          break;
      }
    }
    return Future.wait(futures);
  }
}
