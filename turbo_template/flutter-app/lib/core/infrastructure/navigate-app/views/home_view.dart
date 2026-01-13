import 'package:flutter/material.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/constants/routes.dart';
import 'package:turbo_flutter_template/l10n/globals/g_strings.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const String path = Routes.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(gStrings.home)),
      body: Center(child: Text(gStrings.welcomeToApp(gStrings.appName))),
    );
  }
}
