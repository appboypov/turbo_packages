import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/infrastructure/views/playground/playground_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_widget.dart';
import 'package:turbo_flutter_template/core/ui/enums/emoji.dart';
import 'package:turbo_flutter_template/core/ui/enums/t_proportional_grid_animation.dart';
import 'package:turbo_flutter_template/core/ui/models/t_proportional_item.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_proportional_grid.dart';
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
                onBackPressed: ({required BuildContext context}) =>
                    Navigator.of(context).pop(),
              ),
              children: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: TPlayground<TPlaygroundParameterModel>(
                      parametersBuilder: _buildProportionalGridParameters,
                      initialIsDarkMode: context.themeMode.isDark,
                      childBuilder: (context, params) {
                        return _ProportionalGridPlayground(params: params);
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

TPlaygroundParameterModel _buildProportionalGridParameters() {
  return const TPlaygroundParameterModel(
    strings: {
      'item1_title': 'Analytics Dashboard',
      'item1_description': 'Real-time insights and performance metrics.',
      'item2_title': 'Cloud Storage',
      'item2_description': 'Secure and scalable file storage.',
      'item3_title': 'AI Assistant',
      'item3_description': 'Intelligent automation.',
      'item4_title': 'Security Suite',
      'item4_description': 'Enterprise-grade protection.',
    },
    doubles: {
      'item1_size': 4.0,
      'item2_size': 2.0,
      'item3_size': 2.0,
      'item4_size': 2.0,
      'spacing': 12.0,
    },
    selects: {
      'animation': TSelectOption<String>(
        value: 'fade',
        options: ['slide', 'fade', 'scale', 'none'],
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
  );
}

class _ProportionalGridPlayground extends StatelessWidget {
  const _ProportionalGridPlayground({required this.params});

  final TPlaygroundParameterModel params;

  @override
  Widget build(BuildContext context) {
    final spacing = params.doubles['spacing'] ?? 12.0;
    final animation = _parseAnimation(params.selects['animation']?.value ?? 'fade');

    return SizedBox(
      height: 500,
      child: TProportionalGrid(
        spacing: spacing,
        animation: animation,
        items: [
          TProportionalItem(
            size: params.doubles['item1_size'] ?? 4.0,
            child: _ProportionalCard(
              title: params.strings['item1_title'] ?? 'Item 1',
              description: params.strings['item1_description'] ?? '',
              icon: _parseIcon(params.selects['item1_icon']?.value ?? 'analytics'),
              accentColor: _parseColor(context, params.selects['item1_color']?.value ?? 'primary'),
            ),
          ),
          TProportionalItem(
            size: params.doubles['item2_size'] ?? 2.0,
            child: _ProportionalCard(
              title: params.strings['item2_title'] ?? 'Item 2',
              description: params.strings['item2_description'] ?? '',
              icon: _parseIcon(params.selects['item2_icon']?.value ?? 'cloud'),
              accentColor: _parseColor(context, params.selects['item2_color']?.value ?? 'blue'),
            ),
          ),
          TProportionalItem(
            size: params.doubles['item3_size'] ?? 2.0,
            child: _ProportionalCard(
              title: params.strings['item3_title'] ?? 'Item 3',
              description: params.strings['item3_description'] ?? '',
              icon: _parseIcon(params.selects['item3_icon']?.value ?? 'smart_toy'),
              accentColor: _parseColor(context, params.selects['item3_color']?.value ?? 'purple'),
            ),
          ),
          TProportionalItem(
            size: params.doubles['item4_size'] ?? 2.0,
            child: _ProportionalCard(
              title: params.strings['item4_title'] ?? 'Item 4',
              description: params.strings['item4_description'] ?? '',
              icon: _parseIcon(params.selects['item4_icon']?.value ?? 'security'),
              accentColor: _parseColor(context, params.selects['item4_color']?.value ?? 'green'),
            ),
          ),
        ],
      ),
    );
  }

  TProportionalGridAnimation _parseAnimation(String value) {
    return switch (value) {
      'slide' => TProportionalGridAnimation.slide,
      'fade' => TProportionalGridAnimation.fade,
      'scale' => TProportionalGridAnimation.scale,
      'none' => TProportionalGridAnimation.none,
      _ => TProportionalGridAnimation.fade,
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

/// A simple card widget for the proportional grid demo.
class _ProportionalCard extends StatelessWidget {
  const _ProportionalCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Accent gradient background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      accentColor.withValues(alpha: 0.15),
                      colors.card,
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon badge
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 22,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    title,
                    style: theme.textTheme.large.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.primaryText,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Description
                  Expanded(
                    child: Text(
                      description,
                      style: theme.textTheme.muted.copyWith(
                        fontSize: 13,
                        height: 1.4,
                      ),
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Size indicator bar
                  const SizedBox(height: 8),
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
