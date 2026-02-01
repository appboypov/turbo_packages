import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/widgets/animation_value_extension.dart';
import 'package:turbo_flutter_template/core/ui/widgets/buttons/opacity_button.dart';
import 'package:turbo_flutter_template/core/ui/widgets/t_provider.dart';
import 'package:turbo_flutter_template/core/ux/globals/g_vibrate.dart';

class TTabHeader<T> extends StatefulWidget {
  const TTabHeader({
    super.key,
    required this.tabController,
    required this.items,
    required this.tabBuilder,
    this.tabWidthBuilder,
    required this.activeTabBuilder,
    this.onTabChanged,
    this.tabHeight = 40,
  });

  final TabController tabController;
  final List<T> items;
  final Widget Function(T item) tabBuilder;
  final Widget Function(T item) activeTabBuilder;
  final double Function(T item, double maxWidth, int itemCount)?
  tabWidthBuilder;
  final void Function(T item)? onTabChanged;
  final double tabHeight;

  @override
  State<TTabHeader<T>> createState() => _TTabHeaderState<T>();
}

class _TTabHeaderState<T> extends State<TTabHeader<T>> {
  T? _lastItem;

  final autoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final itemMaxWidth = maxWidth / widget.items.length;
      final Map<T, double> widthMap = {};
      for (final item in widget.items) {
        widthMap[item] =
            widget.tabWidthBuilder?.call(item, maxWidth, widget.items.length) ??
            itemMaxWidth;
      }
      final sizedBox = SizedBox(
        height: widget.tabHeight,
        child: AnimatedBuilder(
          animation: widget.tabController.animation!,
          builder: (context, child) {
            final animationValue = widget.tabController.animation!.value;
            final item = widget.items[(animationValue + 0.5).floor()];

            if (widget.onTabChanged != null && _lastItem != item) {
              _onItemChanged(item);
            }

            final opacity = 1 - ((animationValue % 0.5) * 2);
            final tabWidth = widthMap[item]!;
            final rawLeftOffset =
                (itemMaxWidth * animationValue) + (itemMaxWidth - tabWidth) / 2;
            final double leftOffset = rawLeftOffset.clamp(
              0,
              maxWidth - tabWidth,
            );

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  children: [
                    for (final item in widget.items)
                      Expanded(
                        child: Opacity(
                          opacity: TSizes.opacityDisabled,
                          child: OpacityButton(
                            onPressed: () {
                              widget.tabController.animateTo(
                                widget.items.indexOf(item),
                                curve: Curves.decelerate,
                                duration: TDurations.animationX1p5,
                              );
                              gVibrateSelection();
                            },
                            child: Center(
                              child: SizedBox(
                                width:
                                    widthMap[item]! - (TSizes.borderWidth * 2),
                                child: widget.tabBuilder(item),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Positioned(
                  left: leftOffset,
                  child: SizedBox(
                    width: tabWidth,
                    height: widget.tabHeight,
                    child: ShadCard(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: Opacity(
                          opacity: widget.items.indexOf(item) == 0
                              ? opacity
                              : animationValue < widget.items.indexOf(item)
                              ? opacity.reversed
                              : opacity,
                          child: widget
                              .activeTabBuilder(item)
                              .animate(
                                key: ValueKey(item),
                                onPlay: (controller) =>
                                    controller.forward(from: 0),
                              )
                              .shake(
                                hz: 1,
                                duration: TDurations.animationX3,
                                curve: Curves.decelerate,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
      return sizedBox;
    },
  );

  void _onItemChanged(item) =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _lastItem = item;
        widget.onTabChanged?.call(item);
      });
}
