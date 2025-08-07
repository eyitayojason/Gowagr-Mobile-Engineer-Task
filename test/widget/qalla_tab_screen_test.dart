// Qalla tab screen widget tests
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gowagr_mobile/presentation/providers/event_provider.dart';
import 'package:gowagr_mobile/presentation/screens/qalla_tab_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('QallaTabScreen shows loading indicator', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => EventProvider(),
        child: MaterialApp(home: QallaTabScreen()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
