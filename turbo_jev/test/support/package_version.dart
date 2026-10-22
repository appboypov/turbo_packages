import 'dart:io';

/// The version in `pubspec.yaml`, which the SDK id headers must carry.
final String packageVersion = RegExp(
  r'^version:\s*(\S+)',
  multiLine: true,
).firstMatch(File('pubspec.yaml').readAsStringSync())!.group(1)!;
