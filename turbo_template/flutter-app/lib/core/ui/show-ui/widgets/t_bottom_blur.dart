import 'package:flutter/widgets.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';

class TBottomBlur extends StatelessWidget {
  const TBottomBlur({Key? key, required this.child, this.size = 80, this.sigma = 40, this.color})
    : super(key: key);

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
