import 'package:flutter/material.dart';
import 'package:turbo_forms/src/config/t_form_field_config.dart';
import 'package:turbo_forms/src/typedefs/t_form_field_builder_def.dart';

/// A [ValueListenableBuilder] wrapper that rebuilds when the given
/// [TFormFieldConfig] notifies of state changes.
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
    builder: (context, value, child) =>
        builder(context, fieldConfig, this.child ?? child),
    child: child,
  );
}
