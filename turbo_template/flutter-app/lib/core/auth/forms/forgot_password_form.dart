import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/ux/constants/k_value_validators.dart';
import 'package:turbo_forms/turbo_forms.dart';

enum _ForgotPasswordFormField { email }

class ForgotPasswordForm extends TFormConfig {
  static ForgotPasswordForm get locate => GetIt.I.get();
  static void registerFactory() =>
      GetIt.I.registerFactory(ForgotPasswordForm.new);

  TFormFieldConfig<String> get email =>
      formFieldConfig(_ForgotPasswordFormField.email);

  @override
  late final Map<Enum, TFormFieldConfig> formFieldConfigs = {
    _ForgotPasswordFormField.email: TFormFieldConfig<String>(
      id: _ForgotPasswordFormField.email,
      fieldType: TFieldType.textInput,
      valueValidator: kValueValidatorsMultiple([
        kValueValidatorsRequired(errorText: () => 'Please enter your email'),
        kValueValidatorsEmail(errorText: () => 'Please enter a valid email'),
      ]),
    ),
  };
}
