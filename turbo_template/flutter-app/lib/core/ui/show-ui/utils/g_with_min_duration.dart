import 'dart:async';

import 'package:turbo_flutter_template/core/state/manage-state/utils/min_duration_completer.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';

Future<void> withMinDuration({
  required Future<void> Function(Future minDuration) action,
  Duration minDuration = TDurations.animation,
}) async {
  final minDurationCompleter = MinDurationCompleter(minDuration)..start();
  await action(minDurationCompleter.future);
}
