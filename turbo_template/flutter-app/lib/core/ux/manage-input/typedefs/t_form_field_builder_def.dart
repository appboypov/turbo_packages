import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ux/manage-input/config/t_form_field_config.dart';

typedef TFormFieldBuilderDef<T> =
Widget Function(BuildContext context, TFormFieldConfig<T> config, Widget? child);
