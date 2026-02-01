import 'package:flutter/foundation.dart';
import 'package:turbo_forms/src/config/t_form_field_config.dart';

/// Abstract base class for managing a collection of form field configurations.
///
/// Subclasses define their form fields by overriding [formFieldConfigs] and
/// can validate the entire form via [isValid].
abstract class TFormConfig {
  /// Map of enum identifiers to their form field configurations.
  @protected
  Map<Enum, TFormFieldConfig> get formFieldConfigs;

  /// Retrieves a typed form field configuration by its enum [id].
  TFormFieldConfig<T> formFieldConfig<T>(Enum id) =>
      formFieldConfigs[id] as TFormFieldConfig<T>;

  /// Whether all enabled and visible form fields pass validation.
  bool get isValid {
    bool formIsValid = true;
    for (final formFieldConfig in formFieldConfigs.values) {
      if (formFieldConfig.isEnabled && formFieldConfig.isVisible) {
        if (!formFieldConfig.isValid && formIsValid) formIsValid = false;
      }
    }
    return formIsValid;
  }

  /// Disposes all form field configurations and their controllers.
  void dispose() {
    for (final formFieldConfig in formFieldConfigs.values) {
      formFieldConfig.dispose();
    }
  }
}
