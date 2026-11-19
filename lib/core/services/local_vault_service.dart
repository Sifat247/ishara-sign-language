import 'package:shared_preferences/shared_preferences.dart';

class LocalVaultService {
  static const String _keyBookmarks = 'ishara_bookmarked_signs';
  static const String _keyCompletedLessons = 'ishara_completed_lessons';
  static const String _keyDailyGoalMinutes = 'ishara_daily_goal_mins';

  static Future<List<String>> getBookmarkedSignIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyBookmarks) ?? [];
  }

  static Future<bool> toggleBookmark(String signId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyBookmarks) ?? [];
    bool isNowSaved = false;
    if (list.contains(signId)) {
      list.remove(signId);
      isNowSaved = false;
    } else {
      list.add(signId);
      isNowSaved = true;
    }
    await prefs.setStringList(_keyBookmarks, list);
    return isNowSaved;
  }

  static Future<bool> isBookmarked(String signId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyBookmarks) ?? [];
    return list.contains(signId);
  }

  static Future<List<String>> getCompletedLessonIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyCompletedLessons) ?? [];
  }

  static Future<void> markLessonCompleted(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyCompletedLessons) ?? [];
    if (!list.contains(lessonId)) {
      list.add(lessonId);
      await prefs.setStringList(_keyCompletedLessons, list);
    }
  }

  static Future<int> getDailyGoalMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyDailyGoalMinutes) ?? 5;
  }

  static Future<void> setDailyGoalMinutes(int mins) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyDailyGoalMinutes, mins);
  }
}
