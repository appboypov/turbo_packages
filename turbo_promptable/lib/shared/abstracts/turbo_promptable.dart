import 'package:turbo_promptable/turbo_promptable.dart';
import 'package:turbo_serializable/turbo_serializable.dart';

/// Base class for promptable objects in the turbo ecosystem.
///
/// Extends [TurboSerializable] with [MetaDataDto] as metadata to add
/// prompt-specific functionality including export configuration.
abstract class TurboPromptable extends TurboSerializable<MetaDataDto> {
  TurboPromptable({
    MetaDataDto? metaData,
    this.shouldExport = true,
    this.exportPathOverride,
    String? name,
    String? description,
  }) : super(
         metaData: name == null && description == null
             ? metaData
             : MetaDataDto(
                 name: name,
                 description: description,
               ),
       );

  final bool shouldExport;
  final String? exportPathOverride;
}
