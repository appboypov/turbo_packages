import 'package:flutter/cupertino.dart';

class Selectable<T> {
  const Selectable({
    required this.label,
    required this.iconData,
    required this.value,
  });

  final String label;
  final IconData iconData;
  final T value;
}
