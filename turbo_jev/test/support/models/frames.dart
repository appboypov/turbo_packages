import 'package:turbo_jev/turbo_jev.dart';

/// A model whose `toJson` holds Images.
final class Frames {
  const Frames(this.frames);

  final List<TJevImage> frames;

  List<TJevImage> toJson() => frames;
}
