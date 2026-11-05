import 'package:json_annotation/json_annotation.dart';
import 'package:turbo_promptable/triggers/dtos/t_trigger_hit_dto.dart';

part 't_trigger_contents.g.dart';

/// A fired trigger: every hit of one kind in the watched folders.
///
/// [toString] is the whole trigger body in `<trigger>` tags.
@JsonSerializable(explicitToJson: true)
class TTriggerContents {
  const TTriggerContents({
    required this.kind,
    required this.hits,
    this.instructions,
  });

  factory TTriggerContents.fromJson(Map<String, dynamic> json) =>
      _$TTriggerContentsFromJson(json);

  /// Id of the fired kind.
  final String kind;

  /// Finished and open hits of [kind].
  final List<TTriggerHitDto> hits;

  /// Instructions of the fired kind, rendered in `<user_instructions>` right
  /// after the opening tag. None when null.
  final String? instructions;

  Map<String, dynamic> toJson() => _$TTriggerContentsToJson(this);

  @override
  String toString() {
    final buffer = StringBuffer()..writeln("<trigger kind='$kind'>");
    if (instructions case final text?) {
      buffer.writeln('<user_instructions>$text</user_instructions>');
    }
    buffer.writeln('<hits>');
    for (final hit in hits) {
      buffer.write("<hit file='${hit.file}' line='${hit.line}'");
      if (hit.isOpen) buffer.write(" open='true'");
      buffer.writeln('>${hit.text}</hit>');
    }
    buffer.writeln('</hits>');
    buffer.write('</trigger>');
    return buffer.toString();
  }
}
