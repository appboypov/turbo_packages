import 'package:turbo_jev/turbo_jev.dart';

import '../constants/jpeg_bytes.dart';

/// A model whose `toJson` creates a new Image each time it runs.
final class Snapshot {
  const Snapshot();

  List<TJevImage> toJson() => [TJevImage(jpegBytes)];
}
