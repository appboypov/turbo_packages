import 'package:flutter/cupertino.dart';
import 'package:turbo_flutter_template/core/shared/typedefs/update_current_def.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/enums/list_position.dart';
import 'package:turbo_flutter_template/core/ui/enums/t_device_type.dart';
import 'package:turbo_flutter_template/core/ui/enums/t_theme_mode.dart';

extension NullableObjectExtension on Object? {
  T butWhen<T extends Object?>(bool condition, UpdateCurrentDef<T> value) =>
      condition ? value.call(this as T) : this as T;
}

extension ObjectExtension on Object {
  E asType<E extends Object>() => this as E;

  T whenTheme<T extends Object>(
    BuildContext context, {
    UpdateCurrentDef<T>? dark,
    UpdateCurrentDef<T>? light,
  }) {
    final themeMode = context.themeMode;
    return switch (themeMode) {
      TThemeMode.dark => (dark?.call(this as T) ?? this) as T,
      TThemeMode.light => (light?.call(this as T) ?? this) as T,
    };
  }

  T butWhenLightMode<T extends Object>(BuildContext context, UpdateCurrentDef<T> value) =>
      whenTheme<T>(context, light: value);

  T butWhenDarkMode<T extends Object>(BuildContext context, UpdateCurrentDef<T> value) =>
      whenTheme<T>(context, dark: value);

  T whenDevice<T extends Object>(
    BuildContext context, {
    UpdateCurrentDef<T>? mobile,
    UpdateCurrentDef<T>? tablet,
    UpdateCurrentDef<T>? desktop,
  }) {
    final deviceType = context.deviceType;
    return switch (deviceType) {
      TDeviceType.mobile => (mobile?.call(this as T) ?? this) as T,
      TDeviceType.tablet => (tablet?.call(this as T) ?? this) as T,
      TDeviceType.desktop => (desktop?.call(this as T) ?? this) as T,
    };
  }

  T butWhenMobile<T extends Object>(BuildContext context, UpdateCurrentDef<T> value) =>
      whenDevice<T>(context, mobile: value);

  T butWhenNotMobile<T extends Object>(BuildContext context, UpdateCurrentDef<T> value) =>
      whenDevice<T>(context, tablet: value, desktop: value);

  T butWhenTablet<T extends Object>(BuildContext context, UpdateCurrentDef<T> value) =>
      whenDevice<T>(context, tablet: value);

  T butWhenDesktop<T extends Object>(BuildContext context, UpdateCurrentDef<T> value) =>
      whenDevice<T>(context, desktop: value);

  T butWhenNotDesktop<T extends Object>(BuildContext context, UpdateCurrentDef<T> value) =>
      whenDevice<T>(context, mobile: value, tablet: value);

  T whenListPosition<T extends Object>({
    required ListPosition position,
    UpdateCurrentDef<T>? first,
    UpdateCurrentDef<T>? middle,
    UpdateCurrentDef<T>? last,
  }) {
    return switch (position) {
      ListPosition.first => (first?.call(this as T) ?? this) as T,
      ListPosition.middle => (middle?.call(this as T) ?? this) as T,
      ListPosition.last => (last?.call(this as T) ?? this) as T,
    };
  }
}
