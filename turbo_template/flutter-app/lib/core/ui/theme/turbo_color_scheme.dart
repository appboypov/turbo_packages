import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: implementation_imports
import 'package:shadcn_ui/src/theme/color_scheme/base.dart';

@immutable
class TurboColorScheme extends ShadColorScheme {
  const TurboColorScheme({
    required super.background,
    required super.foreground,
    required super.card,
    required super.cardForeground,
    required super.popover,
    required super.popoverForeground,
    required super.primary,
    required super.primaryForeground,
    required super.secondary,
    required super.secondaryForeground,
    required super.muted,
    required super.mutedForeground,
    required super.accent,
    required super.accentForeground,
    required super.destructive,
    required super.destructiveForeground,
    required super.border,
    required super.input,
    required super.ring,
    required super.selection,
    this.shell,
  });

  final Color? shell;

  const TurboColorScheme.light({
    super.background = const Color(0xFFFFFFFF),
    super.foreground = const Color(0xFF020817),
    super.card = const Color(0xFFFFFFFF),
    super.cardForeground = const Color(0xFF020817),
    super.popover = const Color(0xFFFFFFFF),
    super.popoverForeground = const Color(0xFF020817),
    super.primary = const Color(0xFF000000),
    super.primaryForeground = const Color(0xFFFFFFFF),
    super.secondary = const Color(0xFFF3F4F6),
    super.secondaryForeground = const Color(0xFF020817),
    super.muted = const Color(0xFFF3F4F6),
    super.mutedForeground = const Color(0xFF6B7280),
    super.accent = const Color(0xFFF3F4F6),
    super.accentForeground = const Color(0xFF020817),
    super.destructive = const Color(0xFFEF4444),
    super.destructiveForeground = const Color(0xFFFFFFFF),
    super.border = const Color(0xFFE5E7EB),
    super.input = const Color(0xFFF3F4F6),
    super.ring = const Color(0xFF000000),
    super.selection = const Color(0xFFE5E7EB),
    this.shell = const Color(0xFFF9FAFB),
  });

  const TurboColorScheme.dark({
    super.background = const Color(0xFF0D1117),
    super.foreground = const Color(0xFFF0F6FC),
    super.card = const Color(0xFF161B22),
    super.cardForeground = const Color(0xFFF0F6FC),
    super.popover = const Color(0xFF161B22),
    super.popoverForeground = const Color(0xFFF0F6FC),
    super.primary = const Color(0xFFFFFFFF),
    super.primaryForeground = const Color(0xFF0D1117),
    super.secondary = const Color(0xFF21262D),
    super.secondaryForeground = const Color(0xFFF0F6FC),
    super.muted = const Color(0xFF161B22),
    super.mutedForeground = const Color(0xFF8B949E),
    super.accent = const Color(0xFF21262D),
    super.accentForeground = const Color(0xFFF0F6FC),
    super.destructive = const Color(0xFF7F1D1D),
    super.destructiveForeground = const Color(0xFFF8FAFC),
    super.border = const Color(0xFF21262D),
    super.input = const Color(0xFF21262D),
    super.ring = const Color(0xFFFFFFFF),
    super.selection = const Color(0xFF355172),
    this.shell = const Color(0xFF0D1117),
  });
}
