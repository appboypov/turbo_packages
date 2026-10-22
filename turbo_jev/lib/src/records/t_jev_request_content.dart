/// The bytes of a Request body before compression and their media type, with
/// the JSON of the Request at bytes `jsonStart` up to `jsonEnd`: the whole
/// body when it is JSON, its `request` part when it is multipart.
typedef TJevRequestContent = ({
  List<int> bytes,
  String contentType,
  int jsonStart,
  int jsonEnd,
});
