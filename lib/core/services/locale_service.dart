import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  bangla('bn', 'বাংলা');

  final String code;
  final String displayName;
  const AppLanguage(this.code, this.displayName);
}

class AppStrings {
  static const Map<String, Map<String, String>> _localizedValues = {
    // 1. Bengali (বাংলা) - Primary Local
    'bn': {
      'app_title': 'ইশারা',
      'app_subtitle': 'বাংলা ইশারা ভাষা (BdSL) শেখার সম্পূর্ণ অফলাইন ও আধুনিক অ্যাপ।',
      'start_free': 'শেখা শুরু করুন (Free)',
      'streak_label': 'ধারাবাহিক স্ট্রিক',
      'xp_label': 'মোট অভিজ্ঞতা',
      'curriculum_title': 'শিক্ষণ রোডম্যাপ',
      'start_button': 'শুরু',
      'restart_button': 'পুনরায়',
      'dictionary_tab': 'অভিধান',
      'learn_tab': 'শিখুন',
      'mirror_mode': 'আয়না মোড',
      'bookmark_saved': 'ইশারাটি আপনার তালিকায় সংরক্ষিত হয়েছে।',
      'bookmark_removed': 'সংরক্ষণ থেকে সরানো হয়েছে।',
      'next_sign': 'পরবর্তী ইশারা',
      'see_results': 'ফলাফল দেখুন',
      'completed_sign': '✓ সম্পন্ন হয়েছে',
      'all_signs': 'সবগুলো',
      'saved_filter': 'সংরক্ষিত ❤️',
      'search_placeholder': 'বাংলা বা ইংরেজিতে ইশারা খুঁজুন...',
    },

    // 2. English (en) - Global
  };

  static String tr(String key, String langCode) {
    return _localizedValues[langCode]?[key] ?? _localizedValues['bn']?[key] ?? key;
  }
}

class LocaleProvider extends ChangeNotifier {
  static const String _keyLang = 'ishara_ui_language';
  AppLanguage _currentLanguage = AppLanguage.bangla;

  AppLanguage get currentLanguage => _currentLanguage;
  String get langCode => _currentLanguage.code;

  LocaleProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_keyLang) ?? 'bn';
    _currentLanguage = AppLanguage.values.firstWhere(
      (l) => l.code == savedCode,
      orElse: () => AppLanguage.bangla,
    );
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    _currentLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLang, language.code);
    notifyListeners();
  }

  String tr(String key) => AppStrings.tr(key, _currentLanguage.code);
}

final localeNotifier = LocaleProvider();
