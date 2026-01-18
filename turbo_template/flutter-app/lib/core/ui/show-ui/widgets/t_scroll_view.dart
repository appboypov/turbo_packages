import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class TScrollView extends StatelessWidget {
  const TScrollView({
    Key? key,
    this.child,
    this.children = const [],
    this.clipBehavior = Clip.hardEdge,
    this.controller,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.dragStartBehavior = DragStartBehavior.start,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.padding,
    this.physics = const BouncingScrollPhysics(),
    this.primary,
    this.restorationId,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.slivers,
    this.spacing = 0.0,
    this.textBaseline,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
  }) : super(key: key);

  final Axis scrollDirection;
  final Clip clipBehavior;
  final CrossAxisAlignment crossAxisAlignment;
  final DragStartBehavior dragStartBehavior;
  final EdgeInsetsGeometry? padding;
  final HitTestBehavior hitTestBehavior;
  final List<Widget> children;
  final List<Widget>? slivers;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final ScrollController? controller;
  final ScrollPhysics physics;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final TextBaseline? textBaseline;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final Widget? child;
  final bool reverse;
  final bool? primary;
  final double spacing;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    dragStartBehavior: dragStartBehavior,
    keyboardDismissBehavior: keyboardDismissBehavior,
    clipBehavior: clipBehavior,
    padding: padding,
    reverse: reverse,
    primary: primary,
    restorationId: restorationId,
    scrollDirection: scrollDirection,
    physics: physics,
    hitTestBehavior: hitTestBehavior,
    controller: controller,
    child:
        child ??
        Flex(
          direction: scrollDirection,
          children: children,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          spacing: spacing,
          textBaseline: textBaseline,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
        ),
  );
}
