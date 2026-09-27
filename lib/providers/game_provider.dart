import 'package:flutter/material.dart';
import '../models/user_progress_model.dart';
import '../models/badge_model.dart';
import '../core/data/quran_dataset.dart';
import '../core/services/local_storage_service.dart';
import '../core/services/audio_player_service.dart';

class GameProvider extends ChangeNotifier {
  UserProgressModel _progress = const UserProgressModel();
  List<BadgeModel> _badges = QuranDataset.badges;
  final AudioPlayerService _audioService = AudioPlayerService();
  bool _isLoading = true;

  UserProgressModel get progress => _progress;
  List<BadgeModel> get badges => _badges;
  AudioPlayerService get audioService => _audioService;
  bool get isLoading => _isLoading;

  GameProvider() {
    _initData();
  }

  Future<void> _initData() async {
    _isLoading = true;
    notifyListeners();

    _progress = await LocalStorageService.loadProgress();
    _updateBadgesState();

    _isLoading = false;
    notifyListeners();
  }

  void _updateBadgesState() {
    _badges = QuranDataset.badges.map((b) {
      final bool isUnlocked = _progress.unlockedBadgeIds.contains(b.id) ||
          _progress.totalXp >= b.requiredXp;
      return b.copyWith(isUnlocked: isUnlocked);
    }).toList();
  }

  Future<void> addQuizScore({
    required int xpGained,
    required bool isCorrect,
    int? completedLevelIndex,
    int starsEarned = 3,
  }) async {
    final int newXp = _progress.totalXp + (isCorrect ? xpGained : 0);
    final int newQuizzesCount = _progress.quizzesCompleted + 1;
    final int newCorrectCount =
        _progress.totalCorrectAnswers + (isCorrect ? 1 : 0);

    int newLevel = _progress.currentLevel;
    Map<int, int> newStars = Map.from(_progress.levelStars);

    if (completedLevelIndex != null && isCorrect) {
      newStars[completedLevelIndex] = starsEarned;
      if (completedLevelIndex >= newLevel) {
        newLevel = completedLevelIndex + 1;
      }
    }

    // Check newly unlocked badges
    List<String> newUnlockedBadges = List.from(_progress.unlockedBadgeIds);
    for (var b in QuranDataset.badges) {
      if (newXp >= b.requiredXp && !newUnlockedBadges.contains(b.id)) {
        newUnlockedBadges.add(b.id);
      }
    }

    _progress = _progress.copyWith(
      totalXp: newXp,
      quizzesCompleted: newQuizzesCount,
      totalCorrectAnswers: newCorrectCount,
      currentLevel: newLevel,
      levelStars: newStars,
      unlockedBadgeIds: newUnlockedBadges,
    );

    _updateBadgesState();
    await LocalStorageService.saveProgress(_progress);
    notifyListeners();
  }

  Future<void> resetProgress() async {
    _progress = const UserProgressModel();
    await LocalStorageService.clearData();
    _updateBadgesState();
    notifyListeners();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
