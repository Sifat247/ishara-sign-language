import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/ishara_theme.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: IsharaApp()));
}

class IsharaApp extends StatelessWidget {
  const IsharaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ishara Sign Language',
      debugShowCheckedModeBanner: false,
      theme: IsharaTheme.lightTheme,
      home: const OnboardingScreen(),
    );
  }
}
