import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:turbo_response/turbo_response.dart';

import '../constants/t_jev_limits.dart';
import '../constants/t_jev_messages.dart';
import '../models/t_jev_image.dart';
import 't_jev_answer.dart';

part '../models/t_jev_box.dart';
part '../models/t_jev_choice.dart';
part '../models/t_jev_noul.dart';
part '../models/t_jev_score.dart';

/// One typed judgment about the State, typed on its Answer [A].
///
/// A Question object is the key of its own Answer:
/// [TJevResult.answer] returns an [A] for it.
///
/// Instructions and descriptions are content: strings, numbers, booleans,
/// Images, maps with string keys, lists and objects with `toJson`.
sealed class TJevQuestion<A extends TJevAnswer> {
  const TJevQuestion({this.id});

  /// The id that keys this Question in its Request.
  ///
  /// Questions without an id get `q0`, `q1` and so on in Request order. Jev
  /// does not read ids, so an id only makes logged JSON easier to read.
  final String? id;

  /// Whether this Question can be asked: a success when it can, else a fail
  /// whose message names the rule it breaks.
  TurboResponse<void> validate();

  /// The key of [value] on the wire: the name of an enum value, else its
  /// `toString`.
  @internal
  static String wireKey(Object value) =>
      value is Enum ? value.name : value.toString();

  /// Whether [content] at [location] is JSON content without a non-finite
  /// number: a success when it is, else a fail whose message names what it
  /// holds.
  @internal
  static TurboResponse<void> checkContent(Object? content, String location) {
    switch (content) {
      case null || String() || bool() || TJevImage():
        return const TurboResponse.successAsBool();
      case num() when !content.isFinite:
        return TurboResponse.failAsBool(
          message: TJevMessages.nonFiniteNumber(location, content),
        );
      case num():
        return const TurboResponse.successAsBool();
      case List():
        for (final item in content) {
          final check = checkContent(item, location);
          if (check.isFail) return check;
        }
        return const TurboResponse.successAsBool();
      case Map():
        for (final MapEntry(:key, :value) in content.entries) {
          if (key is! String) {
            return TurboResponse.failAsBool(
              message: TJevMessages.nonStringMapKey(location, key),
            );
          }
          final check = checkContent(value, location);
          if (check.isFail) return check;
        }
        return const TurboResponse.successAsBool();
      default:
        try {
          jsonEncode(content);
          return const TurboResponse.successAsBool();
        } on JsonUnsupportedObjectError {
          return TurboResponse.failAsBool(
            message: TJevMessages.unencodableContent(
              location,
              content.runtimeType,
            ),
          );
        }
    }
  }

  /// The first fail of [checkContent] over each content with its location in
  /// [contents], else a success.
  static TurboResponse<void> _checkContents(
    Iterable<(Object?, String)> contents,
  ) {
    for (final (content, location) in contents) {
      final check = checkContent(content, location);
      if (check.isFail) return check;
    }
    return const TurboResponse.successAsBool();
  }
}
