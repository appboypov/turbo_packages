/// Represents different user access levels in the application.
///
/// The levels are ordered hierarchically from lowest to highest:
/// - [unknown]: Default state for unidentified users
/// - [free]: Basic access level
/// - [friend]: Enhanced access for friends
/// - [premium]: Premium member access
/// - [admin]: Full administrative access
///
/// Example:
/// ```dart
/// final userLevel = UserLevel.premium;
/// final otherLevel = UserLevel.free;
///
/// // Compare levels
/// final highestLevel = userLevel.highest(otherLevel); // Returns UserLevel.premium
///
/// // Check specific levels
/// print(userLevel.isPremium); // true
/// print(userLevel.isAdmin); // false
/// ```
enum UserLevel {
  unknown,
  free,
  friend,
  premium,
  admin;

  UserLevel highest(UserLevel userLevel) => index > userLevel.index ? this : userLevel;

  bool get isUnknown => this == unknown;
  bool get isAdmin => this == admin;
  bool get isFriend => this == friend;
  bool get isPremium => this == premium;
}
