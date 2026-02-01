enum AnimationTiming {
  before,
  after
  ;

  bool get isBefore => this == AnimationTiming.before;
  bool get isAfter => this == AnimationTiming.after;
}
