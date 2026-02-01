/// An abstract class representing a type of image.
sealed class TImageSeal {
  /// Creates a [TImageSeal].
  const TImageSeal({
    required this.imageLocation,
    required this.width,
    required this.height,
  });

  /// The location of the image.
  final String imageLocation;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;
}

/// A class representing a PNG image.
final class TImagePng extends TImageSeal {
  /// Creates a [TImagePng].
  const TImagePng({
    required super.imageLocation,
    super.width,
    super.height = 64,
  });
}

/// A class representing an SVG image.
final class TImageSvg extends TImageSeal {
  /// Creates a [TImageSvg].
  const TImageSvg({
    required super.imageLocation,
    super.width,
    super.height = 64,
  });
}
