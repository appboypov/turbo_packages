import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// A fake TypeSafe service that records each Request and answers with
/// [respond], by default with a Noul Answer of 0.9 to every Question.
class FakeTypeSafe {
  FakeTypeSafe({http.Response Function(http.Request request)? respond})
    : _respond = respond ?? _answerEveryQuestion;

  final http.Response Function(http.Request request) _respond;

  final List<http.Request> requests = [];

  late final http.Client client = MockClient((request) async {
    requests.add(request);
    return _respond(request);
  });

  http.Request get lastRequest => requests.last;

  Map<String, Object?> get lastBody =>
      jsonDecode(lastRequest.body) as Map<String, Object?>;

  static http.Response _answerEveryQuestion(http.Request request) {
    final body = jsonDecode(request.body) as Map<String, Object?>;
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
