import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/turbo_widgets.dart';
import 'package:turbo_widgets_example/views/styling/styling_view.dart';

void main() {
  runApp(const TurboWidgetsExampleApp());
}

class TurboWidgetsExampleApp extends StatelessWidget {
  const TurboWidgetsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      title: 'Turbo Widgets',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ShadThemeData(
        colorScheme: const ShadZincColorScheme.light(),
        brightness: Brightness.light,
      ),
      darkTheme: ShadThemeData(
        colorScheme: const ShadZincColorScheme.dark(),
        brightness: Brightness.dark,
      ),
      home: ShadToaster(
        child: TContextualButtons(
          service: TContextualButtonsService.instance,
          child: const StylingView(),
        ),
      ),
    );
  }
}
