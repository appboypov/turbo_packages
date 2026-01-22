import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_route.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/base_router_service.dart';
import 'package:turbo_flutter_template/core/state/manage-state/models/contextual_button_entry.dart';
import 'package:turbo_flutter_template/core/ui/widgets/buttons/contextual_nav_button.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

class ContextualButtonsService extends TContextualButtonsService {
  ContextualButtonsService() {
    _baseRouterService.addRouteListener(_handleRouteChanged);
  }

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static ContextualButtonsService get locate => GetIt.I.get();
  static ContextualButtonsService Function() get lazyLocate =>
      () => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(
    () => ContextualButtonsService(),
  );

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  final BaseRouterService _baseRouterService = BaseRouterService.locate;

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    _baseRouterService.removeRouteListener(_handleRouteChanged);
    super.dispose();
  }

  // 👂 LISTENERS ----------------------------------------------------------------------------- \\

  void _handleRouteChanged(String location) {
    _applyRouteButtons(location);
  }

  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\

  final Map<String, ContextualButtonsBuilder> _routeButtonBuilders = {};
  final Map<Object, String> _ownerRouteKeys = {};
  final Map<Object, ContextualButtonsBuilder> _shellButtonBuilders = {};
  Map<TContextualPosition, TContextualPosition> _positionOverrides = const {};
  TDeviceType? _deviceType;

  TContextualButtonsConfig? _pendingConfig;
  bool _isAnimating = false;

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\

  void setPresentation({
    required TDeviceType deviceType,
    Map<TContextualPosition, TContextualPosition> positionOverrides = const {},
  }) {
    final overridesChanged = !_mapEquals(_positionOverrides, positionOverrides);
    final deviceChanged = _deviceType != deviceType;

    if (!overridesChanged && !deviceChanged) {
      return;
    }

    _deviceType = deviceType;
    _positionOverrides = positionOverrides;
    _applyRouteButtons(_baseRouterService.currentRoute);
  }

  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  void registerButtons({
    required TRoute route,
    required Object owner,
    required ContextualButtonsBuilder builder,
  }) {
    if (route == TRoute.shell) {
      _shellButtonBuilders[owner] = builder;
      _applyRouteButtons(_baseRouterService.currentRoute);
      return;
    }
    final locationKey = _resolveLocationKey(route);
    _ownerRouteKeys[owner] = locationKey;
    _routeButtonBuilders[locationKey] = builder;
    if (_baseRouterService.currentRoute == locationKey) {
      _applyRouteButtons(locationKey);
    }
  }

  void unregisterButtons({required Object owner}) {
    if (_shellButtonBuilders.remove(owner) != null) {
      _applyRouteButtons(_baseRouterService.currentRoute);
      return;
    }
    final locationKey = _ownerRouteKeys.remove(owner);
    if (locationKey == null) {
      return;
    }
    _routeButtonBuilders.remove(locationKey);
    if (_baseRouterService.currentRoute == locationKey) {
      _applyRouteButtons(locationKey);
    }
  }

  String _resolveLocationKey(TRoute route) {
    final currentRoute = _baseRouterService.currentRoute;
    return currentRoute.isNotEmpty ? currentRoute : route.routerPath;
  }

  void _applyRouteButtons(String location) {
    if (_isDisposed) return;
    final routeBuilder = _routeButtonBuilders[location];
    final shellEntries = _mergeShellEntries();
    final routeEntries = routeBuilder?.call();
    final entries = [
      if (shellEntries != null) ...shellEntries,
      if (routeEntries != null) ...routeEntries,
    ];
    if (entries.isEmpty) {
      _scheduleConfig(const TContextualButtonsConfig());
      return;
    }
    _scheduleConfig(
      _buildConfig(
        entries,
        deviceType: _deviceType ?? TDeviceType.desktop,
      ),
    );
  }

  TContextualButtonsConfig _buildConfig(
    List<ContextualButtonEntry> entries, {
    required TDeviceType deviceType,
  }) {
    final widgetsByPosition = <TContextualPosition, Map<TContextualVariation, List<Widget>>>{
      for (final position in TContextualPosition.values)
        position: {
          for (final variation in TContextualVariation.values) variation: <Widget>[],
        },
    };

    for (final entry in entries) {
      widgetsByPosition[entry.position]![entry.variation]!.add(
        ContextualNavButton(
          deviceType: deviceType,
          config: entry.config,
        ),
      );
    }

    var config = TContextualButtonsConfig(
      top: _slotFromWidgets(widgetsByPosition[TContextualPosition.top]!),
      bottom: _slotFromWidgets(widgetsByPosition[TContextualPosition.bottom]!),
      left: _slotFromWidgets(widgetsByPosition[TContextualPosition.left]!),
      right: _slotFromWidgets(widgetsByPosition[TContextualPosition.right]!),
      positionOverrides: _positionOverrides,
    );

    if (deviceType.isMobile) {
      config = config.copyWith(
        hiddenPositions: {
          ...config.hiddenPositions,
          TContextualPosition.left,
          TContextualPosition.right,
        },
      );
    } else {
      config = _remapBottomToLeft(config);
    }

    return config;
  }

  TContextualButtonsSlotConfig _slotFromWidgets(
    Map<TContextualVariation, List<Widget>> widgetsByVariation,
  ) {
    return TContextualButtonsSlotConfig(
      primary: widgetsByVariation[TContextualVariation.primary] ?? const [],
      secondary: widgetsByVariation[TContextualVariation.secondary] ?? const [],
      tertiary: widgetsByVariation[TContextualVariation.tertiary] ?? const [],
    );
  }

  TContextualButtonsConfig _remapBottomToLeft(TContextualButtonsConfig config) {
    final bottom = config.bottom;
    final left = config.left;

    final combined = <List<Widget>>[
      if (bottom.primary.isNotEmpty) bottom.primary,
      if (bottom.secondary.isNotEmpty) bottom.secondary,
      if (bottom.tertiary.isNotEmpty) bottom.tertiary,
      if (left.primary.isNotEmpty) left.primary,
      if (left.secondary.isNotEmpty) left.secondary,
      if (left.tertiary.isNotEmpty) left.tertiary,
    ];

    final newLeftPrimary = combined.isNotEmpty ? combined[0] : const <Widget>[];
    final newLeftSecondary = combined.length > 1 ? combined[1] : const <Widget>[];
    final newLeftTertiary = combined.length > 2
        ? combined.sublist(2).expand((items) => items).toList()
        : const <Widget>[];

    return config.copyWith(
      left: left.copyWith(
        primary: newLeftPrimary,
        secondary: newLeftSecondary,
        tertiary: newLeftTertiary,
      ),
      bottom: bottom.copyWith(
        primary: const [],
        secondary: const [],
        tertiary: const [],
      ),
    );
  }

  bool _mapEquals(
    Map<TContextualPosition, TContextualPosition> a,
    Map<TContextualPosition, TContextualPosition> b,
  ) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }

  List<ContextualButtonEntry>? _mergeShellEntries() {
    if (_shellButtonBuilders.isEmpty) {
      return null;
    }
    final combined = <ContextualButtonEntry>[];
    for (final builder in _shellButtonBuilders.values) {
      final entries = builder();
      if (entries != null) {
        combined.addAll(entries);
      }
    }
    return combined;
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void _scheduleConfig(TContextualButtonsConfig config) {
    _pendingConfig = config;
    if (!_isAnimating) {
      unawaited(_processAnimations());
    }
  }

  Future<void> _processAnimations() async {
    if (_isAnimating || _isDisposed) return;
    _isAnimating = true;
    while (_pendingConfig != null && !_isDisposed) {
      final nextConfig = _pendingConfig!;
      _pendingConfig = null;
      if (value == nextConfig) {
        continue;
      }
      await _animateToConfig(nextConfig);
    }
    _isAnimating = false;
  }

  Future<void> _animateToConfig(TContextualButtonsConfig target) async {
    if (_isDisposed) return;
    final positions = TContextualPosition.values.toSet();

    final hiddenForAnimation = {...value.hiddenPositions, ...positions};
    update(value.copyWith(hiddenPositions: hiddenForAnimation));

    await Future.delayed(
      Duration(milliseconds: value.animationDuration.inMilliseconds ~/ 2),
    );
    if (_isDisposed) return;

    if (_pendingConfig != null) {
      target = _pendingConfig!;
      _pendingConfig = null;
    }

    final updatedHidden = {...target.hiddenPositions, ...positions};
    update(
      target.copyWith(hiddenPositions: updatedHidden),
      doNotifyListeners: false,
    );

    final finalHidden = {...updatedHidden}..removeAll(positions);
    update(target.copyWith(hiddenPositions: finalHidden));

    await Future.delayed(
      Duration(milliseconds: target.animationDuration.inMilliseconds ~/ 2),
    );
  }
}
