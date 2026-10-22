import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../abstracts/t_jev_exception.dart';
import '../apis/t_jev_file_api.dart';
import '../constants/t_jev_http.dart';
import '../constants/t_jev_messages.dart';
import '../enums/t_jev_image_format.dart';
import '../utils/t_jev_random_hex.dart';

/// A PNG or JPEG picture sent with a Request.
///
/// Place an Image as a value anywhere in State, Instructions or Criteria and
/// it is sent under its [reference]. An Image interpolated in a string is
/// written as its [reference] and must be listed in the `images` of
/// [TJev.ask].
///
/// ```dart
/// final door = await TJevImage.fromFile('door-camera.jpg');
/// final badge = TJevImage.fromBase64(upload.badgeBase64);
///
/// await jev.ask(
///   state: {'door': door},
///   questions: [TJevNoul(instructions: 'Is the person in `door` $badge?')],
///   images: [badge],
/// );
/// ```
final class TJevImage {
  /// An Image of the file [bytes], copied now so later changes to [bytes]
  /// are not sent.
  ///
  /// Throws [TJevInvalidImageException] when [bytes] are empty or no PNG or
  /// JPEG file.
  TJevImage(List<int> bytes) : this._(Uint8List.fromList(bytes));

  TJevImage._(Uint8List bytes)
    : bytes = bytes.asUnmodifiableView(),
      format = _formatOf(bytes),
      reference =
          '${TJevHttp.imageReferencePrefix}'
          '${randomHex(TJevHttp.imageReferenceIdBytes)}'
          '${TJevHttp.imageReferenceSuffix}';

  /// An Image of the file bytes that [text] encodes in base64, without a
  /// `data:` URL prefix. Whitespace in [text] is ignored.
  ///
  /// Throws [TJevInvalidImageException] when [text] is no base64 or decodes
  /// to no PNG or JPEG file.
  factory TJevImage.fromBase64(String text) {
    final Uint8List bytes;
    try {
      bytes = base64.decode(text.replaceAll(_whitespace, ''));
    } on FormatException catch (error) {
      throw TJevInvalidImageException(
        message: TJevMessages.invalidBase64(error.message),
      );
    }
    return TJevImage._(bytes);
  }

  /// An Image of the file at [path].
  ///
  /// Throws [TJevInvalidImageException] when the file cannot be read, is
  /// empty or is no PNG or JPEG file. Reading a file needs `dart:io`; in a
  /// browser it cannot be read.
  static Future<TJevImage> fromFile(String path) async =>
      TJevImage(await const TJevFileApi().readBytes(path));

  /// Runs [encode] and calls [onEncoded] with each Image whose [toJson] it
  /// calls, so encoding content finds every Image placed in it, also inside
  /// the `toJson` of another object.
  @internal
  static R collectEncoded<R>(
    R Function() encode, {
    required void Function(TJevImage image) onEncoded,
  }) => runZoned(encode, zoneValues: {_onEncodedKey: onEncoded});

  /// The zone value that [collectEncoded] calls with each encoded Image.
  static final _onEncodedKey = Object();

  static final _whitespace = RegExp(r'\s');

  /// The file bytes.
  final Uint8List bytes;

  /// The format sniffed from the signature [bytes] start with.
  final TJevImageFormat format;

  /// The Image Reference this Image is sent under: `<image:` with 32 random
  /// lowercase hex digits and `>`.
  final String reference;

  /// The [reference], which `jsonEncode` writes wherever this Image is
  /// placed.
  String toJson() {
    if (Zone.current[_onEncodedKey]
        case final void Function(
              TJevImage image,
            )
            onEncoded) {
      onEncoded(this);
    }
    return reference;
  }

  /// The [reference], which string interpolation writes wherever this Image
  /// is placed.
  @override
  String toString() => reference;

  /// The format whose signature [bytes] start with.
  ///
  /// Throws [TJevInvalidImageException] when [bytes] are empty or start with
  /// no signature of a [TJevImageFormat].
  static TJevImageFormat _formatOf(Uint8List bytes) {
    if (bytes.isEmpty) {
      throw const TJevInvalidImageException(message: TJevMessages.emptyImage);
    }
    for (final format in TJevImageFormat.values) {
      final signature = format.signature;
      if (bytes.length >= signature.length &&
          signature.indexed.every((entry) => bytes[entry.$1] == entry.$2)) {
        return format;
      }
    }
    throw const TJevInvalidImageException(
      message: TJevMessages.unknownImageFormat,
    );
  }
}
