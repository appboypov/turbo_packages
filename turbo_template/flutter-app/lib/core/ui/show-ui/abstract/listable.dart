import 'package:flutter/cupertino.dart';

abstract class Listable {
  String get title;
  String? get subtitle;
  WidgetBuilder? avatarBuilder;
  bool shouldShowInSearch(String query);
}
