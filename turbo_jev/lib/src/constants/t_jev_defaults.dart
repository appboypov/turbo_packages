import '../models/t_jev_model.dart';

/// Config values [TJev] uses when neither config nor environment sets them.
abstract final class TJevDefaults {
  /// The base URL of TypeSafe.
  static const baseUrl = 'https://api.typesafe.ai';

  /// The model a Request uses when it names none.
  static const model = TJevModel.jevLatest;
}
