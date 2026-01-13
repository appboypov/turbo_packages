import 'package:go_router/go_router.dart';
import 'package:turbo_flutter_template/core/storage/manage-data/constants/data_keys.dart';

class ExtraArguments {
  ExtraArguments({this.id});

  final String? id;

  Map<String, dynamic> toMap() {
    return {if (id != null) DataKeys.id: id};
  }

  factory ExtraArguments.fromMap(Map<String, dynamic> map) {
    return ExtraArguments(id: map[DataKeys.id] as String?);
  }
}

extension GoRouterStateExtension on GoRouterState {
  ExtraArguments? arguments() {
    if (extra is ExtraArguments) {
      return extra as ExtraArguments;
    }
    return null;
  }

  String? get id => _id(DataKeys.id) ?? arguments()?.toMap()[DataKeys.id];

  String? _id(String key) => pathParameters[key] ?? uri.queryParameters[key];
}
