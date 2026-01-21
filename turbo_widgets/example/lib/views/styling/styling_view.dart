import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';
import 'package:turbo_widgets/turbo_widgets.dart';
import 'package:turbo_widgets_example/views/styling/styling_view_model.dart';

class StylingView extends StatelessWidget {
  const StylingView({super.key});

  static const String path = 'styling';

  @override
  Widget build(BuildContext context) => TViewModelBuilder<StylingViewModel>(
        builder: (context, model, isInitialised, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: model.isPlaygroundExpanded,
                  builder: (context, isPlaygroundExpanded, _) {
                    return TCollapsibleSection(
                      title: 'Component Playground',
                      subtitle: 'Create and test widgets with responsive preview',
                      isExpanded: isPlaygroundExpanded,
                      onToggle: model.togglePlayground,
                      child: TPlayground<TPlaygroundParameterModel>(
                        parametersBuilder: () =>
                            const TPlaygroundParameterModel.empty(),
                        childBuilder: (context, params) {
                          final theme = ShadTheme.of(context);
                          return Center(
                            child: Text(
                              'Add your component here',
                              style: theme.textTheme.muted,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ValueListenableBuilder<bool>(
                  valueListenable: model.isContextualButtonsShowcaseExpanded,
                  builder: (context, isExpanded, _) {
                    return TCollapsibleSection(
                      title: 'TContextualButtons',
                      subtitle:
                          'Contextual overlay buttons with position and variation support',
                      isExpanded: isExpanded,
                      onToggle: model.toggleContextualButtonsShowcase,
                      child: Column(
                        children: [
                          _TContextualButtonsShowcase(
                            title: 'Basic - All Positions',
                            config: TContextualButtonsConfig(
                              top: const TContextualButtonsSlotConfig(
                                primary: [_ShowcaseBar(label: 'Top')],
                              ),
                              bottom: const TContextualButtonsSlotConfig(
                                primary: [_ShowcaseBar(label: 'Bottom')],
                              ),
                              left: const TContextualButtonsSlotConfig(
                                primary: [_ShowcaseBar(label: 'Left')],
                              ),
                              right: const TContextualButtonsSlotConfig(
                                primary: [_ShowcaseBar(label: 'Right')],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _TContextualButtonsShowcase(
                            title: 'Position Filter - Bottom Only',
                            config: TContextualButtonsConfig(
                              allowFilter: TContextualAllowFilter.bottom,
                              top: const TContextualButtonsSlotConfig(
                                primary: [
                                  _ShowcaseBar(label: 'Filtered to Bottom')
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _TContextualButtonsShowcase(
                            title: 'Multiple Variations',
                            config: TContextualButtonsConfig(
                              activeVariations: const {
                                TContextualVariation.primary,
                                TContextualVariation.secondary,
                              },
                              bottom: const TContextualButtonsSlotConfig(
                                primary: [_ShowcaseBar(label: 'Primary')],
                                secondary: [_ShowcaseBar(label: 'Secondary')],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ValueListenableBuilder<bool>(
                  valueListenable: model.isNavigationShowcaseExpanded,
                  builder: (context, isExpanded, _) {
                    return TCollapsibleSection(
                      title: 'Navigation Components',
                      subtitle:
                          'TBottomNavigation, TTopNavigation, TSideNavigation with TContextualButtons',
                      isExpanded: isExpanded,
                      onToggle: model.toggleNavigationShowcase,
                      child: Column(
                        children: [
                          _TNavigationShowcase(
                            title: 'TBottomNavigation',
                            navigationType: 'bottom',
                          ),
                          const SizedBox(height: 16),
                          _TNavigationShowcase(
                            title: 'TTopNavigation',
                            navigationType: 'top',
                          ),
                          const SizedBox(height: 16),
                          _TNavigationShowcase(
                            title: 'TSideNavigation',
                            navigationType: 'side',
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ValueListenableBuilder<bool>(
                  valueListenable: model.isViewBuilderShowcaseExpanded,
                  builder: (context, isExpanded, _) {
                    return TCollapsibleSection(
                      title: 'TViewBuilder',
                      subtitle:
                          'Convenience wrapper combining TContextualButtons and TBaseViewModelBuilder',
                      isExpanded: isExpanded,
                      onToggle: model.toggleViewBuilderShowcase,
                      child: Column(
                        children: [
                          _TViewBuilderShowcase(
                            title: 'With Custom Service',
                            useCustomService: true,
                          ),
                          const SizedBox(height: 16),
                          _TViewBuilderShowcase(
                            title: 'With Default Singleton',
                            useCustomService: false,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
        viewModelBuilder: () => StylingViewModel.locate,
      );
}

class _TContextualButtonsShowcase extends StatelessWidget {
  _TContextualButtonsShowcase({
    required this.title,
    required TContextualButtonsConfig config,
  }) : _service = TContextualButtonsService(config);

  final String title;
  final TContextualButtonsService _service;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.small.copyWith(
            color: theme.colorScheme.mutedForeground,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ShadCard(
            padding: EdgeInsets.zero,
            child: TContextualButtons(
              service: _service,
              child: Center(
                child: Text(
                  'Main Content',
                  style: theme.textTheme.muted,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShowcaseBar extends StatelessWidget {
  const _ShowcaseBar({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        border: Border.all(color: theme.colorScheme.border),
      ),
      child: Text(
        label,
        style: theme.textTheme.small.copyWith(
          color: theme.colorScheme.secondaryForeground,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _TNavigationShowcase extends StatelessWidget {
  _TNavigationShowcase({
    required this.title,
    required this.navigationType,
  }) : _service = TContextualButtonsService(_buildConfig(navigationType));

  final String title;
  final String navigationType;
  final TContextualButtonsService _service;

  static Map<String, TButtonConfig> _buildDemoButtons() {
    return {
      'home': TButtonConfig(
        icon: LucideIcons.house,
        label: 'Home',
        onPressed: () {},
      ),
      'search': TButtonConfig(
        icon: LucideIcons.search,
        label: 'Search',
        onPressed: () {},
      ),
      'profile': TButtonConfig(
        icon: LucideIcons.user,
        label: 'Profile',
        onPressed: () {},
      ),
    };
  }

  static TContextualButtonsConfig _buildConfig(String navigationType) {
    final buttons = _buildDemoButtons();
    const selectedKey = 'home';

    final navigation = switch (navigationType) {
      'top' => TTopNavigation(buttons: buttons, selectedKey: selectedKey),
      'side' => TSideNavigation(buttons: buttons, selectedKey: selectedKey),
      _ => TBottomNavigation(buttons: buttons, selectedKey: selectedKey),
    };

    return TContextualButtonsConfig(
      top: navigationType == 'top'
          ? TContextualButtonsSlotConfig(primary: [navigation])
          : const TContextualButtonsSlotConfig(),
      bottom: navigationType == 'bottom'
          ? TContextualButtonsSlotConfig(primary: [navigation])
          : const TContextualButtonsSlotConfig(),
      left: navigationType == 'side'
          ? TContextualButtonsSlotConfig(primary: [navigation])
          : const TContextualButtonsSlotConfig(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.small.copyWith(
            color: theme.colorScheme.mutedForeground,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ShadCard(
            padding: EdgeInsets.zero,
            child: TContextualButtons(
              service: _service,
              child: Center(
                child: Text(
                  'Main Content',
                  style: theme.textTheme.muted,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExampleViewModel extends TBaseViewModel<Object?> {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
    rebuild();
  }
}

class _TViewBuilderShowcase extends StatelessWidget {
  const _TViewBuilderShowcase({
    required this.title,
    required this.useCustomService,
  });

  final String title;
  final bool useCustomService;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.small.copyWith(
            color: theme.colorScheme.mutedForeground,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ShadCard(
            padding: EdgeInsets.zero,
            child: TViewBuilder<_ExampleViewModel>(
              contextualButtonsService: useCustomService
                  ? TContextualButtonsService(
                      TContextualButtonsConfig(
                        bottom: const TContextualButtonsSlotConfig(
                          primary: [_ShowcaseBar(label: 'Custom Service')],
                        ),
                      ),
                    )
                  : null,
              viewModelBuilder: _ExampleViewModel.new,
              builder: (context, viewModel, isInitialised, child) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Counter: ${viewModel.counter}',
                        style: theme.textTheme.p,
                      ),
                      const SizedBox(height: 8),
                      ShadButton(
                        size: ShadButtonSize.sm,
                        onPressed: viewModel.increment,
                        child: const Text('Increment'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
