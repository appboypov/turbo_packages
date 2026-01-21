import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/infrastructure/run-app/views/shell/shell_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/widgets/unfocusable.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/constants/t_widget.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_responsive_builder.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_scaffold.dart';
import 'package:turbo_mvvm/data/models/t_view_model.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

class ShellView extends StatelessWidget {
  const ShellView({
    super.key,
    required this.statefulNavigationShell,
  });

  static const String path = 'welcome';

  final StatefulNavigationShell statefulNavigationShell;

  @override
  Widget build(BuildContext context) => TViewBuilder<ShellViewModel>(
    argumentBuilder: () => statefulNavigationShell,
    builder: (context, model, isInitialised, child) {
      if (!isInitialised) {
        return const TScaffold(
          child: TWidgets.nothing,
          showBackgroundPattern: true,
        );
      }
      return Unfocusable(
        child: TResponsiveBuilder(
          builder: (context, child, constraints, tools, data) => switch (data.deviceType) {
            TDeviceType.mobile => _Mobile(
              statefulNavigationShell: statefulNavigationShell,
            ),
            TDeviceType.tablet => _Tablet(
              statefulNavigationShell: statefulNavigationShell,
            ),
            TDeviceType.desktop => _Desktop(
              statefulNavigationShell: statefulNavigationShell,
            ),
          },
        ),
      );
    },
    viewModelBuilder: () => ShellViewModel.locate,
  );
}

class _Mobile extends ViewModelWidget<ShellViewModel> {
  const _Mobile({required this.statefulNavigationShell}) : super(isReactive: false);

  final StatefulNavigationShell statefulNavigationShell;

  @override
  Widget build(BuildContext context, ShellViewModel model) {
    return TScaffold(
      child: ShadSonner(
        child: Row(
          children: [
            Expanded(child: statefulNavigationShell),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: TSizes.appPadding * 1.5,
          vertical: TSizes.appPadding * 0.75,
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<NavigationTab>(
        valueListenable: model.currentNavigationTab,
        builder: (context, currentNavigationTab, child) {
          final backgroundColor = context.colors.shell;
          return NavigationBar(
            backgroundColor: backgroundColor,
            indicatorColor: context.colors.primary,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            selectedIndex: currentNavigationTab.index,
            onDestinationSelected: (int index) {
              final navigationTab = NavigationTab.values[index];
              model.onNavigationTabTap(
                navigationTab,
                context: context,
                statefulNavigationShell: statefulNavigationShell,
              );
            },
            destinations: <Widget>[
              for (final navigationTab in NavigationTab.values)
                switch (navigationTab) {
                  NavigationTab.actionButton => ValueListenableBuilder(
                    valueListenable: model.actionButtonType,
                    builder: (context, actionButtonType, child) => TActionButton(
                      onPressed: model.onActionButtonPressed,
                      type: actionButtonType,
                    ),
                  ),
                  _ => NavigationDestination(
                    icon: Icon(
                      navigationTab.icon,
                      color: currentNavigationTab == navigationTab
                          ? backgroundColor
                          : backgroundColor.onColor,
                    ),
                    label: navigationTab.label,
                  ),
                },
            ],
          );
        },
      ),
    );
  }
}

class _Tablet extends ViewModelWidget<ShellViewModel> {
  const _Tablet({
    required this.statefulNavigationShell,
  }) : super(isReactive: false);

  final StatefulNavigationShell statefulNavigationShell;

  @override
  Widget build(BuildContext context, ShellViewModel model) {
    return _Mobile(
      statefulNavigationShell: statefulNavigationShell,
    );
  }
}

class _Desktop extends ViewModelWidget<ShellViewModel> {
  const _Desktop({
    required this.statefulNavigationShell,
  }) : super(isReactive: false);

  final StatefulNavigationShell statefulNavigationShell;

  @override
  Widget build(BuildContext context, ShellViewModel model) {
    return _Mobile(
      statefulNavigationShell: statefulNavigationShell,
    );
  }
}
