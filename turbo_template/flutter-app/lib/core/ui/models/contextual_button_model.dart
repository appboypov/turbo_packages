import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ContextualButtonModel {
  const ContextualButtonModel({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback onPressed;
}
