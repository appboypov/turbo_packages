import 'dart:math';

final _random = Random.secure();

/// 32 random lowercase hex digits.
String randomHex() => [
  for (var i = 0; i < 16; i++)
    _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
].join();
