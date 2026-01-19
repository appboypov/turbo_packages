import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:roomy_mobile/ui/extensions/box_constraints_extension.dart';
import 'package:roomy_mobile/ui/models/t_data.dart';
import 'package:roomy_mobile/ui/utils/t_tools.dart';

class TResponsiveBuilder extends StatelessWidget {
  const TResponsiveBuilder({super.key, required this.builder, this.child});

  final Widget Function(
    BuildContext context,
    Widget? child,
    BoxConstraints constraints,
    TTools tools,
    TData data,
  )
  builder;

  final Widget? child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final builtWidget = builder(
        context,
        child,
        constraints,
        context.tools.copyWith(
          currentWidth: constraints.maxWidth,
          currentHeight: constraints.maxHeight,
        ),
        context.data.copyWith(
          currentWidth: constraints.maxWidth,
          currentHeight: constraints.maxHeight,
          deviceType: constraints.turboDeviceType(breakpointConfig: context.breakpointConfig),
          orientation: constraints.turboOrientation,
        ),
      );

      // Wrap the result in a SizedBox to avoid intrinsic dimension calculations
      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: builtWidget,
      );
    },
  );
}
