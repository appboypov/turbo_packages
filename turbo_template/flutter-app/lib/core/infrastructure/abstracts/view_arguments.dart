import 'package:turbo_flutter_template/core/infrastructure/services/base_router_service.dart';

abstract class ViewArguments {
  Map<String, dynamic> toJson();
}

extension ViewArgumentsListExtension on List<ViewArguments> {
  ExtraArguments get toExtraArguments {
    final extraArguments = <String, dynamic>{};
    for (final viewArguments in this) {
      extraArguments.addAll(viewArguments.toJson());
    }
    return ExtraArguments.fromJson(extraArguments);
  }
}
