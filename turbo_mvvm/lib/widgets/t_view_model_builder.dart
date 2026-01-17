part of '../data/models/t_view_model.dart';

/// Used to build and provide a [TViewModel] to the widget tree.
class TViewModelBuilder<T extends TViewModel> extends StatefulWidget {
  const TViewModelBuilder({
    this.child,
    required Widget Function(
      BuildContext context,
      T model,
      bool isInitialised,
      Widget? child,
    ) builder,
    required T Function() viewModelBuilder,
    Object? Function()? argumentBuilder,
    this.isReactive = true,
    this.shouldDispose = true,
    this.onDispose,
    Key? key,
  })  : _builder = builder,
        _viewModelBuilder = viewModelBuilder,
        _argumentBuilder = argumentBuilder,
        super(key: key);

  /// Child widget that will not rebuild when notifyListeners is called.
  final Widget? child;

  /// Builder method that builds the widget tree.
  final Widget Function(
          BuildContext context, T model, bool isInitialised, Widget? child,)
      _builder;

  /// Builder method that provides the [TViewModel].
  final T Function() _viewModelBuilder;

  /// Builder method that provides the [TViewModel.initialise] with arguments.
  final dynamic Function()? _argumentBuilder;

  /// Whether the [TViewModel] should listen to [TViewModel.notifyListeners] for rebuilds.
  final bool isReactive;

  /// Whether the [ChangeNotifierProvider] should dispose the [TViewModel] when it's removed from the widget tree.
  final bool shouldDispose;

  /// Fires when [TViewModelBuilder] is removed from the widget tree.
  final void Function(T model)? onDispose;

  @override
  TViewModelBuilderState<T> createState() =>
      TViewModelBuilderState<T>();
}

class TViewModelBuilderState<T extends TViewModel>
    extends State<TViewModelBuilder<T>> {
  /// The current [TViewModel].
  late final T _viewModel;

  /// Initialises the [TViewModel] and its needed methods.
  @override
  void initState() {
    _viewModel = widget._viewModelBuilder()
      ..disposableBuildContext = DisposableBuildContext(this)
      .._mounted = (() => mounted)
      ..arguments = widget._argumentBuilder?.call();
    _viewModel.initialise();
    super.initState();
  }

  /// Disposes the [TViewModel] and its given methods.
  @override
  void dispose() {
    widget.onDispose?.call(_viewModel);
    if (widget.shouldDispose) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: _viewModel.isInitialised,
        child: widget.child,
        builder: (context, isInitialised, child) {
          if (widget.isReactive) {
            return ChangeNotifierProvider<T>.value(
              value: _viewModel,
              child: Consumer<T>(
                child: child,
                builder: (context, value, child) {
                  return widget._builder(
                    context,
                    value,
                    isInitialised,
                    child,
                  );
                },
              ),
            );
          }
          return ChangeNotifierProvider<T>.value(
            value: _viewModel,
            child: child,
            builder: (context, child) => widget._builder(
              context,
              _viewModel,
              isInitialised,
              child,
            ),
          );
        },
      );
}
