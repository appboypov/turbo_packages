import 'package:flutter/cupertino.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

typedef TContextualButtonsBuilder = Widget Function(
  BuildContext context,
  TContextualVariation variation,
  List<Widget> children,
);
