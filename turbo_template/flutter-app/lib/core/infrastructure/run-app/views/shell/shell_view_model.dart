import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/services/auth_service.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/enums/view_type.dart';
import 'package:turbo_flutter_template/core/state/manage-state/abstracts/t_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/typedefs/lazy_locator_def.dart';
import 'package:turbo_notifiers/turbo_notifiers.dart';
import 'package:turbolytics/turbolytics.dart';

class ShellViewModel extends TViewModel with Turbolytics {
  ShellViewModel({required LazyLocatorDef<AuthService> authService}) : _authService = authService {
    _initialise();
  }

  static ShellViewModel get locate => GetIt.I.get();
  static void registerFactory() =>
      GetIt.I.registerFactory(() => ShellViewModel(authService: () => AuthService.locate));

  final LazyLocatorDef<AuthService> _authService;
  final _viewType = TNotifier<ViewType>(ViewType.defaultValue);

  void _initialise() {
    _authService().hasAuth.addListener(_onAuthStateChanged);
    _onAuthStateChanged();
  }

  @override
  void dispose() {
    _authService().hasAuth.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  void _onAuthStateChanged() {
    final hasAuth = _authService().hasAuth.value;
    final newViewType = hasAuth ? ViewType.home : ViewType.auth;
    if (_viewType.value != newViewType) {
      _viewType.update(newViewType);
      log.debug('ViewType updated to: $newViewType');
    }
  }

  ValueListenable<ViewType> get viewType => _viewType;
}
