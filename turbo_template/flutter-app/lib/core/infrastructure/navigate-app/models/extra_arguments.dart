import 'package:go_router/go_router.dart';
import 'package:turbo_flutter_template/core/shared/constants/t_keys.dart';
import 'package:turbo_flutter_template/core/shared/extensions/object_extension.dart';

class ExtraArguments {
  ExtraArguments({
    this.messageId,
    this.id,
    this.prefilledCode,
  });

  final String? messageId;
  final String? id;
  final String? prefilledCode;

  Map<String, dynamic> toMap() {
    return {
      if (id != null) TKeys.id: id,
      if (messageId != null) TKeys.messageId: messageId,
      if (prefilledCode != null) TKeys.prefilledCode: prefilledCode,
    };
  }

  factory ExtraArguments.fromMap(Map<String, dynamic> map) {
    return ExtraArguments(
      messageId: map[TKeys.messageId] as String?,
      id: map[TKeys.id] as String?,
      prefilledCode: map['prefilledCode'] as String?,
    );
  }
}

extension GoRouterStateExtension on GoRouterState {
  ExtraArguments? arguments() => extra?.asType<ExtraArguments>();
  String? get id => _id(TKeys.id) ?? arguments()?.toMap()[TKeys.id];
  String? get messageId => _id(TKeys.messageId) ?? arguments()?.messageId;
  String? get prefilledCode => arguments()?.prefilledCode;

  String? _id(String key) => pathParameters[key] ?? uri.queryParameters[key];
}
