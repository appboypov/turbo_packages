enum AuthViewMode {
  login,
  register,
  forgotPassword;

  static const defaultValue = AuthViewMode.login;

  bool get isLogin => this == AuthViewMode.login;
  bool get isRegister => this == AuthViewMode.register;
  bool get isForgotPassword => this == AuthViewMode.forgotPassword;
}
