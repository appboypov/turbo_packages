import 'package:turbo_flutter_template/core/infrastructure/services/base_router_service.dart';

abstract class ViewArguments {
  Map<String, dynamic> toJson();
}

extension ViewArgumentsListExtension on List<ViewArguments> {
  RouteArguments get toRouteArguments {
    final extraArguments = <String, dynamic>{};
    for (final viewArguments in this) {
      extraArguments.addAll(viewArguments.toJson());
    }
    return RouteArguments.fromJson(extraArguments);
  }
}
