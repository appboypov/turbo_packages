import 'package:turbo_promptable/workspace/enums/t_body_type.dart';

/// What kind of content the body of a reference holds.
///
/// Separate from [TBodyType], which is the format a prompt part is written
/// in: material can also be a pdf, an image or a recording.
enum TContentType {
  json,
  yaml,
  md,
  html,
  mdx,
  text,
  pdf,
  url,
  image,
  audio,
  video,
  file,
}
