@TestOn('vm')
library;

import 'dart:io';

import 'package:test/test.dart';

/// Matches a Dart code block of the README and captures its code.
final _dartBlock = RegExp(r'```dart\n(.*?)```', dotAll: true);

/// Matches a region of a sample file and captures its name and code.
final _region = RegExp(
  r'^ *// #docregion (\S+)\n(.*?)^ *// #enddocregion \1$',
  multiLine: true,
  dotAll: true,
);

/// The Dart code blocks of the README, in order.
List<String> _readmeBlocks() => [
  for (final match in _dartBlock.allMatches(
    File('README.md').readAsStringSync(),
  ))
    match[1]!.trimRight(),
];

/// The code of each region in `test/readme`, by region name.
///
/// The analyzer checks these files, so each region compiles in its context.
Map<String, String> _sampleRegions() => {
  for (final file in Directory('test/readme').listSync().whereType<File>())
    for (final match in _region.allMatches(file.readAsStringSync()))
      match[1]!: _dedent(match[2]!),
};

/// [code] without the indentation its lines share.
String _dedent(String code) {
  final lines = code.trimRight().split('\n');
  final indent = lines
      .where((line) => line.trim().isNotEmpty)
      .map((line) => line.length - line.trimLeft().length)
      .reduce((shortest, length) => length < shortest ? length : shortest);
  return lines
      .map((line) => line.length < indent ? '' : line.substring(indent))
      .join('\n');
}

void main() {
  group('Given the README and the samples in test/readme', () {
    test('When each Dart code block is looked up, '
        'then it is the code of a sample region', () {
      final regions = _sampleRegions().values.toSet();
      for (final block in _readmeBlocks()) {
        expect(regions, contains(block));
      }
    });

    test('When each sample region is looked up, '
        'then the README shows it', () {
      final blocks = _readmeBlocks().toSet();
      _sampleRegions().forEach((name, code) {
        expect(blocks, contains(code), reason: 'Region $name');
      });
    });
  });
}
