// Main application entry point
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/event_provider.dart';
import 'presentation/screens/qalla_tab_screen.dart';
import 'constants/app_theme.dart';

void main() {
  runApp(const GowagrMobile());
}

class GowagrMobile extends StatelessWidget {
  const GowagrMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: MaterialApp(
        title: 'Qalla',
        theme: AppTheme.lightTheme,
        home: QallaTabScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
