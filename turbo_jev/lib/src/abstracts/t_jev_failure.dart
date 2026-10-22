import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../constants/t_jev_http.dart';
import '../constants/t_jev_limits.dart';
import '../constants/t_jev_messages.dart';
import '../models/t_jev_validation_detail.dart';
import '../records/t_jev_response_fields.dart';
import '../responses/t_jev_validation_error_dto.dart';
import '../services/t_jev_retry_after_service.dart';

part '../results/t_jev_aborted_failure.dart';
part '../results/t_jev_authentication_failure.dart';
part '../results/t_jev_bad_request_failure.dart';
part '../results/t_jev_connection_failure.dart';
part '../results/t_jev_http_failure.dart';
part '../results/t_jev_internal_server_failure.dart';
part '../results/t_jev_not_found_failure.dart';
part '../results/t_jev_other_status_failure.dart';
part '../results/t_jev_permission_denied_failure.dart';
part '../results/t_jev_rate_limit_failure.dart';
part '../results/t_jev_response_validation_failure.dart';
part '../results/t_jev_timeout_failure.dart';
part '../results/t_jev_unprocessable_entity_failure.dart';

/// Why a Request to Jev failed in normal use.
///
/// [TJev] returns it as the error of a `TurboResponse` fail, with its
/// [message] as the message of that fail, so callers switch on its type
/// instead of catching exceptions.
sealed class TJevFailure {
  const TJevFailure();

  // 🧲 FETCHERS

  /// What went wrong, in words.
  String get message;
}
