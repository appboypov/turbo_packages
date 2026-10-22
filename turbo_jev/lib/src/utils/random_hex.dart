import 'dart:math';

final _random = Random.secure();

/// [byteCount] random bytes as twice as many lowercase hex digits.
String randomHex(int byteCount) => [
  for (var i = 0; i < byteCount; i++)
    _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
].join();
