import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';

class TMaxHeight extends StatelessWidget {
  const TMaxHeight({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: context.data.height, child: child);
}
