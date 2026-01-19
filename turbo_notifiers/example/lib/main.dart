import 'dart:math';

import 'package:turbo_notifiers_example/widgets/example_implementations/turbo_notifier_example.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:turbo_notifiers/turbo_notifiers.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turbo Notifiers',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String route = 'home-view';

  @override
  Widget build(BuildContext context) => TViewModelBuilder<HomeViewModel>(
        builder: (context, model, isInitialised, child) {
          return GestureDetector(
            onTap: model.focusNode.unfocus,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Turbo Notifiers Example Project'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    TNotifierExample(model: model),
                    const SizedBox(height: kBottomNavigationBarHeight),
                  ],
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => HomeViewModel.locate,
      );
}

class HomeViewModel extends TViewModel<Object?> {
  final TNotifier<int> _counter = TNotifier(0);
  ValueListenable<int> get counterListenable => _counter;

  late final random = Random();

  @override
  Future<void> initialise() async {
    super.initialise();
  }

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  // -------- TNotifier ---- TNotifier ---- TNotifier -------- \\

  void updateCounter({required int value}) => _counter.update(value);

  void decrementCounter() => _counter.updateCurrent((value) => --value);

  void incrementCounter() => _counter.updateCurrent((value) => ++value);

  /// Provides the current [TurboViewModelBuilderState]'s [FocusNode].
  FocusNode get focusNode => FocusScope.of(context!);

  TextStyle get exampleTitleStyle =>
      Theme.of(context!).textTheme.bodyMedium!.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          );

  static HomeViewModel get locate => HomeViewModel();
}
