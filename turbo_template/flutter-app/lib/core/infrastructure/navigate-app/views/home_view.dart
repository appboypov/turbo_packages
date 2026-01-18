import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const String path = 'home';

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Scaffold(
      appBar: AppBar(title: Text(strings.home)),
      body: Center(child: Text(strings.welcomeToApp(strings.appName))),
    );
  }
}
