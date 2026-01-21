import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ux/config/t_form_field_config.dart';
import 'package:turbo_flutter_template/core/ux/typedefs/t_form_field_builder_def.dart';

class TFormFieldBuilder<T> extends StatelessWidget {
  const TFormFieldBuilder({
    super.key,
    required this.fieldConfig,
    required this.builder,
    this.child,
  });

  final TFormFieldConfig<T> fieldConfig;
  final TFormFieldBuilderDef<T> builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: fieldConfig,
    builder: (context, value, child) => builder(context, fieldConfig, this.child ?? child),
    child: child,
  );
}
