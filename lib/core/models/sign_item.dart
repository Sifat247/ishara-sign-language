class SignItem {
  final String id;
  final String banglaWord;
  final String englishWord;
  final String category; // 'alphabet', 'daily', 'emergency', 'numbers'
  final String descriptionBn;
  final String gestureHintBn;
  final String handEmoji;
  final String track; // 'bdsl', 'asl', or 'both'
  final bool isPro;

  const SignItem({
    required this.id,
    required this.banglaWord,
    required this.englishWord,
    required this.category,
    required this.descriptionBn,
    required this.gestureHintBn,
    required this.handEmoji,
    this.track = 'bdsl',
    this.isPro = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'banglaWord': banglaWord,
    'englishWord': englishWord,
    'category': category,
    'descriptionBn': descriptionBn,
    'gestureHintBn': gestureHintBn,
    'handEmoji': handEmoji,
    'track': track,
    'isPro': isPro,
  };

  factory SignItem.fromMap(Map<String, dynamic> map) => SignItem(
    id: map['id'] as String,
    banglaWord: map['banglaWord'] as String,
    englishWord: map['englishWord'] as String,
    category: map['category'] as String,
    descriptionBn: map['descriptionBn'] as String,
    gestureHintBn: map['gestureHintBn'] as String,
    handEmoji: map['handEmoji'] as String,
    track: map['track'] as String? ?? 'bdsl',
    isPro: map['isPro'] as bool? ?? false,
  );
}

class LessonNode {
  final String id;
  final String titleBn;
  final String titleEn;
  final String category;
  final List<SignItem> signs;
  final bool isLocked;

  const LessonNode({
    required this.id,
    required this.titleBn,
    required this.titleEn,
    required this.category,
    required this.signs,
    this.isLocked = false,
  });
}
