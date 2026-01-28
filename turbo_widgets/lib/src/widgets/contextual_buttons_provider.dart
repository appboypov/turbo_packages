import 'package:flutter/widgets.dart';
import 'package:turbo_widgets/src/responsive/enums/t_device_type.dart';
import 'package:turbo_widgets/src/typedefs/t_view_model_builder_def.dart';

class ContextualButtonsProvider<ROUTE extends Enum> extends InheritedWidget {
  const ContextualButtonsProvider({
    super.key,
    required this.contextualButtonBuilders,
    required super.child,
  });

  final Map<ROUTE, TViewButtonsConfig> contextualButtonBuilders;

  static ContextualButtonsProvider<R>? maybeOf<R extends Enum>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ContextualButtonsProvider<R>>();
  }

  static ContextualButtonsProvider<R> of<R extends Enum>(BuildContext context) {
    final provider = maybeOf<R>(context);
    assert(provider != null, 'No ContextualButtonsProvider<$R> found in context');
    return provider!;
  }

  @override
  bool updateShouldNotify(covariant ContextualButtonsProvider<ROUTE> oldWidget) =>
      contextualButtonBuilders != oldWidget.contextualButtonBuilders;
}

class TViewButtonsConfig<T> {
  const TViewButtonsConfig({
    this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget Function(BuildContext context, T model)? mobile;
  final Widget Function(BuildContext context, T model)? tablet;
  final Widget Function(BuildContext context, T model)? desktop;

  /// Returns the builder for the given device type, with tablet falling back to desktop.
  Widget Function(BuildContext context, T model)? builderFor(TDeviceType deviceType) {
    switch (deviceType) {
      case TDeviceType.mobile:
        return mobile;
      case TDeviceType.tablet:
        return tablet ?? desktop;
      case TDeviceType.desktop:
        return desktop;
    }
  }
}
