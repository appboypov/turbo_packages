import 'package:turbo_promptable/turbo_promptable.dart';
import 'package:turbo_serializable/turbo_serializable.dart';

/// Base class for promptable objects in the turbo ecosystem.
///
/// Extends [TSerializable] with [MetaDataDto] as metadata to add
/// prompt-specific functionality including export configuration.
abstract class TurboPromptable extends TSerializable {
  TurboPromptable({
    MetaDataDto? metaData,
    String? description,
    String? name,
  }) : super();

  final String name;
  final String description;
}
