import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_widgets_example/main.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const TurboWidgetsExampleApp());
    await tester.pumpAndSettle();

    expect(find.text('Component Testing Area'), findsOneWidget);
  });
}
