import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:http_parser/http_parser.dart';

import '../records/fake_part.dart';

/// A fake TypeSafe service that records each Request and answers with
/// [respond], by default with a Noul Answer of 0.9 to every Question.
class FakeTypeSafe {
  FakeTypeSafe({http.Response Function(http.Request request)? respond})
    : _respond = respond ?? _answerEveryQuestion;

  /// A fake TypeSafe service that answers the Requests in order with
  /// [responses] and every later Request with the last of them.
  factory FakeTypeSafe.answering(List<http.Response> responses) {
    var next = 0;
    return FakeTypeSafe(
      respond: (_) => responses[min(next++, responses.length - 1)],
    );
  }

  final http.Response Function(http.Request request) _respond;

  final List<http.Request> requests = [];

  late final http.Client client = MockClient((request) async {
    requests.add(request);
    return _respond(request);
  });

  http.Request get lastRequest => requests.last;

  Map<String, Object?> get lastBody => bodyOf(lastRequest);

  /// The JSON body of [request], or of its `request` part when it is
  /// multipart, decompressed when it is gzip encoded.
  static Map<String, Object?> bodyOf(http.Request request) {
    final bytes = isMultipart(request)
        ? partsOf(request).firstWhere((part) => part.name == 'request').bytes
        : _decodedBytes(request);
    return jsonDecode(utf8.decode(bytes)) as Map<String, Object?>;
  }

  /// Whether [request] sends a multipart body.
  static bool isMultipart(http.Request request) =>
      MediaType.parse(request.headers['Content-Type']!).mimeType ==
      'multipart/form-data';

  /// The parts of the multipart body of [request], in body order.
  static List<FakePart> partsOf(http.Request request) {
    final boundary = MediaType.parse(
      request.headers['Content-Type']!,
    ).parameters['boundary']!;
    // Latin-1 maps each byte to one character, so part bytes survive as is.
    final body = latin1.decode(_decodedBytes(request));
    final sections = body.split('--$boundary');
    if (sections.first.isNotEmpty || sections.last != '--\r\n') {
      throw FormatException('The body is no multipart body: $body');
    }
    return [
      for (final section in sections.sublist(1, sections.length - 1))
        _partOf(section),
    ];
  }

  static FakePart _partOf(String section) {
    final headerEnd = section.indexOf('\r\n\r\n');
    final headers = {
      for (final line in section.substring(2, headerEnd).split('\r\n'))
        line.substring(0, line.indexOf(':')).toLowerCase(): line
            .substring(line.indexOf(':') + 1)
            .trim(),
    };
    final disposition = headers['content-disposition']!;
    String? parameter(String name) =>
        RegExp('$name="([^"]*)"').firstMatch(disposition)?.group(1);
    return (
      name: parameter('name')!,
      filename: parameter('filename'),
      contentType: headers['content-type'],
      bytes: latin1.encode(
        section.substring(headerEnd + 4, section.length - 2),
      ),
    );
  }

  static List<int> _decodedBytes(http.Request request) =>
      request.headers['Content-Encoding'] == 'gzip'
      ? gzip.decode(request.bodyBytes)
      : request.bodyBytes;

  static http.Response _answerEveryQuestion(http.Request request) {
    final body = bodyOf(request);
    final questions = body['questions']! as Map<String, Object?>;
    return noulResponse(nouls: {for (final id in questions.keys) id: 0.9});
  }

  /// A 200 response holding one Noul Answer per id in [nouls].
  static http.Response noulResponse({
    required Map<String, double> nouls,
    String model = 'jev-1.13.0',
    Map<String, Object?> usage = const {
      'input_tokens': 120,
      'output_tokens': 12,
    },
    Map<String, String> headers = const {
      'x-typesafe-request-id': 'req_123',
    },
  }) => http.Response(
    jsonEncode({
      'model': model,
      'answers': {
        for (final MapEntry(:key, :value) in nouls.entries)
          key: {'type': 'noul', 'noul': value},
      },
      'usage': usage,
    }),
    200,
    headers: {'content-type': 'application/json', ...headers},
  );
}
