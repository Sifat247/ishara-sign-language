import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ishara_sign/core/theme/ishara_theme.dart';

class ProgressTracker {
  static const String _keyXp = 'ishara_xp';
  static const String _keyStreak = 'ishara_streak';
  static const String _keyTrack = 'ishara_track';
  static const String _keyPro = 'ishara_pro_unlocked';

  static Future<int> getXp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyXp) ?? 140;
  }

  static Future<void> addXp(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getXp();
    await prefs.setInt(_keyXp, current + amount);
  }

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyStreak) ?? 5;
  }

  static Future<String> getTrack() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTrack) ?? 'bdsl';
  }

  static Future<void> setTrack(String track) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTrack, track);
  }

  static Future<bool> isProUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyPro) ?? false;
  }

  static Future<void> unlockPro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPro, true);
  }
}

class SpeedFingerspellingTrainer extends StatefulWidget {
  const SpeedFingerspellingTrainer({super.key});

  @override
  State<SpeedFingerspellingTrainer> createState() => _SpeedFingerspellingTrainerState();
}

class _SpeedFingerspellingTrainerState extends State<SpeedFingerspellingTrainer> {
  final List<Map<String, String>> _drills = [
    {'sign': 'অ', 'emoji': '✊', 'options': 'অ,আ,ই,ঈ'},
    {'sign': 'আ', 'emoji': '☝️', 'options': 'উ,আ,ঋ,এ'},
    {'sign': 'ক', 'emoji': '✌️', 'options': 'খ,গ,ঘ,ক'},
    {'sign': 'ধন্যবাদ', 'emoji': '🙏', 'options': 'হ্যালো,ধন্যবাদ,স্বাগতম,বিদায়'},
  ];

  int _drillIndex = 0;
  int _score = 0;
  bool _answered = false;
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final drill = _drills[_drillIndex];
    final options = drill['options']!.split(',');

    return Scaffold(
      appBar: AppBar(
        title: const Text('স্পিড ড্রিল ট্রেইনার (Speed Drill)'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ড্রিল #${_drillIndex + 1} / ${_drills.length}', style: TextStyle(fontWeight: FontWeight.bold, color: IsharaColors.textMuted)),
                  Text('স্কোর: $_score', style: TextStyle(fontWeight: FontWeight.bold, color: IsharaColors.primaryTeal)),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: IsharaColors.studioBackdrop,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      drill['emoji']!,
                      style: const TextStyle(fontSize: 90),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'ইশারাটি দেখে দ্রুত সঠিক অক্ষরটি নির্বাচন করুন:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                flex: 3,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.2,
                  children: options.map((opt) {
                    final isCorrect = opt == drill['sign'];
                    final isChosen = _selected == opt;

                    Color btnColor = Colors.white;
                    if (_answered) {
                      if (isCorrect) btnColor = IsharaColors.success.withValues(alpha: 0.2);
                      if (isChosen && !isCorrect) btnColor = IsharaColors.error.withValues(alpha: 0.2);
                    }

                    return InkWell(
                      onTap: _answered ? null : () async {
                        setState(() {
                          _selected = opt;
                          _answered = true;
                          if (isCorrect) _score += 10;
                        });
                        await ProgressTracker.addXp(10);
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        decoration: BoxDecoration(
                          color: btnColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Center(
                          child: Text(
                            opt,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: IsharaColors.textDark),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (_answered)
                ElevatedButton(
                  onPressed: () {
                    if (_drillIndex < _drills.length - 1) {
                      setState(() {
                        _drillIndex++;
                        _answered = false;
                        _selected = null;
                      });
                    } else {
                      Navigator.pop(context, _score);
                    }
                  },
                  child: Text(_drillIndex < _drills.length - 1 ? 'পরবর্তী ড্রিল' : 'সম্পন্ন করুন'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
