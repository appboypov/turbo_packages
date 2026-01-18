import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_margin.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';

class DialogConstraints extends StatelessWidget {
  const DialogConstraints({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
    child: TMargin(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: TSizes.dialogMaxWidth),
        child: child,
      ),
    ),
  );
}
