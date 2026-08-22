import 'package:centrally/models/centerly_models.dart';
import 'package:centrally/screens/main_shell_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('teacher shell shows the main dashboard sections', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: MainShellView(role: UserRole.teacher)),
    );

    expect(find.text('Centerly Teacher'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Sessions'), findsWidgets);
    expect(find.text('Groups'), findsWidgets);
    expect(find.text('Finance'), findsWidgets);
    expect(find.text('Today overview'), findsOneWidget);
  });
}
