import 'package:flutter/material.dart';

/// A scaffold widget with convenient defaults and background support.
class TurboScaffold extends StatelessWidget {
  const TurboScaffold({
    super.key,
    required this.child,
    this.backgroundColor,
    this.headerBackgroundColor,
    this.footerBackgroundColor,
    this.backgroundContent = const [],
    this.foregroundContent = const [],
    this.resizeToAvoidBottomInset = true,
    this.footers,
    this.bottomNavigationBar,
    this.appBar,
    this.useSafeArea = true,
  });

  final Color? backgroundColor;
  final Color? footerBackgroundColor;
  final Color? headerBackgroundColor;
  final List<Widget> backgroundContent;
  final List<Widget> foregroundContent;
  final Widget child;
  final bool resizeToAvoidBottomInset;
  final Widget? bottomNavigationBar;
  final List<Widget>? footers;
  final PreferredSizeWidget? appBar;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final body =
        backgroundContent.isEmpty &&
            foregroundContent.isEmpty &&
            footers?.isEmpty == true
        ? child
        : Stack(
            children: [
              ...backgroundContent,
              child,
              ...foregroundContent,
              if (footers != null) ...footers!,
            ],
          );

    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      appBar: appBar,
      extendBodyBehindAppBar: appBar != null,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: useSafeArea ? SafeArea(child: body) : body,
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
    );
  }
}
