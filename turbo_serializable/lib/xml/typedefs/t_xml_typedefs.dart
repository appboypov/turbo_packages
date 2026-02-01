import 'package:turbo_serializable/abstracts/t_writeable.dart';

/// A map representing an XML document structure (root/structure used to produce XML).
typedef TXmlDocument = Map<String, dynamic>;

/// Signature for building an XML document from a TWriteable.
typedef TXmlDocumentBuilder<T extends TWriteable> =
    TXmlDocument Function(
      T writeable,
    );

/// A full XML file, represented as a String.
typedef TXmlFile = String;

/// Signature for building a complete XML file from a TWriteable and document.
typedef TXmlBuilder<T extends TWriteable> =
    TXmlFile Function(
      T writeable,
      TXmlDocument document,
    );
