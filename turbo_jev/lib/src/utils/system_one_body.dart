import 'dart:convert';

import '../constants/t_jev_http.dart';
import '../exceptions/t_jev_image_reference_exception.dart';
import '../models/t_jev_image.dart';
import '../records/t_jev_system_one_body.dart';
import '../requests/t_jev_image_part_dto.dart';
import '../requests/t_jev_system_one_request_dto.dart';

/// The body of [request] with [extraBody] merged last, and the Images it
/// sends.
///
/// The Images are those placed as values in the maps and lists of the
/// content and those in [listed], each sent once for every Image Reference
/// the JSON holds, in order of first use. Each gets the part name
/// [TJevHttp.imagePartPrefix] with its number and an entry in `assets`.
///
/// Throws [TJevImageReferenceException] when the JSON holds an Image
/// Reference of no placed or listed Image, or when it uses no Image in
/// [listed].
TJevSystemOneBody systemOneBody({
  required TJevSystemOneRequestDto request,
  required Map<String, Object?>? extraBody,
  required List<TJevImage> listed,
}) {
  final known = <String, TJevImage>{};
  final content = {...request.toJson(), ...?extraBody};
  _addPlacedImages(content, known);
  for (final image in listed) {
    known[image.reference] = image;
  }
  final json = jsonEncode(content);
  final used = <String, TJevImage>{};
  final unknown = <String>{};
  for (final match in TJevImage.referencePattern.allMatches(json)) {
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
      reason:
          'The content holds the Image References ${unknown.join(', ')} of '
          'no known Image. List each Image interpolated in a string in images.',
    );
  }
  final unused = {
    for (final image in listed)
      if (!used.containsKey(image.reference)) image.reference,
  };
  if (unused.isNotEmpty) {
    throw TJevImageReferenceException(
      reason:
          'No content uses the listed Images ${unused.join(', ')}. Interpolate '
          'each listed Image in a string of the State, Instructions or '
          'Criteria.',
    );
  }
  if (used.isEmpty) return (json: json, images: const {});
  final images = {
    for (final (number, image) in used.values.indexed)
      '${TJevHttp.imagePartPrefix}$number': image,
  };
  final withAssets = TJevSystemOneRequestDto(
    model: request.model,
    state: request.state,
    questions: request.questions,
    assets: {
      for (final MapEntry(key: part, value: image) in images.entries)
        image.reference: TJevImagePartDto(part: part),
    },
  );
  return (
    json: jsonEncode({...withAssets.toJson(), ...?extraBody}),
    images: images,
  );
}

/// Adds each Image placed as a value in the maps and lists of [content] to
/// [images] under its reference.
void _addPlacedImages(Object? content, Map<String, TJevImage> images) {
  switch (content) {
    case TJevImage():
      images[content.reference] = content;
    case Map():
      for (final value in content.values) {
        _addPlacedImages(value, images);
      }
    case List():
      for (final item in content) {
        _addPlacedImages(item, images);
      }
  }
}
