import 'package:flutter/material.dart';
import 'package:roomy_mobile/animations/widgets/shrinks.dart';
import 'package:roomy_mobile/data/constants/k_durations.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

class TErrorLabel extends StatelessWidget {
  const TErrorLabel({
    required String? errorText,
    required bool shouldValidate,
    this.padding,
    super.key,
  }) : _errorText = errorText,
       _shouldValidate = shouldValidate;

  final String? _errorText;
  final bool _shouldValidate;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => TVerticalShrink(
    alignment: Alignment.bottomCenter,
    fadeDuration: TDurations.animationX0p5,
    sizeDuration: TDurations.animationX0p5,
    show: _shouldValidate && (_errorText?.isNotEmpty == true),
    child: Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 4, left: 8, top: 8),
      child: Row(
        children: [Flexible(child: Text(_errorText ?? '', style: context.texts.smallDestructive))],
      ),
    ),
  );
}
