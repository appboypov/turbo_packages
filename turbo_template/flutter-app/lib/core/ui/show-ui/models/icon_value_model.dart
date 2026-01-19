import 'package:flutter/material.dart';

class IconValueModel {
  final IconData iconData;
  final String value;
  final Future<void> Function(String value)? onPressed;

  IconValueModel({required this.iconData, required this.value, this.onPressed});
}
