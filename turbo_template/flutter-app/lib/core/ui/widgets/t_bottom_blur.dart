import 'package:flutter/widgets.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';

class TBottomBlur extends StatelessWidget {
  const TBottomBlur({
    super.key,
    required this.child,
    this.size = 80,
    this.sigma = 40,
    this.color,
  });

  final Widget child;
  final double size;
  final double sigma;
  final Color? color;

  @override
  Widget build(BuildContext context) => SoftEdgeBlur(
    edges: [
      EdgeBlur(
        type: EdgeType.bottomEdge,
        size: size,
        sigma: sigma,
        tintColor: color ?? context.colors.background,
        controlPoints: [
          ControlPoint(position: 0, type: ControlPointType.visible),
          ControlPoint(position: 1, type: ControlPointType.transparent),
        ],
      ),
    ],
    child: child,
  );
}
