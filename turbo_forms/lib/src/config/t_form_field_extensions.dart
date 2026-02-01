part of 't_form_field_config.dart';

/// Convenience extensions for string-typed form field configurations.
extension FormFieldConfigStringExtension on TFormFieldConfig<String> {
  bool get valueTrimIsEmpty => value.value?.tTrimIsEmpty ?? true;
}
