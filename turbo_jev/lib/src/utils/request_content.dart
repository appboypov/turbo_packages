import 'dart:convert';
import 'dart:typed_data';

import '../constants/t_jev_http.dart';
import '../models/t_jev_image.dart';
import 'random_hex.dart';

/// The bytes of a Request body before compression and their media type.
typedef _RequestContent = ({List<int> bytes, String contentType});

/// The content of a Request body: the [json] text as is, or a multipart body
/// (RFC 7578) when there are [images].
///
/// A multipart body holds the [json] in its first part, named
/// [TJevHttp.requestPartName], and then each Image in a part of the name it
/// has in [images], with its sniffed content type.
_RequestContent requestContent({
  required String json,
  required Map<String, TJevImage> images,
}) {
  if (images.isEmpty) {
    return (bytes: utf8.encode(json), contentType: TJevHttp.jsonMediaType);
  }
  // A random boundary, as browsers use, practically never occurs in a part.
  final boundary = randomHex();
  final bytes = BytesBuilder(copy: false);
  void addPart({
    required String disposition,
    required String contentType,
    required List<int> content,
  }) => bytes
    ..add(
      utf8.encode(
        '--$boundary\r\n'
        'Content-Disposition: form-data; $disposition\r\n'
        'Content-Type: $contentType\r\n\r\n',
      ),
    )
    ..add(content)
    ..add(utf8.encode('\r\n'));

  addPart(
    disposition: 'name="${TJevHttp.requestPartName}"',
    contentType: TJevHttp.jsonMediaType,
    content: utf8.encode(json),
  );
  for (final MapEntry(key: name, value: image) in images.entries) {
    addPart(
      disposition: 'name="$name"; filename="$name"',
      contentType: image.format.contentType,
      content: image.bytes,
    );
  }
  bytes.add(utf8.encode('--$boundary--\r\n'));
  return (
    bytes: bytes.takeBytes(),
    contentType: '${TJevHttp.multipartMediaType}; boundary=$boundary',
  );
}
