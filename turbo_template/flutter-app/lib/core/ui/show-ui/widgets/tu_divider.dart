import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_margin.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';

class TDivider extends StatelessWidget {
  const TDivider({
    Key? key,
    required this.topPadding,
    required this.bottomPadding,
    this.horizontalPadding = TSizes.appPadding,
  }) : super(key: key);

  final double topPadding;
  final double bottomPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) => TMargin.horizontal(
    left: horizontalPadding,
    right: horizontalPadding,
    child: Column(
      children: [
        Gap(topPadding),
        Container(
          height: 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: context.colors.border,
          ),
          width: double.infinity,
        ),
        Gap(bottomPadding),
      ],
    ),
  );
}
