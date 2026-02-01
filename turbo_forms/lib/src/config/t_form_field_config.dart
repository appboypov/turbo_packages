import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_forms/src/enums/t_field_type.dart';
import 'package:turbo_forms/src/extensions/turbo_form_field_extensions.dart';
import 'package:turbo_forms/src/typedefs/values_validator_def.dart';
import 'package:turbo_notifiers/t_notifier.dart';
import 'package:turbolytics/turbolytics.dart';

part 't_form_field_extensions.dart';
part 't_form_field_state.dart';

class TFormFieldConfig<T> extends TNotifier<TFormFieldState<T>>
    with Turbolytics {
  TFormFieldConfig({
    FormFieldValidator<T>? valueValidator,
    List<T>? initialValues,
    List<T>? items,
    List<TextInputFormatter>? inputFormatters,
    List<String>? autoCompleteValues,
    T? initialValue,
    ValuesValidatorDef<T>? valuesValidator,
    bool isEnabled = true,
    bool isReadOnly = false,
    bool isVisible = true,
    bool obscureText = false,
    required TFieldType fieldType,
    required Object id,
    num incrementAmount = 1,
    String Function(T value)? labelBuilder,
    num maxValue = double.maxFinite,
    num minValue = 0,
    FocusNode? focusNode,
    ShadTextEditingController? textEditingController,
    ShadSelectController<T>? selectController,
    ShadTimePickerController? timePickerController,
    ShadSliderController? sliderController,
    List<String> currentSuggestions = const [],
  }) : super(
          TFormFieldState<T>(
            valueValidator: valueValidator,
            initialValues: initialValues,
            items: items,
            values: null,
            inputFormatters: inputFormatters,
            autoCompleteValues: autoCompleteValues,
            initialValue: initialValue,
            value: initialValue,
            valuesValidator: valuesValidator,
            isEnabled: isEnabled,
            isReadOnly: isReadOnly,
            isVisible: isVisible,
            obscureText: obscureText,
            fieldType: fieldType,
            id: id,
            incrementAmount: incrementAmount,
            maxValue: maxValue,
            minValue: minValue,
            labelBuilder: labelBuilder,
            errorText: null,
            shouldValidate: false,
            textEditingController: textEditingController ??
                ((fieldType.hasTextEditingController)
                    ? ShadTextEditingController(text: initialValue?.toString())
                    : null),
            sliderController: sliderController ??
                (fieldType.hasSliderController
                    ? ShadSliderController(
                        initialValue: initialValue?.tAsType() ?? 0)
                    : null),
            timePickerController: timePickerController ??
                (fieldType.hasTimePickerController
                    ? ShadTimePickerController(
                        hour: initialValue?.tAsType<ShadTimeOfDay>().hour ?? 0,
                        minute:
                            initialValue?.tAsType<ShadTimeOfDay>().minute ?? 0,
                        period: initialValue?.tAsType<ShadTimeOfDay>().period,
                        second:
                            initialValue?.tAsType<ShadTimeOfDay>().second ?? 0,
                      )
                    : null),
            selectController: selectController ??
                (fieldType.hasSelectController
                    ? ShadSelectController<T>(
                        initialValue: initialValues?.toSet())
                    : null),
            focusNode: focusNode ?? FocusNode(),
            currentSuggestions: currentSuggestions,
          ),
        );

  @override
  void dispose() {
    log.info('Disposing $fieldType with id: ${value.id}..');
    value.textEditingController?.dispose();
    value.selectController?.dispose();
    value.focusNode.dispose();
    super.dispose();
    log.info('Disposed $fieldType with id: ${value.id}!');
  }

  List<String> get currentSuggestions => value.currentSuggestions;

  num get minValue => value.minValue;
  num get maxValue => value.maxValue;

  bool get isNotValid => !isValid;

  bool get isValidSilent {
    final errorText = switch (fieldType) {
      TFieldType.textInput => value.valueValidator?.call(value.value),
      TFieldType.select => value.valueValidator?.call(value.value),
      TFieldType.checkbox => value.valueValidator?.call(value.value),
      TFieldType.cameraPath => value.valueValidator?.call(value.value),
      TFieldType.colorPicker => value.valueValidator?.call(value.value),
      TFieldType.datePicker => value.valueValidator?.call(value.value),
      TFieldType.dateRangePicker => value.valueValidator?.call(value.value),
      TFieldType.filePickerPath => value.valueValidator?.call(value.value),
      TFieldType.numberInput => value.valueValidator?.call(value.value),
      TFieldType.phoneInput => value.valueValidator?.call(value.value),
      TFieldType.radioCard => value.valueValidator?.call(value.value),
      TFieldType.radioGroup => value.valueValidator?.call(value.value),
      TFieldType.selectMulti => value.valuesValidator?.call(value.values),
      TFieldType.sizeSelector => value.valueValidator?.call(value.value),
      TFieldType.slider => value.valueValidator?.call(value.value),
      TFieldType.starRating => value.valueValidator?.call(value.value),
      TFieldType.textArea => value.valueValidator?.call(value.value),
      TFieldType.timePicker => value.valueValidator?.call(value.value),
      TFieldType.toggleGroup => value.valueValidator?.call(value.value),
      TFieldType.toggleSwitch => value.valueValidator?.call(value.value),
    };
    return errorText == null;
  }

  bool get isValid {
    if (!value.shouldValidate) {
      update(value.copyWith(shouldValidate: true));
    }
    final errorText = switch (fieldType) {
      TFieldType.textInput => value.valueValidator?.call(value.value),
      TFieldType.select => value.valueValidator?.call(value.value),
      TFieldType.checkbox => value.valueValidator?.call(value.value),
      TFieldType.cameraPath => value.valueValidator?.call(value.value),
      TFieldType.colorPicker => value.valueValidator?.call(value.value),
      TFieldType.datePicker => value.valueValidator?.call(value.value),
      TFieldType.dateRangePicker => value.valueValidator?.call(value.value),
      TFieldType.filePickerPath => value.valueValidator?.call(value.value),
      TFieldType.numberInput => value.valueValidator?.call(value.value),
      TFieldType.phoneInput => value.valueValidator?.call(value.value),
      TFieldType.radioCard => value.valueValidator?.call(value.value),
      TFieldType.radioGroup => value.valueValidator?.call(value.value),
      TFieldType.selectMulti => value.valuesValidator?.call(value.values),
      TFieldType.sizeSelector => value.valueValidator?.call(value.value),
      TFieldType.slider => value.valueValidator?.call(value.value),
      TFieldType.starRating => value.valueValidator?.call(value.value),
      TFieldType.textArea => value.valueValidator?.call(value.value),
      TFieldType.timePicker => value.valueValidator?.call(value.value),
      TFieldType.toggleGroup => value.valueValidator?.call(value.value),
      TFieldType.toggleSwitch => value.valueValidator?.call(value.value),
    };
    update(value.copyWith(errorText: errorText, forceUpdate: true));
    final isValid = errorText == null;
    log.info('Checking if $fieldType with id: ${value.id} is valid: $isValid!');
    return isValid;
  }

  ShadTextEditingController? get textEditingController =>
      value.textEditingController;
  ShadSelectController<T>? get selectController => value.selectController;
  ShadTimePickerController? get timePickerController =>
      value.timePickerController;
  ShadSliderController? get sliderController => value.sliderController;
  FocusNode get focusNode => value.focusNode;
  FormFieldValidator<T>? get validator => value.valueValidator;
  List<String>? get autoCompleteValues => value.autoCompleteValues;
  List<T>? get initialValues => value.initialValues;
  List<T>? get items => value.items;
  List<T>? get values => value.values;
  List<TextInputFormatter>? get inputFormatters => value.inputFormatters;
  Set<T> get valuesAsSet => values?.toSet() ?? {};
  String? get errorText => value.errorText;
  T? get cValue => value.value;
  T? get initialValue => value.initialValue;
  TFieldType get fieldType => value.fieldType;
  ValuesValidatorDef<T>? get valuesValidator => value.valuesValidator;
  bool get didChange => value.value != value.initialValue;
  bool get hasFocus => value.focusNode.hasFocus;
  bool get isEnabled => value.isEnabled;
  bool get isReadOnly => value.isReadOnly;
  bool get isVisible => value.isVisible;
  bool get obscureText => value.obscureText;
  bool get shouldValidate => value.shouldValidate;

  double? get valueAsDouble {
    final localValue = cValue;
    if (localValue is String?) {
      return localValue?.tTryAsDouble;
    }
    return null;
  }

  int? get valueAsInt {
    final localValue = cValue;
    if (localValue is String?) {
      return localValue?.tTryAsInt;
    }
    return null;
  }

  void _updateTextEditingController(String rTextValue) {
    final trimmed = rTextValue.trim();
    final tryParse = double.tryParse(trimmed);
    final isNumber = tryParse != null;
    final String pValue;
    if (isNumber) {
      final bool hasDecimals = tryParse.tHasDecimals;
      pValue = hasDecimals ? trimmed : tryParse.toInt().toString();
    } else {
      pValue = trimmed;
    }

    final textEditingController = value.textEditingController;
    final oldCursorPos = textEditingController!.selection.baseOffset;
    final oldTextLength = textEditingController.text.length;

    textEditingController.text = pValue;

    int newCursorPos = oldCursorPos;
    if (pValue.length > oldTextLength) {
      newCursorPos = pValue.length;
    } else if (pValue.length < oldTextLength) {
      newCursorPos -= 1;
    }

    newCursorPos = newCursorPos.clamp(0, pValue.length);

    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: newCursorPos),
    );
  }

  void _tryValidate() {
    if (value.shouldValidate) {
      isValid;
    }
  }

  void _resetShouldValidate() {
    update(value.copyWith(shouldValidate: false, errorText: null));
  }

  void updateValues(List<T>? newValues) {
    update(value.copyWith(values: newValues));
    _tryValidate();
    log.info('Set values to $newValues for $fieldType with id: ${value.id}!');
  }

  void updateValue(T? value) {
    update(data.copyWith(value: value));
    if (fieldType.hasTextEditingController) {
      _updateTextEditingController(value?.toString() ?? '');
    }
    _tryValidate();
    log.info('Set value to $value for $fieldType with id: ${data.id}!');
  }

  void resetSuggestions() => update(value.copyWith(currentSuggestions: []));

  void updateSuggestions(String value) {
    if (value.isEmpty || autoCompleteValues == null) {
      if (currentSuggestions.isEmpty) return;
      updateCurrent((value) => value.copyWith(currentSuggestions: []));
      return;
    }
    updateCurrent((cValue) {
      final currentSuggestions = autoCompleteValues
              ?.where((element) => element.tNaked.contains(value.tNaked))
              .toList() ??
          [];
      return cValue.copyWith(currentSuggestions: currentSuggestions);
    });
  }

  void requestFocus() {
    value.focusNode.requestFocus();
    if (fieldType.hasTextEditingController) {
      textEditingController!.selection = TextSelection(
        baseOffset: 0,
        extentOffset: textEditingController!.text.length,
      );
    }
    log.info('Requested focus for $fieldType with id: ${value.id}!');
  }

  void unfocus() => value.focusNode.unfocus();

  void silentReset() {
    _resetShouldValidate();

    if (fieldType.hasTextEditingController) {
      _updateTextEditingController(value.initialValue?.toString() ?? '');
    }
    if (fieldType.hasSelectController) {
      selectController!.value = (value.initialValues ?? []).toSet();
    }

    if (fieldType.isSingleValue) {
      update(value.copyWith(value: value.initialValue));
    } else {
      update(value.copyWith(values: value.initialValues));
    }

    log.info('Reset $fieldType with id: ${value.id}!');
  }

  void silentUpdateValue(T? newValue) {
    update(value.copyWith(value: newValue));
    _tryValidate();
  }

  void silentUpdateValues(List<T>? newValues) {
    update(value.copyWith(values: newValues));
    _tryValidate();
  }

  void updateCurrentValue(T? Function(T? value) current) {
    if (fieldType.hasTextEditingController) {
      _updateTextEditingController(current(cValue)?.toString() ?? '');
    }
    update(value.copyWith(value: current(cValue)));
  }

  void updateCurrentValues(List<T>? Function(List<T>? values) current) {
    if (fieldType.hasSelectController) {
      selectController!.value = (current(values) ?? []).toSet();
    }
    update(value.copyWith(values: current(values)));
  }

  void addValue(T newValue) => updateCurrentValues(
      (values) => values == null ? [newValue] : [...values, newValue]);

  void removeValue(T valueToRemove) => updateCurrentValues(
      (values) => values?.where((v) => v != valueToRemove).toList());

  void updateInitialValue(T? newValue) {
    update(value.copyWith(initialValue: newValue, value: newValue));
    if (fieldType.hasTextEditingController) {
      if (textEditingController!.value.text.trim().isEmpty) {
        value.textEditingController!.text = newValue?.toString() ?? '';
      }
    }
    _tryValidate();
    log.info(
        'Set initialValue to $newValue for $fieldType with id: ${value.id}!');
  }

  void updateInitialValues(List<T>? newValues) {
    update(value.copyWith(initialValues: newValues, values: newValues));
    if (fieldType.hasSelectController) {
      if (selectController!.value.isEmpty) {
        selectController!.value = (newValues ?? []).toSet();
      }
    }
    _tryValidate();
    log.info(
        'Set initialValues to $newValues for $fieldType with id: ${value.id}!');
  }

  void updateItems(List<T>? newItems) {
    update(value.copyWith(items: newItems));
    _tryValidate();
    log.info('Set items to $newItems for $fieldType with id: ${value.id}!');
  }

  void updateIsReadOnly(bool newValue) {
    update(value.copyWith(isReadOnly: newValue));
    if (newValue) {
      _tryValidate();
    } else {
      _resetShouldValidate();
    }
    log.info(
        'Set isReadOnly to $newValue for $fieldType with id: ${value.id}!');
  }

  void updateIsVisible(bool newValue) {
    update(value.copyWith(isVisible: newValue));
    if (newValue) {
      _tryValidate();
    } else {
      _resetShouldValidate();
    }
    log.info('Set isVisible to $newValue for $fieldType with id: ${value.id}!');
  }

  void updateIsEnabled(bool newValue) {
    update(value.copyWith(isEnabled: newValue));
    if (newValue) {
      _tryValidate();
    } else {
      _resetShouldValidate();
    }
    log.info('Set isEnabled to $newValue for $fieldType with id: ${value.id}!');
  }

  void updateInputFormatters(List<TextInputFormatter>? newValue) {
    update(value.copyWith(inputFormatters: newValue));
    _tryValidate();
    log.info(
        'Set inputFormatters to $newValue for $fieldType with id: ${value.id}!');
  }

  void updateObscureText(bool newValue) {
    update(value.copyWith(obscureText: newValue));
    _tryValidate();
    log.info(
        'Set obscureText to $newValue for $fieldType with id: ${value.id}!');
  }
}
