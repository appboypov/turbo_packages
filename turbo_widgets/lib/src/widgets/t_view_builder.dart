import 'package:flutter/widgets.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';
import 'package:turbo_widgets/src/abstracts/t_contextual_buttons_service_interface.dart';
import 'package:turbo_widgets/src/widgets/t_contextual_buttons.dart';

/// A convenience wrapper that combines [TContextualButtons] and [TViewModelBuilder]
/// for views that need contextual actions.
///
/// This widget wraps [TContextualButtons] around [TViewModelBuilder], exposing all
/// parameters from both widgets for full configurability.
///
/// Example:
/// ```dart
/// TViewBuilder<MyViewModel>(
///   viewModelBuilder: () => MyViewModel(),
///   builder: (context, viewModel, isInitialised, child) {
///     return MyViewContent(viewModel: viewModel);
///   },
/// )
/// ```
class TViewBuilder<T extends TViewModel> extends StatelessWidget {
  const TViewBuilder({
    required Widget Function(
      BuildContext context,
      T model,
      bool isInitialised,
      Widget? child,
    ) builder,
    required T Function() viewModelBuilder,
    this.service,
    this.child,
    Object? Function()? argumentBuilder,
    this.isReactive = TurboMvvmDefaults.isReactive,
    this.shouldDispose = TurboMvvmDefaults.shouldDispose,
    this.onDispose,
    super.key,
  })  : _builder = builder,
        _viewModelBuilder = viewModelBuilder,
        _argumentBuilder = argumentBuilder;

  /// Optional service instance for contextual buttons. If not provided,
  /// uses the singleton [TContextualButtonsService.instance].
  final TContextualButtonsServiceInterface? service;

  /// Child widget that will not rebuild when notifyListeners is called.
  final Widget? child;

  /// Builder method that builds the widget tree.
  final Widget Function(
    BuildContext context,
    T model,
    bool isInitialised,
    Widget? child,
  ) _builder;

  /// Builder method that provides the [TViewModel].
  final T Function() _viewModelBuilder;

  /// Builder method that provides the [TViewModel.initialise] with arguments.
  final dynamic Function()? _argumentBuilder;

  /// Whether the [TViewModel] should listen to [TViewModel.notifyListeners] for rebuilds.
  final bool isReactive;

  /// Whether the [TViewModelBuilder] should dispose the [TViewModel] when
  /// it's removed from the widget tree.
  final bool shouldDispose;

  /// Fires when [TViewModelBuilder] is removed from the widget tree.
  final void Function(T model)? onDispose;

  @override
  Widget build(BuildContext context) {
    return TContextualButtons(
      service: service,
      child: TViewModelBuilder<T>(
        child: child,
        builder: _builder,
        viewModelBuilder: _viewModelBuilder,
        argumentBuilder: _argumentBuilder,
        isReactive: isReactive,
        shouldDispose: shouldDispose,
        onDispose: onDispose,
      ),
    );
  }
}
