import 'package:turbo_promptable/turbo_promptable.dart';
import 'package:turbo_serializable/turbo_serializable.dart';

/// Base class for promptable objects in the turbo ecosystem.
///
/// Extends [TurboSerializable] with [MetaDataDto] as metadata to add
/// prompt-specific functionality including export configuration.
abstract class TurboPromptable extends TurboSerializable<MetaDataDto> {
  TurboPromptable({
    MetaDataDto? metaData,
    String? description,
    String? name,
    TurboSerializableConfig? config,
    this.exportPathOverride,
    this.includeMetaData = true,
    this.includeNulls = false,
    this.shouldExport = true,
  }) : super(
          config: config ??
              TurboSerializableConfig(
                toJson: (instance) => (instance as TurboPromptable).toJsonMap(),
              ),
          metaData: name == null && description == null
              ? metaData
              : MetaDataDto(
                  name: name,
                  description: description,
                ),
        );

  final String? exportPathOverride;
  final bool includeMetaData;
  final bool includeNulls;
  final bool shouldExport;

  /// Override this method to provide JSON serialization for the DTO.
  ///
  /// This method is called by the default [TurboSerializableConfig] toJson callback.
  /// Subclasses should implement this to call their generated `_$XxxDtoToJson(this)` method.
  Map<String, dynamic>? toJsonMap();
}
