import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/services/local_storage_service.dart';

class LocalStorageProvider extends StatelessWidget {
  final Widget child;

  const LocalStorageProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) =>
      Provider.value(value: LocalStorageService.locate, child: child);
}

class LocalStorageBuilder extends StatelessWidget {
  const LocalStorageBuilder({required this.builder, super.key, this.child, this.listenableBuilder});

  final Listenable? Function(LocalStorageService localStorageService)? listenableBuilder;
  final Widget Function(
    BuildContext context,
    LocalStorageService localStorageService,
    Widget? child,
  )
  builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final localStorageService = context.read<LocalStorageService>();
    return ListenableBuilder(
      listenable: listenableBuilder?.call(localStorageService) ?? localStorageService,
      builder: (context, child) => builder(context, localStorageService, child),
      child: child,
    );
  }
}

class LocalStorageProviderBuilder extends StatelessWidget {
  const LocalStorageProviderBuilder({
    required this.builder,
    super.key,
    this.child,
    this.listenableBuilder,
  });

  final Listenable? Function(LocalStorageService localStorageService)? listenableBuilder;
  final Widget Function(
    BuildContext context,
    LocalStorageService localStorageService,
    Widget? child,
  )
  builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) => LocalStorageProvider(
    child: Builder(
      builder: (context) =>
          LocalStorageBuilder(builder: builder, child: child, listenableBuilder: listenableBuilder),
    ),
  );
}
