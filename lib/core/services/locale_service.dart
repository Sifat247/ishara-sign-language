import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  bangla('bn', 'বাংলা'),
  english('en', 'English'),
  arabic('ar', 'العربية'),
  hindi('hi', 'हिन्दी'),
  urdu('ur', 'اردو'),
  spanish('es', 'Español'),
  french('fr', 'Français');

  final String code;
  final String displayName;
  const AppLanguage(this.code, this.displayName);
}

class AppStrings {
  static const Map<String, Map<String, String>> _localizedValues = {
    // 1. Bengali (বাংলা) - Primary Local
    'bn': {
      'app_title': 'ইশারা',
      'app_subtitle': 'বাংলা ইশারা ভাষা (BdSL) ও ASL শেখার প্রথম সম্পূর্ণ অফলাইন ও আধুনিক অ্যাপ।',
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
    'en': {
      'app_title': 'Ishara',
      'app_subtitle': 'The modern offline sign language app for Bengali Sign Language (BdSL) & ASL.',
      'start_free': 'Start Learning (Free)',
      'streak_label': 'Daily Streak',
      'xp_label': 'Total XP',
      'curriculum_title': 'Learning Roadmap',
      'start_button': 'Start',
      'restart_button': 'Review',
      'dictionary_tab': 'Dictionary',
      'learn_tab': 'Learn',
      'mirror_mode': 'Mirror Mode',
      'bookmark_saved': 'Sign saved to your local vault.',
      'bookmark_removed': 'Removed from saved signs.',
      'next_sign': 'Next Sign',
      'see_results': 'View Results',
      'completed_sign': '✓ Completed',
      'all_signs': 'All Signs',
      'saved_filter': 'Saved ❤️',
      'search_placeholder': 'Search signs in English or Bengali...',
    },

    // 3. Arabic (العربية) - Middle East NRB Diaspora
    'ar': {
      'app_title': 'إشارة',
      'app_subtitle': 'التطبيق الحديث لتعلم لغة الإشارة البنغالية (BdSL) ولغة الإشارة الأمريكية (ASL) بدون إنترنت.',
      'start_free': 'ابدأ التعلم (مجاناً)',
      'streak_label': 'حماسة يومية',
      'xp_label': 'النقاط الإجمالية',
      'curriculum_title': 'خارطة طريق التعلم',
      'start_button': 'ابدأ',
      'restart_button': 'إعادة',
      'dictionary_tab': 'القاموس',
      'learn_tab': 'تعلّم',
      'mirror_mode': 'وضع المرآة',
      'bookmark_saved': 'تم حفظ الإشارة بنجاح.',
      'bookmark_removed': 'تمت الإزالة من المحفوظات.',
      'next_sign': 'الإشارة التالية',
      'see_results': 'عرض النتيجة',
      'completed_sign': '✓ مكتمل',
      'all_signs': 'الكل',
      'saved_filter': 'المحفوظات ❤️',
      'search_placeholder': 'ابحث عن الإشارات...',
    },

    // 4. Hindi (हिन्दी) - South Asian Cross-border
    'hi': {
      'app_title': 'इशारा',
      'app_subtitle': 'बंगाली सांकेतिक भाषा (BdSL) और ASL सीखने का आधुनिक ऑफलाइन ऐप।',
      'start_free': 'सीखना शुरू करें (फ्री)',
      'streak_label': 'दैनिक स्ट्रीक',
      'xp_label': 'कुल अनुभव (XP)',
      'curriculum_title': 'सीखने का रोडमैप',
      'start_button': 'शुरू करें',
      'restart_button': 'पुनरावलोकन',
      'dictionary_tab': 'शब्दकोश',
      'learn_tab': 'सीखें',
      'mirror_mode': 'मिरर मोड',
      'bookmark_saved': 'इशारा आपकी सूची में सहेजा गया।',
      'bookmark_removed': 'सहेजी गई सूची से हटाया गया।',
      'next_sign': 'अगला संकेत',
      'see_results': 'परिणाम देखें',
      'completed_sign': '✓ पूरा हुआ',
      'all_signs': 'सभी संकेत',
      'saved_filter': 'सहेजे गए ❤️',
      'search_placeholder': 'संकेत खोजें...',
    },

    // 5. Urdu (اردو) - South Asian Diaspora
    'ur': {
      'app_title': 'اشارہ',
      'app_subtitle': 'بنگالی اشاروں کی زبان (BdSL) اور ASL سیکھنے کی جدید آف لائن ایپ۔',
      'start_free': 'سیکھنا شروع کریں (مفت)',
      'streak_label': 'روزانہ سلسلہ',
      'xp_label': 'کل پوائنٹس',
      'curriculum_title': 'سیکھنے کا روڈ میپ',
      'start_button': 'شروع کریں',
      'restart_button': 'دوبارہ دیکھیں',
      'dictionary_tab': 'لغت',
      'learn_tab': 'سیکھیں',
      'mirror_mode': 'شیشہ موڈ',
      'bookmark_saved': 'اشارہ محفوظ کر لیا گیا۔',
      'bookmark_removed': 'محفوظات سے ہٹا دیا گیا۔',
      'next_sign': 'اگلا اشارہ',
      'see_results': 'نتائج دیکھیں',
      'completed_sign': '✓ مکمل',
      'all_signs': 'تمام اشارے',
      'saved_filter': 'محفوظ شدہ ❤️',
      'search_placeholder': 'اشارے تلاش کریں...',
    },

    // 6. Spanish (Español) - Americas / Global Deaf Studies
    'es': {
      'app_title': 'Ishara',
      'app_subtitle': 'La aplicación moderna para aprender lengua de señas (BdSL y ASL) sin conexión.',
      'start_free': 'Comenzar a aprender (Gratis)',
      'streak_label': 'Racha Diaria',
      'xp_label': 'XP Total',
      'curriculum_title': 'Ruta de Aprendizaje',
      'start_button': 'Iniciar',
      'restart_button': 'Repasar',
      'dictionary_tab': 'Diccionario',
      'learn_tab': 'Aprender',
      'mirror_mode': 'Modo Espejo',
      'bookmark_saved': 'Seña guardada en tu colección.',
      'bookmark_removed': 'Eliminada de guardados.',
      'next_sign': 'Siguiente Seña',
      'see_results': 'Ver Resultados',
      'completed_sign': '✓ Completado',
      'all_signs': 'Todas',
      'saved_filter': 'Guardadas ❤️',
      'search_placeholder': 'Buscar señas...',
    },

    // 7. French (Français) - Europe, Canada, West Africa
    'fr': {
      'app_title': 'Ishara',
      'app_subtitle': 'L’application moderne hors ligne pour apprendre la langue des signes (BdSL et ASL).',
      'start_free': 'Commencer (Gratuit)',
      'streak_label': 'Série quotidienne',
      'xp_label': 'XP Total',
      'curriculum_title': 'Plan d’apprentissage',
      'start_button': 'Commencer',
      'restart_button': 'Revoir',
      'dictionary_tab': 'Dictionnaire',
      'learn_tab': 'Apprendre',
      'mirror_mode': 'Mode Miroir',
      'bookmark_saved': 'Signe enregistré dans vos favoris.',
      'bookmark_removed': 'Retiré des favoris.',
      'next_sign': 'Signe suivant',
      'see_results': 'Voir les résultats',
      'completed_sign': '✓ Terminé',
      'all_signs': 'Tous les signes',
      'saved_filter': 'Enregistrés ❤️',
      'search_placeholder': 'Rechercher un signe...',
    },
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
