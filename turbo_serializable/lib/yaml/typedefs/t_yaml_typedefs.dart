import 'package:turbo_serializable/abstracts/t_writeable.dart';

/// A map representing a YAML document in memory before stringification.
typedef TYamlDocument = Map<String, dynamic>;

/// Signature for building a YAML document from a TWriteable.
typedef TYamlDocumentBuilder<T extends TWriteable> =
    TYamlDocument Function(
      T writeable,
    );

/// A full YAML file, represented as a String.
typedef TYamlFile = String;

/// Signature for building a complete YAML file from a TWriteable and document.
typedef TYamlBuilder<T extends TWriteable> =
    TYamlFile Function(
      T writeable,
      TYamlDocument document,
    );
