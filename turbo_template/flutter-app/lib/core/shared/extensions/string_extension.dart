import 'package:turbo_flutter_template/core/shared/constants/t_keys.dart';
import 'package:turbo_flutter_template/core/shared/constants/t_values.dart';
import 'package:turbo_flutter_template/core/ui/enums/emoji.dart';
import 'package:turbo_flutter_template/core/ux/enums/t_supported_language.dart';

extension StringExtension on String {
  String get withPeriod {
    if (isEmpty) return '';
    return endsWith('.') ? this : '${trim()}.';
  }

  String withTrailingColon(String trailing) {
    if (isEmpty) return trailing;
    final trimmed = trim();
    return trimmed.endsWith(':') ? '$trimmed $trailing' : '$trimmed: $trailing';
  }

  String withLeadingEmoji(Emoji? emoji) =>
      emoji == null ? this : withLeading(emoji.toString() + ' ');

  String withLeading(String leading) {
    if (isEmpty) return leading;
    final trimmed = trim();
    return trimmed.startsWith(leading) ? trimmed : '$leading $trimmed';
  }

  String get withAtSign {
    if (isEmpty) return '';
    final trimmed = trim();
    return trimmed.startsWith('@') ? trimmed : '@$trimmed';
  }

  String withLanguageCode({required TSupportedLanguage language}) =>
      replaceAll(TKeys.languageCode, language.languageCode);

  String get indent => '  $this';

  String get asPhoneNumber => 'tel:$this';
  String get asEmail => 'mailto:$this';

  String withId(String id) => replaceAll(TKeys.id, id);

  String capitalize({bool forceLowercase = false}) {
    if (isEmpty) {
      return '';
    }
    return forceLowercase
        ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
        : '${this[0].toUpperCase()}${substring(1)}';
  }

  String? get nullIfEmpty => trimIsEmpty ? null : this;
  String get asRootPath => '/$this';
  double? get tryAsDouble => double.tryParse(this);
  int? get tryAsInt => int.tryParse(this);
  bool get trimIsEmpty => trim().isEmpty;
  String get naked => replaceAll(' ', '').toLowerCase().trim();
  bool containsAny(List<String> values) => values.any(contains);

  String get capitalized => '${this[0].toUpperCase()}${substring(1)}';
  bool get isValidUsername {
    // Strip leading @ before validation
    final cleanedUsername = startsWith('@') ? substring(1) : this;
    if (cleanedUsername.length < TValues.minUsernameLength ||
        cleanedUsername.length > TValues.maxNameLength)
      return false;
    return _validUsernameRegExp.hasMatch(cleanedUsername);
  }

  /// Parsed NLP sentence ready for processing
  ///
  /// This method:
  /// - Converts to lowercase
  /// - Trims leading/trailing whitespace
  /// - Replaces multiple spaces with single space
  /// - Preserves dots and punctuation
  ///
  /// Example:
  /// ```dart
  /// 'Hello   World...   Test'.lowerCaseMaxOneSpace // 'hello world... test'
  /// ```
  String get normalized => replaceAll(RegExp(r'\s+'), ' ').trim();

  static final RegExp _validUsernameRegExp = RegExp(
    r'^[a-zA-Z\d](?:[a-zA-Z\d_-]{1,28}[a-zA-Z\d])?$',
  );

  bool isNewerThan(String? otherVersion) {
    if (otherVersion == null) return true;
    final thisParts = split('.').map(int.parse).toList();
    final otherParts = otherVersion.split('.').map(int.parse).toList();
    for (int i = 0; i < 3; i++) {
      if (thisParts[i] > otherParts[i]) return true;
      if (thisParts[i] < otherParts[i]) return false;
    }
    return false;
  }
}

extension ListStringExtension on List<String> {
  String get asId => where((e) => e.isNotEmpty).join('-').toLowerCase();
}
