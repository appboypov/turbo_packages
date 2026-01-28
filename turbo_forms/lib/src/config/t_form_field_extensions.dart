part of 't_form_field_config.dart';

extension FormFieldConfigStringExtension on TFormFieldConfig<String> {
  bool get valueTrimIsEmpty => value.value?.tTrimIsEmpty ?? true;
}
