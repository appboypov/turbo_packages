part of 't_form_field_config.dart';

class TFormFieldState<T> extends Equatable {
  final FormFieldValidator<T>? valueValidator;
  final List<T>? initialValues;
  final List<T>? items;
  final List<T>? values;
  final List<TextInputFormatter>? inputFormatters;
  final List<String>? autoCompleteValues;
  final T? initialValue;
  final T? value;
  final ValuesValidatorDef<T>? valuesValidator;
  final bool isEnabled;
  final bool isReadOnly;
  final bool isVisible;
  final bool obscureText;
  final TFieldType fieldType;
  final Object id;
  final num incrementAmount;
  final num maxValue;
  final num minValue;
  final String Function(T value)? labelBuilder;
  final String? errorText;
  final bool shouldValidate;
  final ShadTextEditingController? textEditingController;
  final ShadSelectController<T>? selectController;
  final ShadTimePickerController? timePickerController;
  final ShadSliderController? sliderController;
  final FocusNode focusNode;
  final List<String> currentSuggestions;

  const TFormFieldState({
    required this.valueValidator,
    required this.initialValues,
    required this.currentSuggestions,
    required this.items,
    required this.values,
    required this.inputFormatters,
    required this.autoCompleteValues,
    required this.initialValue,
    required this.value,
    required this.valuesValidator,
    required this.isEnabled,
    required this.isReadOnly,
    required this.isVisible,
    required this.obscureText,
    required this.fieldType,
    required this.id,
    required this.incrementAmount,
    required this.maxValue,
    required this.minValue,
    required this.labelBuilder,
    required this.errorText,
    required this.shouldValidate,
    required this.timePickerController,
    required this.sliderController,
    required this.textEditingController,
    required this.selectController,
    required this.focusNode,
  });

  TFormFieldState<T> copyWith({
    FormFieldValidator<T>? valueValidator,
    List<T>? initialValues,
    List<T>? items,
    List<T>? values,
    List<TextInputFormatter>? inputFormatters,
    List<String>? autoCompleteValues,
    T? initialValue,
    T? value,
    ValuesValidatorDef<T>? valuesValidator,
    bool? isEnabled,
    bool? isReadOnly,
    bool? isVisible,
    bool? obscureText,
    TFieldType? fieldType,
    Object? id,
    num? incrementAmount,
    num? maxValue,
    num? minValue,
    String Function(T value)? labelBuilder,
    String? errorText,
    bool? shouldValidate,
    ShadTextEditingController? textEditingController,
    ShadSelectController<T>? selectController,
    ShadTimePickerController? timePickerController,
    ShadSliderController? sliderController,
    FocusNode? focusNode,
    List<String>? currentSuggestions,
    bool forceUpdate = false,
  }) => TFormFieldState<T>(
    currentSuggestions: currentSuggestions ?? this.currentSuggestions,
    valueValidator: valueValidator ?? this.valueValidator,
    initialValues: initialValues ?? this.initialValues,
    items: items ?? this.items,
    values: values ?? this.values,
    inputFormatters: inputFormatters ?? this.inputFormatters,
    autoCompleteValues: autoCompleteValues ?? this.autoCompleteValues,
    initialValue: initialValue ?? this.initialValue,
    value: value ?? this.value,
    valuesValidator: valuesValidator ?? this.valuesValidator,
    isEnabled: isEnabled ?? this.isEnabled,
    isReadOnly: isReadOnly ?? this.isReadOnly,
    isVisible: isVisible ?? this.isVisible,
    obscureText: obscureText ?? this.obscureText,
    fieldType: fieldType ?? this.fieldType,
    id: id ?? this.id,
    incrementAmount: incrementAmount ?? this.incrementAmount,
    maxValue: maxValue ?? this.maxValue,
    minValue: minValue ?? this.minValue,
    labelBuilder: labelBuilder ?? this.labelBuilder,
    errorText: forceUpdate ? errorText : errorText ?? this.errorText,
    shouldValidate: shouldValidate ?? this.shouldValidate,
    textEditingController: textEditingController ?? this.textEditingController,
    selectController: selectController ?? this.selectController,
    focusNode: focusNode ?? this.focusNode,
    timePickerController: timePickerController ?? this.timePickerController,
    sliderController: sliderController ?? this.sliderController,
  );

  @override
  List<Object?> get props => [
    initialValues,
    items,
    values,
    autoCompleteValues,
    initialValue,
    value,
    isEnabled,
    isReadOnly,
    isVisible,
    obscureText,
    fieldType,
    id,
    incrementAmount,
    maxValue,
    minValue,
    labelBuilder,
    errorText,
    shouldValidate,
    textEditingController,
    selectController,
    currentSuggestions,
  ];
}
