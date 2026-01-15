import 'package:flutter/material.dart';
import 'package:turbo_notifiers/turbo_notifiers.dart';
import 'package:turbolytics/turbolytics.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/ux/manage-input/enums/t_field_type.dart';

class TFormFieldState<T> {
  const TFormFieldState({
    required this.fieldType,
    required this.id,
    this.value,
    this.initialValue,
    this.valueValidator,
    this.isEnabled = true,
    this.isVisible = true,
    this.obscureText = false,
    this.shouldValidate = false,
    this.errorText,
    this.textEditingController,
    this.focusNode,
  });

  final TFieldType fieldType;
  final Object id;
  final T? value;
  final T? initialValue;
  final FormFieldValidator<T>? valueValidator;
  final bool isEnabled;
  final bool isVisible;
  final bool obscureText;
  final bool shouldValidate;
  final String? errorText;
  final ShadTextEditingController? textEditingController;
  final FocusNode? focusNode;

  TFormFieldState<T> copyWith({
    TFieldType? fieldType,
    Object? id,
    T? value,
    T? initialValue,
    FormFieldValidator<T>? valueValidator,
    bool? isEnabled,
    bool? isVisible,
    bool? obscureText,
    bool? shouldValidate,
    String? errorText,
    ShadTextEditingController? textEditingController,
    FocusNode? focusNode,
    bool forceUpdate = false,
  }) {
    return TFormFieldState<T>(
      fieldType: fieldType ?? this.fieldType,
      id: id ?? this.id,
      value: value ?? this.value,
      initialValue: initialValue ?? this.initialValue,
      valueValidator: valueValidator ?? this.valueValidator,
      isEnabled: isEnabled ?? this.isEnabled,
      isVisible: isVisible ?? this.isVisible,
      obscureText: obscureText ?? this.obscureText,
      shouldValidate: shouldValidate ?? this.shouldValidate,
      errorText: errorText ?? this.errorText,
      textEditingController: textEditingController ?? this.textEditingController,
      focusNode: focusNode ?? this.focusNode,
    );
  }
}

class TFormFieldConfig<T> extends TurboNotifier<TFormFieldState<T>> with Turbolytics {
  TFormFieldConfig({
    FormFieldValidator<T>? valueValidator,
    T? initialValue,
    bool isEnabled = true,
    bool isVisible = true,
    bool obscureText = false,
    required TFieldType fieldType,
    required Object id,
    FocusNode? focusNode,
    ShadTextEditingController? textEditingController,
  }) : super(
          TFormFieldState<T>(
            valueValidator: valueValidator,
            initialValue: initialValue,
            value: initialValue,
            isEnabled: isEnabled,
            isVisible: isVisible,
            obscureText: obscureText,
            fieldType: fieldType,
            id: id,
            textEditingController: textEditingController ??
                (fieldType == TFieldType.textInput
                    ? ShadTextEditingController(text: initialValue?.toString())
                    : null),
            focusNode: focusNode ?? FocusNode(),
          ),
        );

  @override
  void dispose() {
    log.info('Disposing $fieldType with id: ${value.id}..');
    value.textEditingController?.dispose();
    value.focusNode?.dispose();
    super.dispose();
    log.info('Disposed $fieldType with id: ${value.id}!');
  }

  bool get isNotValid => !isValid;

  bool get isValid {
    if (!value.shouldValidate) {
      update(value.copyWith(shouldValidate: true));
    }
    final errorText = value.valueValidator?.call(value.value);
    update(value.copyWith(errorText: errorText, forceUpdate: true));
    final isValid = errorText == null;
    log.info('Checking if $fieldType with id: ${value.id} is valid: $isValid!');
    return isValid;
  }

  ShadTextEditingController? get textEditingController => value.textEditingController;
  FocusNode get focusNode => value.focusNode ?? FocusNode();
  FormFieldValidator<T>? get validator => value.valueValidator;
  String? get errorText => value.errorText;
  T? get cValue => value.value;
  T? get initialValue => value.initialValue;
  TFieldType get fieldType => value.fieldType;
  bool get didChange => value.value != value.initialValue;
  bool get hasFocus => value.focusNode?.hasFocus ?? false;
  bool get isEnabled => value.isEnabled;
  bool get isVisible => value.isVisible;
  bool get obscureText => value.obscureText;
  bool get shouldValidate => value.shouldValidate;

  String? get valueTrimIsEmpty {
    final val = cValue;
    if (val is String?) {
      return val?.trim().isEmpty == true ? val : null;
    }
    return null;
  }

  void updateValue(T? newValue) {
    update(value.copyWith(value: newValue));
    if (fieldType == TFieldType.textInput && newValue != null) {
      textEditingController?.text = newValue.toString();
    }
    _tryValidate();
    log.info('Set value to $newValue for $fieldType with id: ${value.id}!');
  }

  void silentUpdateValue(T? newValue) {
    update(value.copyWith(value: newValue));
    if (fieldType == TFieldType.textInput && newValue != null) {
      final newText = newValue.toString();
      // Only update controller if text differs to avoid interfering with user input
      if (textEditingController?.text != newText) {
        textEditingController?.text = newText;
      }
    }
    _tryValidate();
  }

  void requestFocus() {
    value.focusNode?.requestFocus();
    if (fieldType == TFieldType.textInput && textEditingController != null) {
      textEditingController!.selection = TextSelection(
        baseOffset: 0,
        extentOffset: textEditingController!.text.length,
      );
    }
    log.info('Requested focus for $fieldType with id: ${value.id}!');
  }

  void unfocus() => value.focusNode?.unfocus();

  void _tryValidate() {
    if (value.shouldValidate) {
      isValid;
    }
  }
}

