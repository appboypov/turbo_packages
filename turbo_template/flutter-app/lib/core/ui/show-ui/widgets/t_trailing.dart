import 'package:flutter/widgets.dart';
import 'package:roomy_mobile/ui/widgets/t_provider.dart';

class TTrailing extends StatelessWidget {
  const TTrailing._({
    super.key,
    required this.child,
    required this.trailing,
    required this.direction,
    required this.crossAxisAlignment,
    required this.mainAxisAlignment,
    required this.mainAxisSize,
    required this.spacing,
  });

  const TTrailing.horizontal({
    Key? key,
    required Widget child,
    required Widget trailing,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    double spacing = TSizes.appPaddingX0p5,
  }) : this._(
         key: key,
         child: child,
         trailing: trailing,
         direction: Axis.horizontal,
         crossAxisAlignment: crossAxisAlignment,
         mainAxisAlignment: mainAxisAlignment,
         mainAxisSize: mainAxisSize,
         spacing: spacing,
       );

  const TTrailing.vertical({
    Key? key,
    required Widget child,
    required Widget trailing,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    double spacing = TSizes.appPaddingX0p5,
  }) : this._(
         key: key,
         child: child,
         trailing: trailing,
         direction: Axis.vertical,
         crossAxisAlignment: crossAxisAlignment,
         mainAxisAlignment: mainAxisAlignment,
         mainAxisSize: mainAxisSize,
         spacing: spacing,
       );

  final Axis direction;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final Widget child;
  final Widget trailing;
  final double spacing;

  @override
  Widget build(BuildContext context) => Flex(
    crossAxisAlignment: crossAxisAlignment,
    direction: direction,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    spacing: spacing,
    children: [child, trailing],
  );
}
