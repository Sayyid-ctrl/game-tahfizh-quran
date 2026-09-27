class UserProgressModel {
  final int totalXp;
  final int streakDays;
  final int currentLevel;
  final int quizzesCompleted;
  final int totalCorrectAnswers;
  final Map<int, int> levelStars; // levelIndex -> 1..3 stars
  final List<String> unlockedBadgeIds;

  const UserProgressModel({
    this.totalXp = 0,
    this.streakDays = 1,
    this.currentLevel = 1,
    this.quizzesCompleted = 0,
    this.totalCorrectAnswers = 0,
    this.levelStars = const {1: 5},
    this.unlockedBadgeIds = const ['badge_starter'],
  });

  String get playerTitle {
    if (totalXp >= 1500) return 'Master Tahfizh (Juz 28, 29, 30)';
    if (totalXp >= 1000) return 'Hafiz Juz 28';
    if (totalXp >= 600) return 'Hafiz Juz 29';
    if (totalXp >= 300) return 'Hafiz Juz 30';
    if (totalXp >= 100) return 'Penuntut Ilmu Tahfizh';
    return 'Pemula Tahfizh';
  }

  UserProgressModel copyWith({
    int? totalXp,
    int? streakDays,
    int? currentLevel,
    int? quizzesCompleted,
    int? totalCorrectAnswers,
    Map<int, int>? levelStars,
    List<String>? unlockedBadgeIds,
  }) {
    return UserProgressModel(
      totalXp: totalXp ?? this.totalXp,
      streakDays: streakDays ?? this.streakDays,
      currentLevel: currentLevel ?? this.currentLevel,
      quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      levelStars: levelStars ?? this.levelStars,
      unlockedBadgeIds: unlockedBadgeIds ?? this.unlockedBadgeIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalXp': totalXp,
      'streakDays': streakDays,
      'currentLevel': currentLevel,
      'quizzesCompleted': quizzesCompleted,
      'totalCorrectAnswers': totalCorrectAnswers,
      'levelStars': levelStars.map((k, v) => MapEntry(k.toString(), v)),
      'unlockedBadgeIds': unlockedBadgeIds,
    };
  }

  factory UserProgressModel.fromJson(Map<String, dynamic> json) {
    Map<int, int> starsMap = {};
    if (json['levelStars'] != null) {
      (json['levelStars'] as Map<String, dynamic>).forEach((key, value) {
        starsMap[int.parse(key)] = value as int;
      });
    } else {
      starsMap = {1: 3};
    }

    return UserProgressModel(
      totalXp: json['totalXp'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 1,
      currentLevel: json['currentLevel'] as int? ?? 1,
      quizzesCompleted: json['quizzesCompleted'] as int? ?? 0,
      totalCorrectAnswers: json['totalCorrectAnswers'] as int? ?? 0,
      levelStars: starsMap,
      unlockedBadgeIds: (json['unlockedBadgeIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['badge_starter'],
    );
  }
}
