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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: IsharaColors.primaryTeal,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: IsharaColors.primaryTeal.withValues(alpha: 0.3),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🤟', style: TextStyle(fontSize: 48)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                localeNotifier.tr('app_title'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: IsharaColors.primaryTeal,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                localeNotifier.tr('app_subtitle'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: IsharaColors.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Column(
                  children: [
                    _BenefitRow(icon: Icons.offline_bolt_rounded, text: '১০০% অফলাইন প্র্যাকটিস — শূন্য ইন্টারনেট খরচে'),
                    SizedBox(height: 10),
                    _BenefitRow(icon: Icons.camera_front_rounded, text: 'বাঁ-হাতি ও ডান-হাতি দৃশ্য বদলে দেখার সুবিধা'),
                    SizedBox(height: 10),
                    _BenefitRow(icon: Icons.school_rounded, text: 'শিক্ষানবিশ সহায়িকা — প্রাথমিক বাংলা ও ইংরেজি সাইন ড্রিল'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Honest Community Disclaimer Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, color: IsharaColors.primaryTeal, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'পরামর্শ: এটি প্রাথমিক ভাষা সচেতনতা ও শিক্ষানবিশ অ্যাপ। পূর্ণাঙ্গ ও পেশাদার ইশারা ভাষা শেখার জন্য অনুমোদিত বধির শিক্ষক বা ইনস্টিটিউটের সাথে অনুশীলন করুন।',
                        style: TextStyle(fontSize: 11, color: IsharaColors.textMuted, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
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
