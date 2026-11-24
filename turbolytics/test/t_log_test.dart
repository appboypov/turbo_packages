import 'package:test/test.dart';
import 'package:turbolytics/turbolytics.dart';

void main() {
  late List<TLogLine> lines;

  setUp(() {
    lines = [];
    TLog.output = lines.add;
  });

  tearDown(() {
    TLog.output = TLog.printLine;
    TLog.level = TLogLevel.info;
  });

  test('an error line holds its error and its whole stack trace', () {
    final stackTrace = StackTrace.fromString('#0 first\n#1 second\n#2 third');

    TLog(location: 'sync').error(
      'The read failed.',
      error: StateError('gone'),
      stackTrace: stackTrace,
    );

    final line = lines.single;
    expect(line.level, TLogLevel.error);
    expect(line.location, 'sync');
    expect(line.error, isA<StateError>());
    expect(line.stackTrace, stackTrace);
    expect(
      '$line'.split('\n'),
      containsAllInOrder([
        contains('The read failed.'),
        contains('gone'),
        '#0 first',
        '#1 second',
        '#2 third',
      ]),
    );
  });

  test('a warning keeps the error and stack trace of a recovered failure', () {
    final stackTrace = StackTrace.current;

    TLog().warning(
      'The sync tries again.',
      error: StateError('busy'),
      stackTrace: stackTrace,
    );

    expect(lines.single.level, TLogLevel.warning);
    expect(lines.single.error, isA<StateError>());
    expect(lines.single.stackTrace, stackTrace);
  });

  test('a line below the level never reaches the output', () {
    TLog.level = TLogLevel.warning;

    TLog()
      ..debug('Quiet')
      ..info('Quiet too')
      ..warning('Heard');

    expect(lines.map((line) => line.message), ['Heard']);
  });

  test('an error with printStack false shows no stack lines in its text', () {
    TLog().error(
      'Short',
      stackTrace: StackTrace.fromString('#0 hidden'),
      printStack: false,
    );

    expect('${lines.single}', isNot(contains('#0 hidden')));
    expect(lines.single.stackTrace, isNotNull);
  });
}
