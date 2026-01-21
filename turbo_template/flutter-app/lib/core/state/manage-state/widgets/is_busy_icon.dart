import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ui/widgets/fade_in.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_widget.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';

class IsBusyIcon extends StatelessWidget {
  const IsBusyIcon({
    required this.busyModel,
    this.isNotBusyWidget,
    this.height = 80,
    this.fontSize,
    this.padding = 48,
    super.key,
  });

  final Widget? isNotBusyWidget;
  final double height;
  final TBusyModel busyModel;
  final double? fontSize;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final isBusy = busyModel.isBusy;
    final busyType = busyModel.busyType;
    return FadeIn(
      fadeIn: isBusy,
      fadeInChild: RepaintBoundary(
        child: Stack(
          fit: StackFit.expand,
          children: [
            switch (busyType) {
              TBusyType.none => TWidgets.nothing,
              TBusyType.indicator => TWidgets.nothing,
              TBusyType.indicatorIgnorePointer => TWidgets.nothing,
              TBusyType.indicatorBackdrop => IgnorePointer(
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
              TBusyType.indicatorBackdropIgnorePointer => Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            },
            switch (busyType) {
              TBusyType.none => TWidgets.nothing,
              (_) => const Center(child: CircularProgressIndicator()),
            },
          ],
        ),
      ),
      fadeOutChild: isNotBusyWidget,
    );
  }
}
