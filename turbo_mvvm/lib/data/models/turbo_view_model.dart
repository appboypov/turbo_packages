import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part '../../widgets/turbo_view_model_builder.dart';

/// Base view model class.
abstract class TurboViewModel<A> extends ChangeNotifier {
  /// Holds arguments of type [A] provided by the [TurboViewModelBuilder._argumentBuilder].
  late final A arguments;

  /// Callback that is used by [isMounted] to check whether the parent [TurboViewModelBuilder] is mounted.
  late bool Function()? _mounted;

  /// Whether the parent [TurboViewModelBuilder] is mounted.
  bool get isMounted => _mounted?.call() ?? false;

  /// Provides non-leaking access to the [context].
  late DisposableBuildContext? disposableBuildContext;

  /// Sets whether the [TurboViewModel] has been initialised.
  void setInitialised(bool value) => _isInitialised.value = value;

  /// Underlying notifier that sets whether the [TurboViewModel] has been initialised.
  final ValueNotifier<bool> _isInitialised = ValueNotifier(false);

  /// Listenable that listens to whether the [TurboViewModel] has been initialised.
  ValueListenable<bool> get isInitialised => _isInitialised;

  /// Used to perform any initialising logic for the [TurboViewModel].
  @mustCallSuper
  initialise() {
    _isInitialised.value = true;
  }

  /// Used to perform any disposing logic for the [TurboViewModel].
  ///
  /// This method is called in the [TurboViewModelBuilderState.initState] method.
  @override
  void dispose() {
    disposableBuildContext!.dispose();
    disposableBuildContext = null;
    _mounted = null;
    super.dispose();
  }

  /// Used to rebuild the widgets inside the parent [TurboViewModelBuilder].
  void rebuild() => notifyListeners();

  /// Provides the current [TurboViewModelBuilderState]'s [BuildContext].
  BuildContext? get context => disposableBuildContext?.context;
}
