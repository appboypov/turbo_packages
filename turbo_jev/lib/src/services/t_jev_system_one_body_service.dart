import 'dart:convert';

import 'package:turbo_response/turbo_response.dart';

import '../abstracts/t_jev_exception.dart';
import '../abstracts/t_jev_question.dart';
import '../abstracts/t_jev_question_dto.dart';
import '../constants/t_jev_http.dart';
import '../constants/t_jev_messages.dart';
import '../models/t_jev_image.dart';
import '../records/t_jev_system_one_body.dart';
import '../requests/t_jev_box_question_dto.dart';
import '../requests/t_jev_choice_question_dto.dart';
import '../requests/t_jev_image_part_dto.dart';
import '../requests/t_jev_noul_criteria_dto.dart';
import '../requests/t_jev_noul_question_dto.dart';
import '../requests/t_jev_score_question_dto.dart';
import '../requests/t_jev_system_one_assets_dto.dart';
import '../requests/t_jev_system_one_request_dto.dart';
import '../types/t_jev_model.dart';

/// Builds the body of a System One Request and checks its Questions, State
/// and Image References.
final class TJevSystemOneBodyService {
  const TJevSystemOneBodyService();

  // 🧲 FETCHERS

  /// The body of a Request that asks [model] the [questions], keyed by
  /// their ids, about [state], with [extraBody] merged last, and the Images
  /// it sends.
  ///
  /// The Images are those placed as objects anywhere in the content, also
  /// inside the `toJson` of another object, and those in [listed], each
  /// sent once for every Image Reference the JSON holds, in order of first
  /// use. Each gets the part name [TJevHttp.imagePartPrefix] with its number
  /// and an entry in `assets`. The body is encoded from the content once,
  /// so its `assets` name the very Images each `toJson` returned.
  ///
  /// Throws [TJevInvalidQuestionException] when a Question is invalid, or
  /// when the State or [extraBody] is no JSON content or holds a non-finite
  /// number, and [TJevImageReferenceException] when the JSON holds an Image
  /// Reference of no placed or listed Image, or when it uses no Image in
  /// [listed].
  TJevSystemOneBody build({
    required TJevModel model,
    required Object state,
    required Map<String, TJevQuestion> questions,
    required Map<String, Object?>? extraBody,
    required List<TJevImage> listed,
  }) {
    final request = TJevSystemOneRequestDto(
      model: model,
      state: state,
      questions: {
        for (final MapEntry(key: id, value: question) in questions.entries)
          id: _questionDto(id, question),
      },
    );
    for (final (content, location) in [
      (state, TJevMessages.stateLocation),
      (extraBody, TJevMessages.extraBodyLocation),
    ]) {
      if (TJevQuestion.checkContent(content, location) case Fail(
        :final message,
      )) {
        throw TJevInvalidQuestionException(message: message!);
      }
    }
    final known = <String, TJevImage>{};
    final json = TJevImage.collectEncoded(
      () => jsonEncode({...request.toJson(), ...?extraBody}),
      onEncoded: (image) => known[image.reference] = image,
    );
    for (final image in listed) {
      known[image.reference] = image;
    }
    final used = <String, TJevImage>{};
    final unknown = <String>{};
    for (final match in TJevHttp.imageReferencePattern.allMatches(json)) {
      final reference = match[0]!;
      final image = known[reference];
      if (image == null) {
        unknown.add(reference);
      } else {
        used[reference] = image;
      }
    }
    if (unknown.isNotEmpty) {
      throw TJevImageReferenceException(
        message: TJevMessages.unknownImageReferences(unknown),
      );
    }
    final unused = {
      for (final image in listed)
        if (!used.containsKey(image.reference)) image.reference,
    };
    if (unused.isNotEmpty) {
      throw TJevImageReferenceException(
        message: TJevMessages.unusedImages(unused),
      );
    }
    if (used.isEmpty) return (json: json, images: const {});
    final images = {
      for (final (number, image) in used.values.indexed)
        '${TJevHttp.imagePartPrefix}$number': image,
    };
    final assets = TJevSystemOneAssetsDto(
      assets: {
        for (final MapEntry(key: part, value: image) in images.entries)
          image.reference: TJevImagePartDto(part: part),
      },
    );
    return (
      // The encoded body goes last, so an `assets` field in extraBody wins.
      json: jsonEncode({
        ...assets.toJson(),
        ...jsonDecode(json) as Map<String, Object?>,
      }),
      images: images,
    );
  }

  // 🏗️ HELPERS

  /// The wire form of [question], which [id] keys in its Request.
  ///
  /// Throws [TJevInvalidQuestionException] when [question] is invalid.
  static TJevQuestionDto _questionDto(String id, TJevQuestion question) {
    if (question.validate() case Fail(:final message)) {
      throw TJevInvalidQuestionException(
        message: TJevMessages.invalidQuestion(
          question.runtimeType,
          id,
          message!,
        ),
      );
    }
    return switch (question) {
      TJevNoul(:final instructions, :final trueMeans, :final falseMeans) =>
        TJevNoulQuestionDto(
          instructions: instructions,
          criteria: trueMeans == null && falseMeans == null
              ? null
              : TJevNoulCriteriaDto(
                  trueMeans: trueMeans,
                  falseMeans: falseMeans,
                ),
        ),
      TJevChoice(:final instructions, :final options) => TJevChoiceQuestionDto(
        instructions: instructions,
        criteria: {
          for (final MapEntry(key: option, value: description)
              in options.entries)
            TJevQuestion.wireKey(option): description,
        },
      ),
      TJevScore(:final instructions, :final levels) => TJevScoreQuestionDto(
        instructions: instructions,
        criteria: levels.values.toList(),
      ),
      TJevBox(:final instructions) => TJevBoxQuestionDto(
        instructions: instructions,
      ),
    };
  }
}
