import 'debouncer.dart';

class BlockingDebouncer {
  BlockingDebouncer({required Duration duration}) : _debouncer = Debouncer(duration: duration);

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\
  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  void dispose() => _debouncer.tryCancel();

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  bool _canContinue = true;

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\

  final Debouncer _debouncer;

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  bool get canContinue => _canContinue;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void onChanged() {
    _canContinue = false;
    _debouncer.run(() {
      _canContinue = true;
    });
  }
}
