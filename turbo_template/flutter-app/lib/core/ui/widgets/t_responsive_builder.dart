import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/models/t_data.dart';
import 'package:turbo_flutter_template/core/ui/utils/t_tools.dart';
import 'package:turbo_flutter_template/core/ui/widgets/box_constraints_extension.dart';

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
          deviceType: constraints.deviceType(breakpointConfig: context.breakpointConfig),
          orientation: constraints.orientation,
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
