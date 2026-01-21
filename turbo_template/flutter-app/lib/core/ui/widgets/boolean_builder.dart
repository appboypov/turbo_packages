import 'package:flutter/widgets.dart';

class BooleanBuilder extends StatelessWidget {
  const BooleanBuilder({
    Key? key,
    required this.condition,
    required this.onTrue,
    required this.onFalse,
  }) : super(key: key);

  final bool condition;
  final Widget Function(BuildContext context) onTrue;
  final Widget Function(BuildContext context) onFalse;

  @override
  Widget build(BuildContext context) => condition ? onTrue(context) : onFalse(context);
}
