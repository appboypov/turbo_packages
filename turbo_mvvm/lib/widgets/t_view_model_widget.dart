import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// A generic widget for view model-driven architecture.
abstract class TViewModelWidget<T> extends Widget {
  /// Constructs the ViewModelWidget.
  ///
  /// [isReactive] determines if the widget rebuilds when the view model changes.
  const TViewModelWidget({Key? key, this.isReactive = true}) : super(key: key);

  /// Determines whether the widget should rebuild when changes occur in [T].
  final bool isReactive;

  /// Builds the UI from the given [model].
  @protected
  Widget build(BuildContext context, T model);

  /// Creates a new [DataProviderElement].
  @override
  DataProviderElement<T> createElement() => DataProviderElement<T>(this);
}

/// An element that uses a [TViewModelWidget].
class DataProviderElement<T> extends ComponentElement {
  /// Constructs the DataProviderElement.
  DataProviderElement(TViewModelWidget widget) : super(widget);

  /// Returns the underlying [TViewModelWidget].
  @override
  TViewModelWidget get widget => super.widget as TViewModelWidget<dynamic>;

  /// Builds the widget.
  ///
  /// Listens to [Provider] for changes if [TViewModelWidget.isReactive] is `true`.
  @override
  Widget build() =>
      widget.build(this, Provider.of<T>(this, listen: widget.isReactive));

  /// Updates the widget.
  ///
  /// Rebuilds when a new [TViewModelWidget] is provided.
  @override
  void update(TViewModelWidget newWidget) {
    super.update(newWidget);
    rebuild(force: true);
  }
}
