import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/triggers/dtos/t_trigger_hit_dto.dart';

part 't_trigger_contents.g.dart';

/// A fired trigger: every hit of one kind in the watched folders and the
/// rendered context of the files that hold them.
///
/// [toString] is the whole trigger body in `<trigger>` tags.
@JsonSerializable(explicitToJson: true)
class TTriggerContents {
  const TTriggerContents({
    required this.kind,
    required this.hits,
    this.context = '',
  });

  factory TTriggerContents.fromJson(Map<String, dynamic> json) =>
      _$TTriggerContentsFromJson(json);

  /// Id of the fired kind.
  final String kind;

  /// Finished and open hits of [kind].
  final List<TTriggerHitDto> hits;

  /// File tree and codemaps of the hit files, as rendered by the context
  /// engine. Empty when rendering failed.
  final String context;

  Map<String, dynamic> toJson() => _$TTriggerContentsToJson(this);

  @override
  String toString() {
    final buffer = StringBuffer()
      ..writeln("<trigger kind='$kind'>")
      ..writeln('<hits>');
    for (final hit in hits) {
      buffer.write("<hit file='${hit.file}' line='${hit.line}'");
      if (hit.isOpen) buffer.write(" open='true'");
      buffer.writeln('>${hit.text}</hit>');
    }
    buffer.writeln('</hits>');
    if (context.isNotEmpty) buffer.writeln(context.trimRight());
    buffer.write('</trigger>');
    return buffer.toString();
  }
}
