import 'package:connectivity_plus/connectivity_plus.dart';

extension ConnectivityResultExtension on List<ConnectivityResult> {
  bool get hasPhoneConnection =>
      !contains(ConnectivityResult.none) &&
      (contains(ConnectivityResult.mobile) || contains(ConnectivityResult.wifi));
}
