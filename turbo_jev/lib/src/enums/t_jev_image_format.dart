/// A file format TypeSafe accepts for an Image, recognised by the signature
/// its file starts with.
enum TJevImageFormat {
  /// PNG, whose files start with the signature of the PNG spec §5.2.
  png(
    contentType: 'image/png',
    signature: [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a],
  ),

  /// JPEG, whose files start with the start-of-image marker of ITU T.81.
  jpeg(contentType: 'image/jpeg', signature: [0xff, 0xd8, 0xff]);

  const TJevImageFormat({required this.contentType, required this.signature});

  // 🎩 STATE

  /// The media type of the format, sent with an Image's multipart part.
  final String contentType;

  /// The bytes every file of the format starts with.
  final List<int> signature;
}
