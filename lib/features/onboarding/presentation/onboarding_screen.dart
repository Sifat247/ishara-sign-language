import 'package:flutter/material.dart';
import 'package:ishara_sign/core/services/locale_service.dart';
import 'package:ishara_sign/core/theme/ishara_theme.dart';
import '../../curriculum/presentation/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    localeNotifier.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    localeNotifier.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Language Switcher Dropdown
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: IsharaColors.primaryTeal.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: IsharaColors.primaryTeal.withValues(alpha: 0.2)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<AppLanguage>(
                value: localeNotifier.currentLanguage,
                isDense: true,
                items: AppLanguage.values.map((l) {
                  return DropdownMenuItem(
                    value: l,
                    child: Text(
                      l.displayName,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) localeNotifier.setLanguage(val);
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: IsharaColors.primaryTeal,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: IsharaColors.primaryTeal.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🤟', style: TextStyle(fontSize: 54)),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                localeNotifier.tr('app_title'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: IsharaColors.primaryTeal,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                localeNotifier.tr('app_subtitle'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: IsharaColors.textMuted,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Column(
                  children: [
                    _BenefitRow(icon: Icons.offline_bolt_rounded, text: 'সম্পূর্ণ অফলাইন প্র্যাকটিস — শূন্য ইন্টারনেট খরচে'),
                    SizedBox(height: 12),
                    _BenefitRow(icon: Icons.camera_front_rounded, text: 'ক্যামেরা মিরর মোডে হাতের ভঙ্গি নির্ভুল যাচাই'),
                    SizedBox(height: 12),
                    _BenefitRow(icon: Icons.verified_user_rounded, text: 'প্রমিত BNDF ও সমাজসেবা অধিদপ্তর স্বীকৃত সাইন'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                child: Text(localeNotifier.tr('start_free')),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _BenefitRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: IsharaColors.primaryTeal, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: IsharaColors.textDark),
          ),
        ),
      ],
    );
  }
}
