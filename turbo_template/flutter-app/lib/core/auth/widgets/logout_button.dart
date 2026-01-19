import 'package:flutter/material.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:roomy_mobile/state/typedefs/context_def.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key, required this.onPressed, this.padding = EdgeInsets.zero})
    : super(key: key);

  final NamedContextDef onPressed;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Semantics(
    identifier: 'logout_button',
    label: context.strings.logoutButtonLabel,
    button: true,
    child: ShadIconButton.ghost(
      icon: const Icon(Icons.logout_rounded),
      onPressed: () => onPressed(context: context),
    ),
  );
}
