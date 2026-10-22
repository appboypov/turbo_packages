import '../models/t_jev_image.dart';

/// The JSON text of a System One Request and the Images it sends, keyed by
/// the name of the multipart part that holds each.
typedef TJevSystemOneBody = ({String json, Map<String, TJevImage> images});
