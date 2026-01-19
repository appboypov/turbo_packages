import 'package:flutter/widgets.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:roomy_mobile/ui/widgets/t_provider.dart';

class TMidCard extends StatelessWidget {
  const TMidCard({
    Key? key,
    required this.child,
    this.width,
    this.borderRadius = 16.0,
    this.borderWidth = TSizes.borderWidth,
  }) : super(key: key);

  final Widget child;
  final double? width;
  final double borderRadius;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.cardMidground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderWidth > 0
            ? Border.all(width: borderWidth, color: context.colors.border)
            : null,
      ),
      width: width,
      child: child,
    );
  }
}
