/// Template-specific duration constants not provided by [turbo_widgets.TDurations].
class TemplateDurations {
  TemplateDurations._();

  static const throttle = Duration(milliseconds: 100);
  static const toast = Duration(milliseconds: 1200);
  static const toastDefault = Duration(seconds: 3);
  static const toastLong = Duration(seconds: 4);
  static const hover = Duration(milliseconds: 100);
  static const sheetAnimation = Duration(milliseconds: 300);
  static const sheetAnimationX0p5 = Duration(milliseconds: 150);
  static const timeOut = Duration(seconds: 10);
  static const timeOutX2 = Duration(seconds: 20);
  static const second = Duration(seconds: 1);
}
