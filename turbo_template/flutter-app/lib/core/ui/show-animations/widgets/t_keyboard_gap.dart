import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/widgets/t_animated_gap.dart';

import '../../../state/manage-state/extensions/context_extension.dart';

class TKeyboardGap extends StatelessWidget {
  const TKeyboardGap({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => TAnimatedGap(context.sizes.keyboardInsets);
}
