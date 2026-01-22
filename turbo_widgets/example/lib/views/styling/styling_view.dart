import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';
import 'package:turbo_widgets/turbo_widgets.dart';
import 'package:turbo_widgets_example/views/styling/styling_view_model.dart';

const List<String> _categoryTitles = [
  'Design',
  'Engineering',
  'Marketing',
  'Operations',
  'People',
  'Finance',
  'Legal',
  'Product',
];

const List<String> _categoryImageUrls = [
  'https://images.unsplash.com/photo-1487014679447-9f8336841d58',
  'https://images.unsplash.com/photo-1521737604893-d14cc237f11d',
  'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40',
  'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4',
];

final List<ImageProvider> _categoryImages = _categoryImageUrls
    .map((url) => NetworkImage(url))
    .toList();

const List<IconData> _categoryIcons = [
  LucideIcons.palette,
  LucideIcons.code,
  LucideIcons.megaphone,
  LucideIcons.settings,
  LucideIcons.users,
  LucideIcons.badgeDollarSign,
  LucideIcons.scale,
  LucideIcons.layoutDashboard,
];

const String _categoryHeaderTitle = 'Browse categories';
const String _categoryHeaderDescription =
    'Explore curated categories with cards and sections that scale from small lists to rich grids.';

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
                  valueListenable: model.isCategoryWidgetsShowcaseExpanded,
                  builder: (context, isExpanded, _) {
                    return TCollapsibleSection(
                      title: 'Category Widgets',
                      subtitle:
                          'TCategoryHeader, TCategorySection, TCategoryCard',
                      isExpanded: isExpanded,
                      onToggle: model.toggleCategoryWidgetsShowcase,
                      child: const _TCategoryWidgetsShowcase(),
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
                          Text('Todo')
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

class _TCategoryWidgetsShowcase extends StatelessWidget {
  const _TCategoryWidgetsShowcase();

  ImageProvider? _backgroundForIndex(int index) {
    if (index.isEven) {
      return _categoryImages[index % _categoryImages.length];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TCategoryHeader(
          title: _categoryHeaderTitle,
          description: _categoryHeaderDescription,
          backgroundImage: _categoryImages.first,
        ),
        const SizedBox(height: 16),
        TCategorySection(
          title: 'Featured categories',
          caption: 'Horizontal list with show-all expansion',
          itemCount: _categoryTitles.length,
          maxItems: 6,
          maxLines: 2,
          itemBuilder: (context, index) {
            return SizedBox(
              width: 200,
              child: TCategoryCard(
                title: _categoryTitles[index],
                icon: _categoryIcons[index % _categoryIcons.length],
                backgroundImage: _backgroundForIndex(index),
                onPressed: () {},
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        TCategorySection(
          title: 'All categories',
          caption: 'Grid layout for larger lists',
          layout: TCategorySectionLayout.grid,
          gridCrossAxisCount: 2,
          gridChildAspectRatio: 1.6,
          itemCount: _categoryTitles.length,
          itemBuilder: (context, index) {
            return TCategoryCard(
              title: _categoryTitles[index],
              icon: _categoryIcons[index % _categoryIcons.length],
              backgroundImage: _backgroundForIndex(index),
              onPressed: () {},
            );
          },
        ),
      ],
    );
  }
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
