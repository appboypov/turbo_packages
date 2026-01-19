import 'package:flutter/material.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';

import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';

class TAnimatedDivider extends StatelessWidget {
  const TAnimatedDivider({Key? key, required this.show}) : super(key: key);

  final bool show;

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    duration: TDurations.animation,
    opacity: show ? 1 : 0,
    child: Divider(height: 0.5, thickness: 0.5, color: context.colors.border),
  );
}
