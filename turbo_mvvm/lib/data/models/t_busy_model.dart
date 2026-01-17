import '../enums/t_busy_type.dart';

/// A model to represent the busy state of an application or component.
///
/// Includes busy state, optional title and message, and the type of busy indicator.
class TBusyModel {
  /// Creates an instance of [TBusyModel].
  ///
  /// [isBusy] Indicates if the application or component is busy.
  /// [busyTitle] Optional title to display while busy.
  /// [busyMessage] Optional message to display while busy.
  /// [busyType] Specifies the type of busy indicator to display.
  /// [payload] Optional payload to be used with the busy model.
  const TBusyModel({
    required this.isBusy,
    required this.busyTitle,
    required this.busyMessage,
    required this.busyType,
    required dynamic payload,
  }) : _payload = payload;

  /// Indicates if the application or component is currently busy.
  final bool isBusy;

  /// Optional title to be displayed when the application or component is busy.
  final String? busyTitle;

  /// Optional message to be displayed when the application or component is busy.
  final String? busyMessage;

  /// Type of busy indicator to display.
  final TBusyType busyType;

  /// Optional payload to be used with the busy model.
  final dynamic _payload;

  /// Getter + caster for the payload. Use with caution!
  E payload<E>() => _payload as E;
}
