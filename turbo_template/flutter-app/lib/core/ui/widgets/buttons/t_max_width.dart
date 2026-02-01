import 'package:flutter/widgets.dart';

class TMaxWidth extends StatelessWidget {
  const TMaxWidth({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: double.infinity, child: child);
}
