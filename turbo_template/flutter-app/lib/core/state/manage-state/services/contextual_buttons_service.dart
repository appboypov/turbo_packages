import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/t_route.dart';
import 'package:turbo_flutter_template/core/infrastructure/services/base_router_service.dart';
import 'package:turbo_flutter_template/core/state/manage-state/models/contextual_button_entry.dart';
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
    final entriesByPosition =
        <TContextualPosition, Map<TContextualVariation, List<ContextualButtonEntry>>>{
          for (final position in TContextualPosition.values)
            position: {
              for (final variation in TContextualVariation.values) variation: <ContextualButtonEntry>[],
            },
        };

    for (final entry in entries) {
      entriesByPosition[entry.position]![entry.variation]!.add(entry);
    }

    if (!deviceType.isMobile) {
      for (final variation in TContextualVariation.values) {
        entriesByPosition[TContextualPosition.left]![variation]!.addAll(
          entriesByPosition[TContextualPosition.bottom]![variation]!,
        );
        entriesByPosition[TContextualPosition.bottom]![variation]!.clear();
      }
    }

    var config = TContextualButtonsConfig(
      top: _slotFromEntries(
        position: TContextualPosition.top,
        entriesByVariation: entriesByPosition[TContextualPosition.top]!,
        deviceType: deviceType,
      ),
      bottom: _slotFromEntries(
        position: TContextualPosition.bottom,
        entriesByVariation: entriesByPosition[TContextualPosition.bottom]!,
        deviceType: deviceType,
      ),
      left: _slotFromEntries(
        position: TContextualPosition.left,
        entriesByVariation: entriesByPosition[TContextualPosition.left]!,
        deviceType: deviceType,
      ),
      right: _slotFromEntries(
        position: TContextualPosition.right,
        entriesByVariation: entriesByPosition[TContextualPosition.right]!,
        deviceType: deviceType,
      ),
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
    }

    return config;
  }

  TContextualButtonsSlotConfig _slotFromEntries({
    required TContextualPosition position,
    required Map<TContextualVariation, List<ContextualButtonEntry>> entriesByVariation,
    required TDeviceType deviceType,
  }) {
    return TContextualButtonsSlotConfig(
      primary: _widgetsForVariation(
        position: position,
        variation: TContextualVariation.primary,
        entries: entriesByVariation[TContextualVariation.primary] ?? const [],
        deviceType: deviceType,
      ),
      secondary: _widgetsForVariation(
        position: position,
        variation: TContextualVariation.secondary,
        entries: entriesByVariation[TContextualVariation.secondary] ?? const [],
        deviceType: deviceType,
      ),
      tertiary: _widgetsForVariation(
        position: position,
        variation: TContextualVariation.tertiary,
        entries: entriesByVariation[TContextualVariation.tertiary] ?? const [],
        deviceType: deviceType,
      ),
    );
  }

  List<Widget> _widgetsForVariation({
    required TContextualPosition position,
    required TContextualVariation variation,
    required List<ContextualButtonEntry> entries,
    required TDeviceType deviceType,
  }) {
    if (entries.isEmpty) {
      return const [];
    }

    final entryKeys = entries
        .asMap()
        .entries
        .map((entry) => _entryKey(entry.value, entry.key))
        .toList();
    final widgetKey = ValueKey('${position.name}-${variation.name}-${entryKeys.join("-")}');
    final actions = entries.map((entry) => entry.config).toList();
    final buttonMap = <String, TButtonConfig>{
      for (var i = 0; i < entries.length; i++) _entryKey(entries[i], i): entries[i].config,
    };
    final selectedIndex = entries.indexWhere((entry) => entry.config.isActive);
    final selectedKey = selectedIndex >= 0
        ? _entryKey(entries[selectedIndex], selectedIndex)
        : null;

    switch (position) {
      case TContextualPosition.top:
        return [
          TContextualAppBar(
            key: widgetKey,
            actions: actions,
            showLabels: deviceType.showButtonLabel,
          ),
        ];
      case TContextualPosition.bottom:
        return [
          TContextualBottomNavigation(
            key: widgetKey,
            buttons: buttonMap,
            selectedKey: selectedKey,
            showLabels: deviceType.showButtonLabel,
          ),
        ];
      case TContextualPosition.left:
      case TContextualPosition.right:
        return [
          TContextualSideNavigation(
            key: widgetKey,
            buttons: buttonMap,
            selectedKey: selectedKey,
            showLabels: deviceType.showButtonLabel,
          ),
        ];
    }
  }

  String _entryKey(ContextualButtonEntry entry, int index) =>
      entry.id ?? '${entry.position.name}-${entry.variation.name}-$index';

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
    if (_pendingConfig != null) {
      target = _pendingConfig!;
      _pendingConfig = null;
    }
    update(target);
    await Future<void>.delayed(Duration.zero);
  }
}
