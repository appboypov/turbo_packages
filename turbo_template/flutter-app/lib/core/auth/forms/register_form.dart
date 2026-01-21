import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/ux/abstracts/t_form_config.dart';
import 'package:turbo_flutter_template/core/ux/config/t_form_field_config.dart';
import 'package:turbo_flutter_template/core/ux/constants/k_value_validators.dart';
import 'package:turbo_flutter_template/core/ux/enums/t_field_type.dart';

enum _RegisterFormField { email, password, confirmPassword, agreePrivacy }

class RegisterForm extends TFormConfig {
  static RegisterForm get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(RegisterForm.new);

  TFormFieldConfig<String> get email => formFieldConfig(_RegisterFormField.email);
  TFormFieldConfig<String> get password => formFieldConfig(_RegisterFormField.password);
  TFormFieldConfig<String> get confirmPassword =>
      formFieldConfig(_RegisterFormField.confirmPassword);
  TFormFieldConfig<bool> get agreePrivacy => formFieldConfig(_RegisterFormField.agreePrivacy);

  @override
  late final Map<Enum, TFormFieldConfig> formFieldConfigs = {
    _RegisterFormField.email: TFormFieldConfig<String>(
      id: _RegisterFormField.email,
      fieldType: TFieldType.textInput,
      valueValidator: kValueValidatorsMultiple([
        kValueValidatorsRequired(errorText: () => 'Please enter your email'),
        kValueValidatorsEmail(errorText: () => 'Please enter a valid email'),
      ]),
    ),
    _RegisterFormField.password: TFormFieldConfig<String>(
      id: _RegisterFormField.password,
      fieldType: TFieldType.textInput,
      obscureText: true,
      valueValidator: kValueValidatorsMultiple([
        kValueValidatorsRequired(errorText: () => 'Please enter your password'),
        kValueValidatorsMinLength(
          minLength: 8,
          errorText: () => 'Password must be at least 8 characters',
        ),
      ]),
    ),
    _RegisterFormField.confirmPassword: TFormFieldConfig<String>(
      id: _RegisterFormField.confirmPassword,
      fieldType: TFieldType.textInput,
      obscureText: true,
      valueValidator: kValueValidatorsMultiple([
        kValueValidatorsRequired(errorText: () => 'Please confirm your password'),
        kValueValidatorsEquals(
          otherValue: () => password.cValue,
          errorText: () => 'Passwords do not match',
        ),
      ]),
    ),
    _RegisterFormField.agreePrivacy: TFormFieldConfig<bool>(
      id: _RegisterFormField.agreePrivacy,
      fieldType: TFieldType.checkbox,
      valueValidator: kValueValidatorsIsTrue(
        errorText: () => 'Please read and accept our privacy policy',
      ),
    ),
  };
}
