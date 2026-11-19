import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ishara_sign/core/models/sign_item.dart';
import 'package:ishara_sign/core/services/locale_service.dart';
import 'package:ishara_sign/core/services/local_vault_service.dart';
import 'package:ishara_sign/core/theme/ishara_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../mirror/presentation/interactive_hand_canvas.dart';

class InteractiveLessonScreen extends StatefulWidget {
  final LessonNode node;
  const InteractiveLessonScreen({super.key, required this.node});

  @override
  State<InteractiveLessonScreen> createState() => _InteractiveLessonScreenState();
}

class _InteractiveLessonScreenState extends State<InteractiveLessonScreen> {
  int _currentIndex = 0;
  int? _selectedChoice;
  bool _isAnswered = false;
  int _score = 0;
  bool _isMirrorMode = false;
  bool _isBookmarked = false;
  double _playbackSpeed = 1.0;

  SignItem get _currentSign => widget.node.signs[_currentIndex];

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    final bookmarked = await LocalVaultService.isBookmarked(_currentSign.id);
    if (mounted) setState(() => _isBookmarked = bookmarked);
  }

  void _onChoiceSelected(int index, List<String> options) {
    if (_isAnswered) return;
    final isCorrect = options[index] == _currentSign.banglaWord;

    if (isCorrect) {
      HapticFeedback.lightImpact();
      _score += 10;
    } else {
      HapticFeedback.selectionClick();
    }

    setState(() {
      _selectedChoice = index;
      _isAnswered = true;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < widget.node.signs.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedChoice = null;
        _isAnswered = false;
      });
      _checkBookmarkStatus();
    } else {
      _finishLesson();
    }
  }

  Future<void> _finishLesson() async {
    await LocalVaultService.markLessonCompleted(widget.node.id);
    HapticFeedback.mediumImpact();
    if (mounted) _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 দারুণ কাজ সম্পন্ন!', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'আপনি সফলভাবে এই অধ্যায়টির সকল ইশারা অনুশীলন করেছেন।',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: IsharaColors.goldLight.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: IsharaColors.royalGold),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stars_rounded, color: IsharaColors.royalGold, size: 30),
                  const SizedBox(width: 8),
                  Text(
                    '+$_score XP অর্জিত!',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: IsharaColors.primaryTeal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, true);
            },
            child: const Text('হোমে ফিরে যান'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentIndex + 1) / widget.node.signs.length;

    // Generate 4 randomized options
    final correctWord = _currentSign.banglaWord;
    final allWords = [
      'ধন্যবাদ',
      'স্বাগতম / হ্যালো',
      'আমি ভালো আছি',
      'সাহায্য করুন',
      'দুঃখিত / ক্ষমা করবেন',
      'শুভ সকাল',
      'শুভ রাত্রি',
      'হ্যাঁ / ঠিক আছে',
      'না / অসম্মতি',
      'ডাক্তার / চিকিৎসা',
      'পানি / পিপাসা',
      'মা',
      'বাবা',
      'ভাই',
      'বোন',
      'বন্ধু',
    ];
    final distractors = allWords.where((w) => w != correctWord).toList()..shuffle();
    final options = [correctWord, ...distractors.take(3)]..shuffle();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.node.titleBn),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation(IsharaColors.primaryTeal),
          ),
        ),
        actions: [
          // Slow-Mo Speed Toggle (0.5x, 0.75x, 1x)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<double>(
                value: _playbackSpeed,
                isDense: true,
                items: const [
                  DropdownMenuItem(value: 0.5, child: Text('0.5x', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                  DropdownMenuItem(value: 0.75, child: Text('0.75x', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                  DropdownMenuItem(value: 1.0, child: Text('1.0x', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _playbackSpeed = val);
                },
              ),
            ),
          ),
          IconButton(
            tooltip: 'সংরক্ষণ করুন (Bookmark)',
            icon: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isBookmarked ? IsharaColors.royalGold : IsharaColors.textDark,
            ),
            onPressed: () async {
              final isSaved = await LocalVaultService.toggleBookmark(_currentSign.id);
              if (!context.mounted) return;
              setState(() => _isBookmarked = isSaved);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(milliseconds: 1200),
                  content: Text(isSaved ? localeNotifier.tr('bookmark_saved') : localeNotifier.tr('bookmark_removed')),
                ),
              );
            },
          ),
          IconButton(
            tooltip: localeNotifier.tr('mirror_mode'),
            icon: Icon(
              _isMirrorMode ? Icons.flip_rounded : Icons.flip_outlined,
              color: _isMirrorMode ? IsharaColors.royalGold : IsharaColors.textDark,
            ),
            onPressed: () {
              setState(() {
                _isMirrorMode = !_isMirrorMode;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Question Tracker & Hint
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ইশারা #${_currentIndex + 1} / ${widget.node.signs.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: IsharaColors.textMuted),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: IsharaColors.primaryTeal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _currentSign.track.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: IsharaColors.primaryTeal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Visual Sign Showcase Studio Card
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: IsharaColors.studioBackdrop,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InteractiveHandCanvas(
                              signId: _currentSign.id,
                              handEmoji: _currentSign.handEmoji,
                              isMirror: _isMirrorMode,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _currentSign.englishWord,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_isMirrorMode)
                        Positioned(
                          right: 12,
                          top: 12,
                          width: 105,
                          height: 135,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              border: Border.all(color: IsharaColors.royalGold, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.person_rounded, color: Colors.white54, size: 36),
                                const SizedBox(height: 4),
                                Text(
                                  localeNotifier.tr('mirror_mode'),
                                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'গতি: ${_playbackSpeed}x',
                            style: const TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Tactical Instructions
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: IsharaColors.paperCanvas,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  '💡 ইঙ্গিত: ${_currentSign.gestureHintBn}',
                  style: const TextStyle(fontSize: 13, color: IsharaColors.textDark, height: 1.4),
                ),
              ),

              const SizedBox(height: 14),
              const Text(
                'এই ইশারাটির সঠিক অর্থ কোনটি?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),

              // 4 Quiz Choice Buttons
              Expanded(
                flex: 4,
                child: ListView.separated(
                  itemCount: options.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, idx) {
                    final opt = options[idx];
                    final isSelected = _selectedChoice == idx;
                    Color btnColor = Colors.white;
                    Color textColor = IsharaColors.textDark;
                    BorderSide border = const BorderSide(color: Color(0xFFE2E8F0));

                    if (_isAnswered) {
                      if (opt == correctWord) {
                        btnColor = IsharaColors.success.withValues(alpha: 0.12);
                        textColor = IsharaColors.success;
                        border = const BorderSide(color: IsharaColors.success, width: 2);
                      } else if (isSelected) {
                        btnColor = IsharaColors.error.withValues(alpha: 0.12);
                        textColor = IsharaColors.error;
                        border = const BorderSide(color: IsharaColors.error, width: 2);
                      }
                    }

                    return InkWell(
                      onTap: () => _onChoiceSelected(idx, options),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: btnColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.fromBorderSide(border),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: IsharaColors.primaryTeal.withValues(alpha: 0.1),
                              child: Text(
                                '${idx + 1}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: IsharaColors.primaryTeal,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                opt,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ),
                            if (_isAnswered && opt == correctWord)
                              const Icon(Icons.check_circle_rounded, color: IsharaColors.success)
                            else if (_isAnswered && isSelected)
                              const Icon(Icons.cancel_rounded, color: IsharaColors.error),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Continue Action Button
              if (_isAnswered)
                ElevatedButton(
                  onPressed: _nextQuestion,
                  child: Text(
                    _currentIndex < widget.node.signs.length - 1 ? localeNotifier.tr('next_sign') : localeNotifier.tr('see_results'),
                  ),
                ).animate().slideY(begin: 0.3, duration: 250.ms),
            ],
          ),
        ),
      ),
    );
  }
}
