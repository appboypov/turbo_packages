import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:turbo_flutter_template/core/shared/constants/t_keys.dart';

import '../../auth/enums/user_level.dart';

extension MapExtension on Map {
  UserLevel get userLevel {
    final String? rawCustomUserLevel =
        this[TKeys.userLevel] ?? (this[TKeys.activeEntitlements] as List?)?.firstOrNull;
    final customUserLevel = UserLevel.values.firstWhereOrNull(
      (element) => element.name == rawCustomUserLevel?.toLowerCase(),
    );
    if (customUserLevel?.isAdmin ?? false) return customUserLevel!;
    final String? stripeUserLevel = this[TKeys.stripeRole];
    final userLevel = UserLevel.values.firstWhere(
      (element) => element.name == stripeUserLevel,
      orElse: () => UserLevel.free,
    );
    if (userLevel.isPremium) return userLevel;
    return (customUserLevel?.isFriend ?? false) ? customUserLevel! : userLevel;
  }

  String get asJsonString => jsonEncode(this);
  bool get isAdmin => this[TKeys.admin] == true;
  String get pretty => const JsonEncoder.withIndent('  ').convert(this);
}
