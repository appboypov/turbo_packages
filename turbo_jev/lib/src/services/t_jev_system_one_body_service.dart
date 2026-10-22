import 'dart:convert';

import '../abstracts/t_jev_question.dart';
import '../constants/t_jev_http.dart';
import '../constants/t_jev_messages.dart';
import '../exceptions/t_jev_image_reference_exception.dart';
import '../exceptions/t_jev_invalid_question_exception.dart';
import '../models/t_jev_image.dart';
import '../requests/t_jev_image_part_dto.dart';
import '../requests/t_jev_system_one_assets_dto.dart';
import '../requests/t_jev_system_one_request_dto.dart';

/// The JSON text of a System One Request and the Images it sends, keyed by
/// the name of the multipart part that holds each.
typedef _SystemOneBody = ({String json, Map<String, TJevImage> images});

/// Builds the body of a System One Request and checks its State and Image
/// References.
final class TJevSystemOneBodyService {
  const TJevSystemOneBodyService();

  /// The body of [request] with [extraBody] merged last, and the Images it
  /// sends.
  ///
  /// The Images are those placed as objects anywhere in the content, also
  /// inside the `toJson` of another object, and those in [listed], each
  /// sent once for every Image Reference the JSON holds, in order of first
  /// use. Each gets the part name [TJevHttp.imagePartPrefix] with its number
  /// and an entry in `assets`. The body is encoded from the content once,
  /// so its `assets` name the very Images each `toJson` returned.
  ///
  /// Throws [TJevInvalidQuestionException] when the State is no JSON
  /// content or holds a non-finite number, and [TJevImageReferenceException]
  /// when the JSON holds an Image Reference of no placed or listed Image, or
  /// when it uses no Image in [listed].
  _SystemOneBody build({
    required TJevSystemOneRequestDto request,
    required Map<String, Object?>? extraBody,
    required List<TJevImage> listed,
  }) {
    TJevQuestion.checkContent(request.state, TJevMessages.stateLocation);
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
        reason: TJevMessages.unknownImageReferences(unknown),
      );
    }
    final unused = {
      for (final image in listed)
        if (!used.containsKey(image.reference)) image.reference,
    };
    if (unused.isNotEmpty) {
      throw TJevImageReferenceException(
        reason: TJevMessages.unusedImages(unused),
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
}
