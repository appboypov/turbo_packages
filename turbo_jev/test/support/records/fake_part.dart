/// One part of a multipart Request body.
typedef FakePart = ({
  String name,
  String? filename,
  String? contentType,
  List<int> bytes,
});
