import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:testapp/features/onboarding/pages/avatar_launch_page.dart';
import 'package:testapp/features/onboarding/pages/onboarding_flow_page.dart';
import 'package:testapp/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App shows avatar launch before first open flow', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(AvatarLaunchPage), findsOneWidget);
    expect(find.byType(OnboardingFlowPage), findsNothing);

    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pump();

    expect(find.byType(AvatarLaunchPage), findsNothing);
    expect(find.byType(OnboardingFlowPage), findsOneWidget);
  });
}
