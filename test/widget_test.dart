import 'package:flutter_test/flutter_test.dart';
import 'package:bendy_jizhang/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: BendyApp()),
    );
    await tester.pumpAndSettle();
    expect(find.text('Bendy 记账'), findsOneWidget);
  });
}
