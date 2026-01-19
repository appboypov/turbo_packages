import 'package:flutter/widgets.dart';
import 'package:roomy_mobile/ui/widgets/t_provider.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';

class TWrapping extends StatelessWidget {
  const TWrapping._({
    super.key,
    required this.child,
    required this.leading,
    required this.trailing,
    required this.direction,
    required this.crossAxisAlignment,
    required this.mainAxisAlignment,
    required this.mainAxisSize,
    required this.spacing,
  });

  const TWrapping.horizontal({
    Key? key,
    required Widget child,
    required Widget leading,
    required Widget trailing,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    double spacing = TSizes.appPaddingX0p5,
  }) : this._(
         key: key,
         child: child,
         leading: leading,
         trailing: trailing,
         direction: Axis.horizontal,
         crossAxisAlignment: crossAxisAlignment,
         mainAxisAlignment: mainAxisAlignment,
         mainAxisSize: mainAxisSize,
         spacing: spacing,
       );

  const TWrapping.vertical({
    Key? key,
    required Widget child,
    required Widget leading,
    required Widget trailing,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    double spacing = TSizes.appPaddingX0p5,
  }) : this._(
         key: key,
         child: child,
         leading: leading,
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
  final Widget leading;
  final Widget trailing;
  final double spacing;

  @override
  Widget build(BuildContext context) => Flex(
    crossAxisAlignment: crossAxisAlignment,
    direction: direction,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    spacing: spacing,
    children: [leading, child, trailing],
  );
}
