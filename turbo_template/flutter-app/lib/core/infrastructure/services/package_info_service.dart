import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoService {
  Future<String> get version async => (await PackageInfo.fromPlatform()).version;
}
