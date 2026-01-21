import 'package:flutter/foundation.dart';
import 'package:turbo_flutter_template/core/ux/manage-input/config/t_form_field_config.dart';

abstract class TFormConfig {
  @protected
  Map<Enum, TFormFieldConfig> get formFieldConfigs;

  TFormFieldConfig<T> formFieldConfig<T>(Enum id) => formFieldConfigs[id] as TFormFieldConfig<T>;

  bool get isValid {
    bool formIsValid = true;
    for (final formFieldConfig in formFieldConfigs.values) {
      if (formFieldConfig.isEnabled && formFieldConfig.isVisible) {
        if (!formFieldConfig.isValid && formIsValid) formIsValid = false;
      }
    }
    return formIsValid;
  }

  void dispose() {
    for (final formFieldConfig in formFieldConfigs.values) {
      formFieldConfig.dispose();
    }
  }
}
