import 'package:shared_preferences/shared_preferences.dart';

class ProgressTracker {
  static const String _keyXp = 'ishara_xp';
  static const String _keyStreak = 'ishara_streak';
  static const String _keyTrack = 'ishara_track';

  static Future<int> getXp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyXp) ?? 0;
  }

  static Future<void> addXp(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getXp();
    await prefs.setInt(_keyXp, current + amount);
  }

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyStreak) ?? 0;
  }

  static Future<String> getTrack() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTrack) ?? 'bdsl';
  }

  static Future<void> setTrack(String track) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTrack, track);
  }

}
