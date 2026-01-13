import 'dart:ui';

enum TSupportedLanguage {
  nl,
  en;

  static const defaultValue = TSupportedLanguage.en;

  static TSupportedLanguage fromDeviceLocale() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    final languageCode = deviceLocale.languageCode;

    switch (languageCode) {
      case 'nl':
        return TSupportedLanguage.nl;
      case 'en':
        return TSupportedLanguage.en;
      default:
        return TSupportedLanguage.defaultValue;
    }
  }

  String get languageCode {
    switch (this) {
      case TSupportedLanguage.en:
        return 'en';
      case TSupportedLanguage.nl:
        return 'nl';
    }
  }

  Locale get toLocale => Locale(languageCode);
}

extension SupportedLanguagesExtension on String? {
  TSupportedLanguage get toSupportedLanguage => TSupportedLanguage.values.firstWhere(
    (element) => element.name == this?.trim().toLowerCase(),
    orElse: () => TSupportedLanguage.defaultValue,
  );
}

