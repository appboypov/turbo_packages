/// Utilities for converting between different case formats.
class CaseConverter {
  /// Converts snake_case to camelCase.
  ///
  /// Example: `my_awesome_app` → `myAwesomeApp`
  static String snakeToCamel(String input) {
    if (input.isEmpty) return input;

    final parts = input.split('_');
    if (parts.length == 1) return input;

    final buffer = StringBuffer(parts.first);
    for (var i = 1; i < parts.length; i++) {
      final part = parts[i];
      if (part.isNotEmpty) {
        buffer.write(part[0].toUpperCase());
        buffer.write(part.substring(1));
      }
    }
    return buffer.toString();
  }

  /// Converts snake_case to Title Case.
  ///
  /// Example: `my_awesome_app` → `My Awesome App`
  static String snakeToTitle(String input) {
    if (input.isEmpty) return input;

    final parts = input.split('_');
    final titled = parts.map((part) {
      if (part.isEmpty) return part;
      return part[0].toUpperCase() + part.substring(1);
    });
    return titled.join(' ');
  }

  /// Converts camelCase to snake_case.
  ///
  /// Example: `myAwesomeApp` → `my_awesome_app`
  static String camelToSnake(String input) {
    if (input.isEmpty) return input;

    final buffer = StringBuffer();
    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      if (char.toUpperCase() == char && char.toLowerCase() != char) {
        if (i > 0) buffer.write('_');
        buffer.write(char.toLowerCase());
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  /// Converts Title Case to snake_case.
  ///
  /// Example: `My Awesome App` → `my_awesome_app`
  static String titleToSnake(String input) {
    if (input.isEmpty) return input;

    final parts = input.split(' ');
    return parts.map((part) => part.toLowerCase()).join('_');
  }

  /// Validates that input is valid snake_case.
  ///
  /// Returns true if input matches pattern: lowercase letters and underscores,
  /// no leading/trailing underscores, no consecutive underscores.
  static bool isValidSnakeCase(String input) {
    if (input.isEmpty) return false;
    if (input.startsWith('_') || input.endsWith('_')) return false;
    if (input.contains('__')) return false;

    final validChars = RegExp(r'^[a-z][a-z0-9_]*$');
    return validChars.hasMatch(input);
  }

  /// Validates that input is valid reverse domain notation.
  ///
  /// Example: `app.apewpew`, `io.mycompany`
  static bool isValidReverseDomain(String input) {
    if (input.isEmpty) return false;

    final parts = input.split('.');
    if (parts.length < 2) return false;

    final validPart = RegExp(r'^[a-z][a-z0-9]*$');
    return parts.every((part) => validPart.hasMatch(part));
  }
}
