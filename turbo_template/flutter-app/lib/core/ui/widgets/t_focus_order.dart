import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ui/widgets/boolean_builder.dart';

class TFocusOrder extends StatelessWidget {
  const TFocusOrder({Key? key, required this.order, required this.child}) : super(key: key);

  final double? order;
  final Widget child;

  @override
  Widget build(BuildContext context) => BooleanBuilder(
    condition: order == null,
    onTrue: (context) => child,
    onFalse: (context) => FocusTraversalOrder(order: NumericFocusOrder(order!), child: child),
  );
}
