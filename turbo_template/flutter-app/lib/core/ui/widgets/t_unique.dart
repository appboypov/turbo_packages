import 'package:flutter/widgets.dart';

class TUnique extends StatelessWidget {
  const TUnique({Key? key, required this.id, required this.child}) : super(key: key);

  final String id;
  final Widget child;

  @override
  Widget build(BuildContext context) => KeyedSubtree(key: ValueKey(id), child: child);
}
