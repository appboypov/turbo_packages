enum TDeviceType {
  mobile,
  tablet,
  desktop;

  bool get isMobile => this == TDeviceType.mobile;
  bool get isTabletDesktop => this == TDeviceType.tablet;
  bool get isDesktop => this == TDeviceType.desktop;
  bool get isNotMobile => !isMobile;

  static const Set<TDeviceType> all = {...TDeviceType.values};
}
