import 'package:turbo_promptable/workspace/models/root/t_context.dart';

class TCollection extends TContext {
  const TCollection({
    required super.name,
    required this.items,
  });

  final List<String> items;
}
