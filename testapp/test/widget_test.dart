import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:testapp/features/onboarding/pages/onboarding_flow_page.dart';
import 'package:testapp/features/onboarding/widgets/onboarding_welcome_step.dart';
import 'package:testapp/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('App opens onboarding welcome flow on first launch', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byType(OnboardingFlowPage), findsOneWidget);
    expect(find.byType(OnboardingWelcomeStep), findsOneWidget);
  });
}
