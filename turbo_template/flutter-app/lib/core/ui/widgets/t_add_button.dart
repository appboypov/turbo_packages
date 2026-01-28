import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ux/globals/g_vibrate.dart';

class TAddButton extends StatelessWidget {
  const TAddButton({Key? key, required this.onPressed, required this.text}) : super(key: key);

  final VoidCallback onPressed;
  final String text;

  void _handlePressed() {
    gVibrateLight(); // Light vibration for add buttons
    onPressed();
  }

  @override
  Widget build(BuildContext context) => ShadButton.outline(
    onPressed: _handlePressed,
    child: Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: context.texts.button.copyWith(color: context.colors.primaryText),
      ),
    ),
  );
}
