import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/widgets/fade_in.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/constants/t_widget.dart';
import 'package:veto/data/enums/busy_type.dart';
import 'package:veto/data/models/busy_model.dart';

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
  final BusyModel busyModel;
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
              BusyType.none => TWidgets.nothing,
              BusyType.indicator => TWidgets.nothing,
              BusyType.indicatorIgnorePointer => TWidgets.nothing,
              BusyType.indicatorBackdrop => IgnorePointer(
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
              BusyType.indicatorBackdropIgnorePointer => Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            },
            switch (busyType) {
              BusyType.none => TWidgets.nothing,
              (_) => const Center(child: CircularProgressIndicator()),
            },
          ],
        ),
      ),
      fadeOutChild: isNotBusyWidget,
    );
  }
}
