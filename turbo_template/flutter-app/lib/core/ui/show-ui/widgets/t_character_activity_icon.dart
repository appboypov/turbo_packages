import 'package:flutter/material.dart';

import 'package:roomy_mobile/ui/enums/character_activity.dart';

class TCharacterActivityIcon extends StatelessWidget {
  const TCharacterActivityIcon({
    super.key,
    required this.activity,
    this.size = 40.0,
  });

  final CharacterActivity activity;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          activity.assetPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
