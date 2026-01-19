import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_widgets/turbo_widgets.dart';

void main() {
  group('TSpacings', () {
    test('should have correct spacing values', () {
      expect(TSpacings.appPadding, 24.0);
      expect(TSpacings.elementGap, 16.0);
      expect(TSpacings.sectionGap, 24.0);
      expect(TSpacings.itemGap, 12.0);
      expect(TSpacings.textGap, 8.0);
    });
  });

  group('TDurations', () {
    test('should have correct duration values', () {
      expect(TDurations.animation, const Duration(milliseconds: 225));
      expect(TDurations.hover, const Duration(milliseconds: 100));
      expect(TDurations.sheetAnimation, const Duration(milliseconds: 300));
    });
  });

  group('TGap', () {
    testWidgets('should create a gap with custom size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('First'),
                TGap(20),
                Text('Second'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
    });

    testWidgets('should create element gap', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('First'),
                TGap.element(),
                Text('Second'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
    });
  });

  group('TPadding', () {
    testWidgets('should create padding with all sides', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TPadding.all(
              padding: 16.0,
              child: Text('Test'),
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('should create app padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TPadding.app(
              child: Text('Test'),
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('should create horizontal padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TPadding.horizontal(
              child: Text('Test'),
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('should create vertical padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TPadding.vertical(
              child: Text('Test'),
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });
  });

  group('TVerticalShrink', () {
    testWidgets('should show child when show is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TVerticalShrink(
              show: true,
              child: Text('Visible'),
            ),
          ),
        ),
      );

      expect(find.text('Visible'), findsOneWidget);
    });

    testWidgets('should hide child when show is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TVerticalShrink(
              show: false,
              child: Text('Hidden'),
            ),
          ),
        ),
      );

      expect(find.text('Hidden'), findsNothing);
    });
  });

  group('THorizontalShrink', () {
    testWidgets('should show child when show is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: THorizontalShrink(
              show: true,
              child: Text('Visible'),
            ),
          ),
        ),
      );

      expect(find.text('Visible'), findsOneWidget);
    });

    testWidgets('should hide child when show is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: THorizontalShrink(
              show: false,
              child: Text('Hidden'),
            ),
          ),
        ),
      );

      expect(find.text('Hidden'), findsNothing);
    });
  });
}
