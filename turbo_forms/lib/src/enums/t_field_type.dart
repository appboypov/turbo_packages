enum TFieldType {
  cameraPath,
  checkbox,
  colorPicker,
  datePicker,
  dateRangePicker,
  filePickerPath,
  numberInput,
  phoneInput,
  radioCard,
  radioGroup,
  select,
  selectMulti,
  sizeSelector,
  slider,
  starRating,
  textArea,
  textInput,
  timePicker,
  toggleGroup,
  toggleSwitch
  ;

  bool get hasTimePickerController {
    switch (this) {
      case TFieldType.cameraPath:
      case TFieldType.checkbox:
      case TFieldType.colorPicker:
      case TFieldType.datePicker:
      case TFieldType.dateRangePicker:
      case TFieldType.filePickerPath:
      case TFieldType.numberInput:
      case TFieldType.phoneInput:
      case TFieldType.radioCard:
      case TFieldType.radioGroup:
      case TFieldType.select:
      case TFieldType.selectMulti:
      case TFieldType.sizeSelector:
      case TFieldType.slider:
      case TFieldType.starRating:
      case TFieldType.textArea:
      case TFieldType.textInput:
        return false;
      case TFieldType.timePicker:
        return true;
      case TFieldType.toggleGroup:
      case TFieldType.toggleSwitch:
        return false;
    }
  }

  bool get hasSliderController {
    switch (this) {
      case TFieldType.cameraPath:
      case TFieldType.checkbox:
      case TFieldType.colorPicker:
      case TFieldType.datePicker:
      case TFieldType.dateRangePicker:
      case TFieldType.filePickerPath:
      case TFieldType.numberInput:
      case TFieldType.phoneInput:
      case TFieldType.radioCard:
      case TFieldType.radioGroup:
      case TFieldType.select:
      case TFieldType.selectMulti:
      case TFieldType.sizeSelector:
        return false;
      case TFieldType.slider:
        return true;
      case TFieldType.starRating:
      case TFieldType.textArea:
      case TFieldType.textInput:
      case TFieldType.timePicker:
      case TFieldType.toggleGroup:
      case TFieldType.toggleSwitch:
        return false;
    }
  }

  bool get isSingleValue {
    switch (this) {
      case TFieldType.cameraPath:
      case TFieldType.checkbox:
      case TFieldType.colorPicker:
      case TFieldType.datePicker:
      case TFieldType.dateRangePicker:
      case TFieldType.filePickerPath:
      case TFieldType.numberInput:
      case TFieldType.phoneInput:
        return true;
      case TFieldType.radioCard:
      case TFieldType.radioGroup:
      case TFieldType.select:
      case TFieldType.selectMulti:
        return false;
      case TFieldType.sizeSelector:
      case TFieldType.slider:
      case TFieldType.starRating:
      case TFieldType.textArea:
      case TFieldType.textInput:
      case TFieldType.timePicker:
      case TFieldType.toggleGroup:
      case TFieldType.toggleSwitch:
        return true;
    }
  }

  bool get hasSelectController {
    switch (this) {
      case TFieldType.cameraPath:
      case TFieldType.checkbox:
      case TFieldType.colorPicker:
      case TFieldType.datePicker:
      case TFieldType.dateRangePicker:
      case TFieldType.filePickerPath:
      case TFieldType.numberInput:
      case TFieldType.phoneInput:
        return false;
      case TFieldType.radioCard:
      case TFieldType.radioGroup:
      case TFieldType.select:
      case TFieldType.selectMulti:
        return true;
      case TFieldType.sizeSelector:
      case TFieldType.slider:
      case TFieldType.starRating:
      case TFieldType.textArea:
      case TFieldType.textInput:
      case TFieldType.timePicker:
      case TFieldType.toggleGroup:
      case TFieldType.toggleSwitch:
        return false;
    }
  }

  bool get hasTextEditingController {
    switch (this) {
      case TFieldType.cameraPath:
      case TFieldType.checkbox:
      case TFieldType.colorPicker:
      case TFieldType.datePicker:
      case TFieldType.dateRangePicker:
      case TFieldType.filePickerPath:
        return false;
      case TFieldType.numberInput:
      case TFieldType.phoneInput:
        return true;
      case TFieldType.radioCard:
      case TFieldType.radioGroup:
      case TFieldType.select:
      case TFieldType.selectMulti:
      case TFieldType.sizeSelector:
      case TFieldType.slider:
      case TFieldType.starRating:
        return false;
      case TFieldType.textArea:
      case TFieldType.textInput:
        return true;
      case TFieldType.timePicker:
      case TFieldType.toggleGroup:
      case TFieldType.toggleSwitch:
        return false;
    }
  }

  bool get isCameraPath => this == TFieldType.cameraPath;
  bool get isCheckbox => this == TFieldType.checkbox;
  bool get isColorPicker => this == TFieldType.colorPicker;
  bool get isDatePicker => this == TFieldType.datePicker;
  bool get isDateRangePicker => this == TFieldType.dateRangePicker;
  bool get isFilePickerPath => this == TFieldType.filePickerPath;
  bool get isNumberInput => this == TFieldType.numberInput;
  bool get isPhoneInput => this == TFieldType.phoneInput;
  bool get isRadioCard => this == TFieldType.radioCard;
  bool get isRadioGroup => this == TFieldType.radioGroup;
  bool get isSelect => this == TFieldType.select;
  bool get isSelectMulti => this == TFieldType.selectMulti;
  bool get isSizeSelector => this == TFieldType.sizeSelector;
  bool get isSlider => this == TFieldType.slider;
  bool get isStarRating => this == TFieldType.starRating;
  bool get isTextArea => this == TFieldType.textArea;
  bool get isTextInput => this == TFieldType.textInput;
  bool get isTimePicker => this == TFieldType.timePicker;
  bool get isToggleGroup => this == TFieldType.toggleGroup;
  bool get isToggleSwitch => this == TFieldType.toggleSwitch;
}
