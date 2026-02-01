import 'package:flutter/material.dart';
import 'package:turbo_forms/turbo_forms.dart';

/// Field identifiers for the login form.
enum LoginField { email, password }

/// Example form configuration using [TFormConfig].
class LoginFormConfig extends TFormConfig {
  final email = TFormFieldConfig<String>(
    id: LoginField.email,
    fieldType: TFieldType.textInput,
    valueValidator: (value) {
      if (value == null || value.isEmpty) return 'Email is required';
      if (!value.contains('@')) return 'Enter a valid email';
      return null;
    },
  );

  final password = TFormFieldConfig<String>(
    id: LoginField.password,
    fieldType: TFieldType.textInput,
    obscureText: true,
    valueValidator: (value) {
      if (value == null || value.isEmpty) return 'Password is required';
      if (value.length < 8) return 'Minimum 8 characters';
      return null;
    },
  );

  @override
  Map<Enum, TFormFieldConfig> get formFieldConfigs => {
    LoginField.email: email,
    LoginField.password: password,
  };
}

/// Example widget demonstrating [TFormField] usage.
class LoginFormExample extends StatefulWidget {
  const LoginFormExample({super.key});

  @override
  State<LoginFormExample> createState() => _LoginFormExampleState();
}

class _LoginFormExampleState extends State<LoginFormExample> {
  final _form = LoginFormConfig();

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TFormField<String>(
          formFieldConfig: _form.email,
          label: const Text('Email'),
          errorTextStyle: const TextStyle(color: Colors.red, fontSize: 12),
          builder: (context, config, child) {
            return TextField(
              controller: config.textEditingController,
              focusNode: config.focusNode,
              onChanged: config.updateValue,
            );
          },
        ),
        TFormField<String>(
          formFieldConfig: _form.password,
          label: const Text('Password'),
          errorTextStyle: const TextStyle(color: Colors.red, fontSize: 12),
          builder: (context, config, child) {
            return TextField(
              controller: config.textEditingController,
              focusNode: config.focusNode,
              obscureText: config.obscureText,
              onChanged: config.updateValue,
            );
          },
        ),
        ElevatedButton(
          onPressed: () {
            if (_form.isValid) {
              debugPrint('Email: ${_form.email.cValue}');
              debugPrint('Password: ${_form.password.cValue}');
            }
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}
