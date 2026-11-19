import 'package:flutter/material.dart';
import 'package:ishara_sign/core/services/locale_service.dart';
import 'package:ishara_sign/core/services/local_vault_service.dart';
import 'package:ishara_sign/core/services/sign_database.dart';
import 'package:ishara_sign/core/theme/ishara_theme.dart';
import '../../quiz/presentation/interactive_lesson_screen.dart';
import '../../dictionary/presentation/dictionary_screen.dart';
import 'progress_tracker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _streakDays = 0;
  int _xpPoints = 140;
  String _activeTrack = 'bdsl';
  List<String> _completedLessonIds = [];

  @override
  void initState() {
    super.initState();
    localeNotifier.addListener(_onLocaleChanged);
    _loadState();
  }

  @override
  void dispose() {
    localeNotifier.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadState() async {
    final xp = await ProgressTracker.getXp();
    final streak = await ProgressTracker.getStreak();
    final track = await ProgressTracker.getTrack();
    final completed = await LocalVaultService.getCompletedLessonIds();

    if (mounted) {
      setState(() {
        _xpPoints = xp;
        _streakDays = streak;
        _activeTrack = track;
        _completedLessonIds = completed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final nodes = AuthenticSignDatabase.getCurriculumNodes(track: _activeTrack);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${localeNotifier.tr('app_title')} ',
              style: const TextStyle(fontWeight: FontWeight.bold, color: IsharaColors.primaryTeal),
            ),
          ],
        ),
        actions: [
          // UI Language Switcher Pill
          Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: IsharaColors.primaryTeal.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<AppLanguage>(
                value: localeNotifier.currentLanguage,
                isDense: true,
                items: AppLanguage.values.map((l) {
                  return DropdownMenuItem(
                    value: l,
                    child: Text(l.displayName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) localeNotifier.setLanguage(val);
                },
              ),
            ),
          ),

          // Sign Track Switcher Pill (BdSL vs ASL)
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: IsharaColors.royalGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: IsharaColors.royalGold.withValues(alpha: 0.5)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _activeTrack,
                isDense: true,
                items: const [
                  DropdownMenuItem(value: 'bdsl', child: Text('🇧🇩 BdSL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                  DropdownMenuItem(value: 'asl', child: Text('🇺🇸 ASL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                ],
                onChanged: (val) async {
                  if (val != null) {
                    setState(() => _activeTrack = val);
                    await ProgressTracker.setTrack(val);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Daily Streak & XP Header Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [IsharaColors.primaryTeal, IsharaColors.tealSurface],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: IsharaColors.primaryTeal.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department_rounded, color: IsharaColors.royalGold, size: 36),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$_streakDays দিন',
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              localeNotifier.tr('streak_label'),
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(height: 36, width: 1, color: Colors.white24),
                    Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: Colors.amberAccent, size: 36),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$_xpPoints XP',
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              localeNotifier.tr('xp_label'),
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                localeNotifier.tr('curriculum_title'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: IsharaColors.textDark),
              ),
            ),
          ),

          // Curriculum Tree List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, idx) {
                  final node = nodes[idx];
                  final isDone = _completedLessonIds.contains(node.id);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: isDone
                                ? IsharaColors.success.withValues(alpha: 0.15)
                                : IsharaColors.primaryTeal.withValues(alpha: 0.1),
                            child: isDone
                                ? const Icon(Icons.check_rounded, color: IsharaColors.success)
                                : Text(
                                    '${idx + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: IsharaColors.primaryTeal,
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localeNotifier.currentLanguage == AppLanguage.bangla ? node.titleBn : node.titleEn,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: IsharaColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  localeNotifier.currentLanguage == AppLanguage.bangla ? node.titleEn : node.titleBn,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: IsharaColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  isDone
                                      ? '${localeNotifier.tr('completed_sign')} (+30 XP)'
                                      : '${node.signs.length}টি ইন্টারঅ্যাক্টিভ ড্রিল',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDone ? IsharaColors.success : IsharaColors.tealLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(96, 44),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              backgroundColor: isDone ? Colors.grey.shade100 : IsharaColors.primaryTeal,
                              foregroundColor: isDone ? IsharaColors.textDark : Colors.white,
                              side: isDone ? const BorderSide(color: Color(0xFFCBD5E1)) : BorderSide.none,
                            ),
                            onPressed: () async {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => InteractiveLessonScreen(node: node),
                                ),
                              );
                              if (res == true) {
                                await ProgressTracker.addXp(30);
                                _loadState();
                              }
                            },
                            child: Text(isDone ? localeNotifier.tr('restart_button') : localeNotifier.tr('start_button')),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: nodes.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: IsharaColors.primaryTeal,
        unselectedItemColor: IsharaColors.textMuted,
        onTap: (idx) {
          if (idx == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DictionaryScreen()),
            );
          } else if (idx == 2) {
            _showAboutModal(context);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.school_rounded),
            label: localeNotifier.tr('learn_tab'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book_rounded),
            label: localeNotifier.tr('dictionary_tab'),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.info_outline_rounded),
            label: 'পরিচিতি',
          ),
        ],
      ),
    );
  }

  void _showAboutModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.volunteer_activism_rounded, color: IsharaColors.primaryTeal, size: 30),
                SizedBox(width: 8),
                Text(
                  'ইশারা (Ishara) প্রকল্প',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: IsharaColors.primaryTeal),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'ইশারা একটি উন্মুক্ত ও ১০০% ফ্রি প্রবেশগম্যতা উদ্যোগ। কোনো লুকানো চার্জ বা বাণিজ্যিক পেওয়াল নেই। শ্রবণ ও বাক প্রতিবন্ধী জনগোষ্ঠীর সাথে প্রাথমিক ভাববিনিময়ের সহজ পথ তৈরি করাই এর লক্ষ্য।',
              textAlign: TextAlign.center,
              style: TextStyle(color: IsharaColors.textDark, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'অফিসিয়াল তথ্য ও যোগাযোগ:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            const Text(
              '• গিটহাব: github.com/Sifat247/ishara-sign-language\n• গোপনীয়তা নীতিমালা: ishara-sign-language.vercel.app/privacy\n• সংস্করণ: 1.0.0 (ওপেন এডুকেশন)',
              style: TextStyle(fontSize: 12, color: IsharaColors.textMuted, height: 1.5),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('বন্ধ করুন'),
            ),
          ],
        ),
      ),
    );
  }
}
