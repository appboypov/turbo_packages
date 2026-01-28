import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum AuthStep {
  createUserDoc,
  acceptPrivacy,
  createSettingsDoc,
  createHousehold,
  createUsernameDoc,
  createProfileDoc,
  verifyEmail;

  static const first = createUserDoc;

  AuthStep? get next {
    final index = AuthStep.values.indexOf(this);
    if (index == AuthStep.values.length - 1) return null;
    return AuthStep.values[index + 1];
  }
}
