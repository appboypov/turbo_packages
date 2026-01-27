import 'package:turbo_serializable/abstracts/t_writeable.dart';
import 'package:turbo_serializable/xml/typedefs/t_xml_typedefs.dart';

class TXmlFactory<T extends TWriteable> {
  final T writeable;

  final TXmlDocumentBuilder<T>? xmlDocumentBuilder;
  final TXmlBuilder<T>? xmlBuilder;

  TXmlFactory({
    required this.writeable,
    this.xmlDocumentBuilder,
    this.xmlBuilder,
  });

  TXmlDocument buildDocument({
    TXmlDocumentBuilder<T>? xmlDocumentBuilder,
  }) =>
      (xmlDocumentBuilder ?? this.xmlDocumentBuilder)?.call(writeable) ?? {};

  TXmlFile build({
    TXmlBuilder<T>? xmlBuilder,
  }) =>
      (xmlBuilder ?? this.xmlBuilder)
          ?.call(writeable, buildDocument()) ??
      '';
}
