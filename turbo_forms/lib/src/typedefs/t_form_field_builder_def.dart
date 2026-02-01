import 'package:flutter/material.dart';
import 'package:turbo_forms/src/config/t_form_field_config.dart';

/// Builder callback signature for constructing form field UI from a
/// [TFormFieldConfig].
typedef TFormFieldBuilderDef<T> =
    Widget Function(
      BuildContext context,
      TFormFieldConfig<T> config,
      Widget? child,
    );
