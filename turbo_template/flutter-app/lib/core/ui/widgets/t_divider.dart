import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';

class TDivider extends StatelessWidget {
  const TDivider({Key? key, this.height}) : super(key: key);

  final double? height;
  @override
  Widget build(BuildContext context) => Divider(
    color: context.colors.softBorder.withValues(alpha: 0.7),
    indent: 1,
    endIndent: 1,
    height: height,
  );
}
