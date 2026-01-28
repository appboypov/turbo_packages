import 'package:flutter/widgets.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';
import 'package:turbo_widgets/src/typedefs/t_view_model_builder_def.dart';
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
class TViewBuilder<T extends TBaseViewModel> extends StatelessWidget {
  const TViewBuilder({
    required this.builder,
    required this.viewModelBuilder,
    this.contextualButtonsBuilder,
    this.argumentBuilder,
    this.child,
    this.isReactive = TurboMvvmDefaults.isReactive,
    this.onDispose,
    this.shouldDispose = TurboMvvmDefaults.shouldDispose,
    super.key,
  });

  /// Optional builder for contextual buttons. If provided, builds buttons
  /// using the view model and sends them to the shell-level contextual buttons.
  final TViewModelBuilderDef<T>? contextualButtonsBuilder;

  /// Child widget that will not rebuild when notifyListeners is called.
  final Widget? child;

  /// Builder method that builds the widget tree.
  final TViewModelBuilderDef<T> builder;

  /// Builder method that provides the [TViewModel].
  final T Function() viewModelBuilder;

  /// Builder method that provides the [TViewModel.initialise] with arguments.
  final dynamic Function()? argumentBuilder;

  /// Whether the [TViewModel] should listen to [TViewModel.notifyListeners] for rebuilds.
  final bool isReactive;

  /// Whether the [TViewModelBuilder] should dispose the [TViewModel] when
  /// it's removed from the widget tree.
  final bool shouldDispose;

  /// Fires when [TViewModelBuilder] is removed from the widget tree.
  final void Function(T model)? onDispose;

  @override
  Widget build(BuildContext context) => TContextualButtons(
        child: TViewModelBuilder<T>(
          child: child,
          builder: builder,
          viewModelBuilder: viewModelBuilder,
          argumentBuilder: argumentBuilder,
          isReactive: isReactive,
          shouldDispose: shouldDispose,
          onDispose: onDispose,
        ),
      );
}
