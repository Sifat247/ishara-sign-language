import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_sign/core/services/locale_service.dart';
import 'package:ishara_sign/main.dart';

void main() {
  testWidgets('App renders onboarding with start button', (WidgetTester tester) async {
    await tester.pumpWidget(const IsharaApp());
    expect(find.text(localeNotifier.tr('app_title')), findsOneWidget);
    expect(find.text(localeNotifier.tr('start_free')), findsOneWidget);
  });
}
