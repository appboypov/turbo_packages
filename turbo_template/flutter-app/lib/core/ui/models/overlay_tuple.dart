import 'package:flutter/material.dart';

class OverlayTuple {
  const OverlayTuple({required this.overlayEntry, required this.onDismissed});

  final OverlayEntry overlayEntry;
  final VoidCallback? onDismissed;
}
