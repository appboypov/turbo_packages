import 'dart:convert';
import 'dart:typed_data';

import '../constants/t_jev_http.dart';
import '../models/t_jev_image.dart';
import '../records/t_jev_request_content.dart';
import 'random_hex.dart';

/// The content of a Request body: the [json] text as is, or a multipart body
/// (RFC 7578) when there are [images].
///
/// A multipart body holds the [json] in its first part, named
/// [TJevHttp.requestPartName], and then each Image in a part of the name it
/// has in [images], with its sniffed content type.
TJevRequestContent requestContent({
  required String json,
  required Map<String, TJevImage> images,
}) {
  final jsonBytes = utf8.encode(json);
  if (images.isEmpty) {
    return (
      bytes: jsonBytes,
      contentType: TJevHttp.jsonMediaType,
      jsonStart: 0,
      jsonEnd: jsonBytes.length,
    );
  }
  // A random boundary, as browsers use, practically never occurs in a part.
  final boundary = randomHex(TJevHttp.boundaryBytes);
  final delimiter = '${TJevHttp.boundaryDelimiter}$boundary';
  final bytes = BytesBuilder(copy: false);

  /// Adds a part holding [content] and returns the offset of its content.
  int addPart({
    required String disposition,
    required String contentType,
    required List<int> content,
  }) {
    bytes.add(
      utf8.encode(
        '$delimiter${TJevHttp.lineBreak}'
        '${TJevHttp.contentDispositionHeader}: '
        '${TJevHttp.formDataDisposition}; $disposition${TJevHttp.lineBreak}'
        '${TJevHttp.contentTypeHeader}: $contentType'
        '${TJevHttp.lineBreak}${TJevHttp.lineBreak}',
      ),
    );
    final contentStart = bytes.length;
    bytes
      ..add(content)
      ..add(utf8.encode(TJevHttp.lineBreak));
    return contentStart;
  }

  final jsonStart = addPart(
    disposition: '${TJevHttp.nameParameter}="${TJevHttp.requestPartName}"',
    contentType: TJevHttp.jsonMediaType,
    content: jsonBytes,
  );
  for (final MapEntry(key: name, value: image) in images.entries) {
    addPart(
      disposition:
          '${TJevHttp.nameParameter}="$name"; '
          '${TJevHttp.filenameParameter}="$name"',
      contentType: image.format.contentType,
      content: image.bytes,
    );
  }
  bytes.add(
    utf8.encode('$delimiter${TJevHttp.boundaryDelimiter}${TJevHttp.lineBreak}'),
  );
  return (
    bytes: bytes.takeBytes(),
    contentType:
        '${TJevHttp.multipartMediaType}; '
        '${TJevHttp.boundaryParameter}=$boundary',
    jsonStart: jsonStart,
    jsonEnd: jsonStart + jsonBytes.length,
  );
}
