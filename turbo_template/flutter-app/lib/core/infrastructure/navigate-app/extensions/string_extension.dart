import 'package:turbo_flutter_template/core/infrastructure/navigate-app/constants/k_params.dart';

extension StringExtension on String {
  String get asRootPath => '/$this';

  String withId(String id) => replaceAll(kParamsId, id);
}
