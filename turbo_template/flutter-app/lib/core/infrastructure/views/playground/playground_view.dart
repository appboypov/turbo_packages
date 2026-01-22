import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/playground/playground_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_widget.dart';
import 'package:turbo_flutter_template/core/ui/enums/emoji.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_bento_grid.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_scaffold.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_sliver_app_bar.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_sliver_body.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

class PlaygroundView extends StatelessWidget {
  const PlaygroundView({super.key});

  @override
  Widget build(BuildContext context) => TViewModelBuilder<PlaygroundViewModel>(
    builder: (context, model, isInitialised, child) {
      if (!isInitialised) return TWidgets.nothing;

      return TScaffold(
        child: TSliverBody(
          isEmpty: false,
          appBar: TSliverAppBar(
            title: context.strings.playground,
            emoji: Emoji.testTube,
            onBackPressed: ({required BuildContext context}) => Navigator.of(context).pop(),
          ),
          children: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: TPlayground<TPlaygroundParameterModel>(
                  parametersBuilder: _buildBentoGridParameters,
                  initialIsDarkMode: context.themeMode.isDark,
                  childBuilder: (context, params) {
                    return _BentoGridPlayground(params: params);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
    viewModelBuilder: () => PlaygroundViewModel.locate,
  );
}

TPlaygroundParameterModel _buildBentoGridParameters() {
  return const TPlaygroundParameterModel(
    strings: {
      'item1_title': 'Analytics Dashboard',
      'item1_description': 'Real-time insights and performance metrics for your business.',
      'item2_title': 'Cloud Storage',
      'item2_description': 'Secure and scalable file storage solution.',
      'item3_title': 'AI Assistant',
      'item3_description': 'Intelligent automation powered by machine learning.',
      'item4_title': 'Security Suite',
      'item4_description': 'Enterprise-grade protection for your data.',
    },
    doubles: {
      'item1_size': 8.0,
      'item2_size': 5.0,
      'item3_size': 6.0,
      'item4_size': 3.0,
      'spacing': 12.0,
    },
    ints: {
      'crossAxisCount': 2,
    },
    selects: {
      'variant': TSelectOption<String>(
        value: 'masonry',
        options: ['masonry', 'magazine', 'brutalist'],
      ),
      'item1_icon': TSelectOption<String>(
        value: 'analytics',
        options: ['analytics', 'cloud', 'smart_toy', 'security', 'rocket', 'lightbulb'],
      ),
      'item2_icon': TSelectOption<String>(
        value: 'cloud',
        options: ['analytics', 'cloud', 'smart_toy', 'security', 'rocket', 'lightbulb'],
      ),
      'item3_icon': TSelectOption<String>(
        value: 'smart_toy',
        options: ['analytics', 'cloud', 'smart_toy', 'security', 'rocket', 'lightbulb'],
      ),
      'item4_icon': TSelectOption<String>(
        value: 'security',
        options: ['analytics', 'cloud', 'smart_toy', 'security', 'rocket', 'lightbulb'],
      ),
      'item1_color': TSelectOption<String>(
        value: 'primary',
        options: ['primary', 'blue', 'green', 'orange', 'purple', 'red'],
      ),
      'item2_color': TSelectOption<String>(
        value: 'blue',
        options: ['primary', 'blue', 'green', 'orange', 'purple', 'red'],
      ),
      'item3_color': TSelectOption<String>(
        value: 'purple',
        options: ['primary', 'blue', 'green', 'orange', 'purple', 'red'],
      ),
      'item4_color': TSelectOption<String>(
        value: 'green',
        options: ['primary', 'blue', 'green', 'orange', 'purple', 'red'],
      ),
    },
    bools: {
      'item1_hasImage': false,
      'item2_hasImage': false,
      'item3_hasImage': false,
      'item4_hasImage': false,
    },
  );
}

class _BentoGridPlayground extends StatelessWidget {
  const _BentoGridPlayground({required this.params});

  final TPlaygroundParameterModel params;

  @override
  Widget build(BuildContext context) {
    final variant = _parseVariant(params.selects['variant']?.value ?? 'masonry');
    final spacing = params.doubles['spacing'] ?? 12.0;
    final crossAxisCount = params.ints['crossAxisCount'] ?? 2;

    final items = [
      _buildItem(
        context,
        params,
        index: 1,
        titleKey: 'item1_title',
        descKey: 'item1_description',
        sizeKey: 'item1_size',
        iconKey: 'item1_icon',
        colorKey: 'item1_color',
        hasImageKey: 'item1_hasImage',
      ),
      _buildItem(
        context,
        params,
        index: 2,
        titleKey: 'item2_title',
        descKey: 'item2_description',
        sizeKey: 'item2_size',
        iconKey: 'item2_icon',
        colorKey: 'item2_color',
        hasImageKey: 'item2_hasImage',
      ),
      _buildItem(
        context,
        params,
        index: 3,
        titleKey: 'item3_title',
        descKey: 'item3_description',
        sizeKey: 'item3_size',
        iconKey: 'item3_icon',
        colorKey: 'item3_color',
        hasImageKey: 'item3_hasImage',
      ),
      _buildItem(
        context,
        params,
        index: 4,
        titleKey: 'item4_title',
        descKey: 'item4_description',
        sizeKey: 'item4_size',
        iconKey: 'item4_icon',
        colorKey: 'item4_color',
        hasImageKey: 'item4_hasImage',
      ),
    ];

    return TBentoGrid(
      items: items,
      variant: variant,
      spacing: spacing,
      crossAxisCount: crossAxisCount,
    );
  }

  TBentoItem _buildItem(
    BuildContext context,
    TPlaygroundParameterModel params, {
    required int index,
    required String titleKey,
    required String descKey,
    required String sizeKey,
    required String iconKey,
    required String colorKey,
    required String hasImageKey,
  }) {
    return TBentoItem(
      title: params.strings[titleKey] ?? 'Item $index',
      description: params.strings[descKey] ?? 'Description for item $index',
      size: params.doubles[sizeKey] ?? 5.0,
      icon: _parseIcon(params.selects[iconKey]?.value ?? 'analytics'),
      accentColor: _parseColor(context, params.selects[colorKey]?.value ?? 'primary'),
      backgroundImageUrl: (params.bools[hasImageKey] ?? false)
          ? 'https://picsum.photos/seed/$index/400/300'
          : null,
    );
  }

  TBentoGridVariant _parseVariant(String value) {
    return switch (value) {
      'masonry' => TBentoGridVariant.masonry,
      'magazine' => TBentoGridVariant.magazine,
      'brutalist' => TBentoGridVariant.brutalist,
      _ => TBentoGridVariant.masonry,
    };
  }

  IconData _parseIcon(String value) {
    return switch (value) {
      'analytics' => Icons.analytics_outlined,
      'cloud' => Icons.cloud_outlined,
      'smart_toy' => Icons.smart_toy_outlined,
      'security' => Icons.security_outlined,
      'rocket' => Icons.rocket_launch_outlined,
      'lightbulb' => Icons.lightbulb_outline,
      _ => Icons.circle_outlined,
    };
  }

  Color _parseColor(BuildContext context, String value) {
    final colors = context.colors;
    return switch (value) {
      'primary' => colors.primary,
      'blue' => const Color(0xFF3B82F6),
      'green' => const Color(0xFF22C55E),
      'orange' => const Color(0xFFF97316),
      'purple' => const Color(0xFF8B5CF6),
      'red' => const Color(0xFFEF4444),
      _ => colors.primary,
    };
  }
}
