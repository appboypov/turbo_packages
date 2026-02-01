import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/ux/constants/k_value_validators.dart';
import 'package:turbo_forms/turbo_forms.dart';

enum _LoginFormField { email, password }

class LoginForm extends TFormConfig {
  static LoginForm get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(LoginForm.new);

  TFormFieldConfig<String> get email => formFieldConfig(_LoginFormField.email);
  TFormFieldConfig<String> get password =>
      formFieldConfig(_LoginFormField.password);

  @override
  late final Map<Enum, TFormFieldConfig> formFieldConfigs = {
    _LoginFormField.email: TFormFieldConfig<String>(
      id: _LoginFormField.email,
      fieldType: TFieldType.textInput,
      valueValidator: kValueValidatorsMultiple([
        kValueValidatorsRequired(errorText: () => 'Please enter your email'),
        kValueValidatorsEmail(errorText: () => 'Please enter a valid email'),
      ]),
    ),
    _LoginFormField.password: TFormFieldConfig<String>(
      id: _LoginFormField.password,
      initialValue: null,
      fieldType: TFieldType.textInput,
      obscureText: true,
      valueValidator: kValueValidatorsRequired(
        errorText: () => 'Please enter your password',
      ),
    ),
  };
}
