import 'package:turbo_serializable/abstracts/t_writeable.dart';
import 'package:turbo_serializable/yaml/typedefs/t_yaml_typedefs.dart';

class TYamlFactory<T extends TWriteable> {
  final T writeable;

  final TYamlDocumentBuilder<T>? yamlDocumentBuilder;
  final TYamlBuilder<T>? yamlBuilder;

  TYamlFactory({
    required this.writeable,
    this.yamlDocumentBuilder,
    this.yamlBuilder,
  });

  TYamlDocument buildDocument({
    TYamlDocumentBuilder<T>? yamlDocumentBuilder,
  }) =>
      (yamlDocumentBuilder ?? this.yamlDocumentBuilder)?.call(writeable) ?? {};

  TYamlFile build({
    TYamlBuilder<T>? yamlBuilder,
  }) =>
      (yamlBuilder ?? this.yamlBuilder)?.call(writeable, buildDocument()) ?? '';
}
