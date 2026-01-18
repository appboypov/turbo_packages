import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/abstracts/base_navigation.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/services/base_router_service.dart';
import 'package:turbo_flutter_template/core/shared/extensions/string_extension.dart';

class AuthStepRouter extends BaseNavigation {
  @override
  String get root => '/';

  void goAcceptPrivacyView() {
    // TODO: Implement when AcceptPrivacyView is created
    // go(location: AcceptPrivacyView.path.asRootPath);
  }

  void goVerifyEmailView() {
    // TODO: Implement when VerifyEmailView is created
    BaseRouterService.locate.context.go('/verify-email'.asRootPath);
  }

  void goCreateUsernameView() {
    // TODO: Implement when CreateUsernameView is created
    // go(location: CreateUsernameView.path.asRootPath);
  }

  static AuthStepRouter get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(AuthStepRouter.new);
}
