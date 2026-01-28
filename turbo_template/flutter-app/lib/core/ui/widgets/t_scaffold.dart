import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_app_background.dart';

class TScaffold extends StatelessWidget {
  const TScaffold({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.headerBackgroundColor,
    this.footerBackgroundColor,
    this.backgroundContent = const [],
    this.foregroundContent = const [],
    this.showBackgroundPattern = true,
    this.resizeToAvoidBottomInset = true,
    this.footers,
    this.bottomNavigationBar,
    this.appBar,
  }) : super(key: key);

  final Color? backgroundColor;
  final Color? footerBackgroundColor;
  final Color? headerBackgroundColor;
  final List<Widget> backgroundContent;
  final List<Widget> foregroundContent;
  final Widget child;
  final bool showBackgroundPattern;
  final bool resizeToAvoidBottomInset;
  final Widget? bottomNavigationBar;
  final List<Widget>? footers;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      appBar: appBar,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SafeArea(
        child: Builder(
          builder: (context) =>
              backgroundContent.isEmpty &&
                  foregroundContent.isEmpty &&
                  !showBackgroundPattern &&
                  footers?.isEmpty == true
              ? child
              : Stack(
                  children: [
                    if (showBackgroundPattern) const TAppBackground(),
                    ...backgroundContent,
                    child,
                    ...foregroundContent,
                    if (footers != null) ...footers!,
                  ],
                ),
        ),
      ),
      backgroundColor: backgroundColor ?? context.colors.background,
    );
  }
}
