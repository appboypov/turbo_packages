import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../constants/t_jev_http.dart';

part 't_jev_api_status_failure.dart';
part 't_jev_http_failure.dart';

/// Why a call to Jev failed in normal use.
///
/// [TJev] returns it as the error of a `TurboResponse` fail, so callers
/// switch on its type instead of catching exceptions.
sealed class TJevFailure {
  const TJevFailure();
}
