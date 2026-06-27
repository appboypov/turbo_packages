part of 't_form_field_config.dart';

/// Convenience extensions for string-typed form field configurations.
extension FormFieldConfigStringExtension on TFormFieldConfig<String> {
  bool get hasValue => cValue?.isNotEmpty ?? false;

  void copyControllerValueFrom(TFormFieldConfig<String> source) =>
      updateValue(source.textEditingController?.text);

  bool get valueTrimIsEmpty => value.value?.tTrimIsEmpty ?? true;
}
