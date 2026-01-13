import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_colors.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/models/t_sizes.dart';

class TTexts {
  const TTexts({required this.sizes, required this.colors});

  final TSizes sizes;
  final TColors colors;

  TextStyle get small => const TextStyle(fontSize: 12);
  TextStyle get p => const TextStyle(fontSize: 14);
}
