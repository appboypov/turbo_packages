import 'package:turbo_flutter_template/core/shared/constants/t_keys.dart';
import 'package:turbo_serializable/turbo_serializable.dart';

class CreateUsernameRequest extends TWriteable {
  CreateUsernameRequest({required this.userId});

  final String userId;

  @override
  Map<String, dynamic> toJson() => {TKeys.userId: userId};
}
