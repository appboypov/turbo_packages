import 'package:flutter/foundation.dart';
import 'package:turbo_mvvm/turbo_mvvm.dart';

TBusyModel get gBusyModel => TBusyService.instance().isBusyListenable.value;
ValueListenable<TBusyModel> get gIsBusyListenable => TBusyService.instance().isBusyListenable;
bool get gIsBusy => TBusyService.instance().isBusy;
void gSetIdle() => gSetBusy(isBusy: false);

void gSetBusy({
  bool isBusy = true,
  Duration minBusyDuration = TMVVMDurations.minBusy,
  String? busyMessage,
  String? busyTitle,
  TBusyType? busyType,
  Duration? timeoutDuration,
  VoidCallback? onTimeout,
  dynamic payload,
}) => TBusyService.instance().setBusy(
  isBusy,
  minBusyDuration: minBusyDuration,
  busyMessage: busyMessage,
  busyTitle: busyTitle,
  busyType: busyType,
  onTimeout: onTimeout,
  payload: payload,
  timeoutDuration: timeoutDuration,
);
