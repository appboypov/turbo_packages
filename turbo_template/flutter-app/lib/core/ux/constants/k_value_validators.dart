import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

FormFieldValidator kValueValidatorsMultiple(
  List<FormFieldValidator> validators,
) => (valueCandidate) {
  for (final validator in validators) {
    final validatorResult = validator.call(valueCandidate);
    if (validatorResult != null) {
      return validatorResult;
    }
  }
  return null;
};

FormFieldValidator<T> kValueValidatorsIsTrue<T>({
  required String Function() errorText,
}) {
  return (T? valueCandidate) {
    if (valueCandidate is bool && valueCandidate) {
      return null;
    }
    return errorText();
  };
}

FormFieldValidator<T> kValueValidatorsRequired<T>({
  required String Function() errorText,
}) {
  return (T? valueCandidate) {
    if (valueCandidate == null ||
        (valueCandidate is String && valueCandidate.trim().isEmpty) ||
        (valueCandidate is Iterable && valueCandidate.isEmpty) ||
        (valueCandidate is Map && valueCandidate.isEmpty)) {
      return errorText();
    }
    return null;
  };
}

FormFieldValidator<T> kValueValidatorsEmail<T>({
  required String Function() errorText,
}) {
  return (T? valueCandidate) {
    if (valueCandidate is! String) {
      return errorText();
    }
    if (!EmailValidator.validate(valueCandidate)) {
      return errorText();
    }
    return null;
  };
}

FormFieldValidator<T> kValueValidatorsMinLength<T>({
  required int minLength,
  required String Function() errorText,
}) {
  return (T? valueCandidate) {
    if (valueCandidate is String && valueCandidate.length < minLength) {
      return errorText();
    }
    return null;
  };
}

FormFieldValidator<T> kValueValidatorsEquals<T>({
  required T? Function() otherValue,
  required String Function() errorText,
}) {
  return (T? valueCandidate) {
    if (valueCandidate != otherValue()) {
      return errorText();
    }
    return null;
  };
}
