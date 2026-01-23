import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/entity_detail_form_field.dart';
import 'package:turbo_forms/turbo_forms.dart';

class EntityDetailForm extends TFormConfig {
  static EntityDetailForm get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(EntityDetailForm.new);

  TFormFieldConfig<String> get title => formFieldConfig(EntityDetailFormField.title);
  TFormFieldConfig<String> get status => formFieldConfig(EntityDetailFormField.status);
  TFormFieldConfig<String> get owner => formFieldConfig(EntityDetailFormField.owner);
  TFormFieldConfig<String> get summary => formFieldConfig(EntityDetailFormField.summary);
  TFormFieldConfig<bool> get isActive => formFieldConfig(EntityDetailFormField.isActive);

  @override
  late final Map<Enum, TFormFieldConfig> formFieldConfigs = {
    EntityDetailFormField.title: TFormFieldConfig<String>(
      id: EntityDetailFormField.title,
      fieldType: TFieldType.textInput,
      initialValue: 'Launch checklist',
    ),
    EntityDetailFormField.status: TFormFieldConfig<String>(
      id: EntityDetailFormField.status,
      fieldType: TFieldType.select,
      items: const ['Draft', 'In review', 'Published'],
      initialValue: 'Draft',
    ),
    EntityDetailFormField.owner: TFormFieldConfig<String>(
      id: EntityDetailFormField.owner,
      fieldType: TFieldType.textInput,
      initialValue: 'Brian Manuputty',
    ),
    EntityDetailFormField.summary: TFormFieldConfig<String>(
      id: EntityDetailFormField.summary,
      fieldType: TFieldType.textArea,
      initialValue: 'High-level summary for the entity detail view.',
    ),
    EntityDetailFormField.isActive: TFormFieldConfig<bool>(
      id: EntityDetailFormField.isActive,
      fieldType: TFieldType.checkbox,
      initialValue: true,
    ),
  };
}
