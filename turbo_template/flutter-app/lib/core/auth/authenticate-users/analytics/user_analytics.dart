
import 'package:turbo_flutter_template/core/auth/authenticate-users/abstracts/analytics.dart';
import 'package:turbo_flutter_template/core/auth/enums/user_level.dart';
import 'package:turbolytics/turbolytics.dart';

class UserAnalytics extends Analytics {
  static UserAnalytics locate({required String location}) =>
          Turbolytics.getAnalytics(location: location);

  /// setUserLevel logs an event indicating that a user level has been set.
  void setUserLevel({required UserLevel userLevel}) =>
          service.userProperty(property: subjects.userLevel, value: userLevel.name);

  /// setUserId logs an event indicating that a user ID has been set.
  void setUserId({required String userId}) => service.userId(userId: userId);
}
