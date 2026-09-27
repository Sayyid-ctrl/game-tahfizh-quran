import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_themes.dart';
import '../core/data/quran_dataset.dart';

class QuizTebakSuratScreen extends StatefulWidget {
  const QuizTebakSuratScreen({super.key});

  @override
  State<QuizTebakSuratScreen> createState() => _QuizTebakSuratScreenState();
}

class _QuizTebakSuratScreenState extends State<QuizTebakSuratScreen> {
  int _currentIndex = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;
  int _scoreThisSession = 0;

  @override
  Widget build(BuildContext context) {
    final questions = QuranDataset.quizTebakSurat;
    if (_currentIndex >= questions.length) {
      return _buildCompletionScreen();
    }

    final currentQuestion = questions[_currentIndex];
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuis Tebak Surat'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (_currentIndex + 1) / questions.length,
                backgroundColor: Colors.grey.shade200,
                color: AppColors.infoBlue,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Soal ${_currentIndex + 1} dari ${questions.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.infoBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Tebak Nama Surah',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.infoBlue,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(color: AppColors.infoBlue.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Text(
                    'Potongan ayat berikut ini berada di dalam Surah apa?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentQuestion.promptText,
                    textAlign: TextAlign.center,
                    direction: TextDirection.rtl,
                    style: AppThemes.arabicTextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 16),
                  if (currentQuestion.audioUrl != null)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.infoBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        gameProvider.audioService.playAudioUrl(currentQuestion.audioUrl!);
                      },
                      icon: const Icon(Icons.volume_up_rounded),
                      label: const Text('Putar Audio Recitation'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(currentQuestion.options.length, (index) {
              final optionText = currentQuestion.options[index];
              final isSelected = _selectedOptionIndex == index;
              final isCorrect = index == currentQuestion.correctOptionIndex;

              Color optionColor = AppColors.cardWhite;
              Color borderColor = Colors.grey.shade300;
              Color textColor = AppColors.textDark;

              if (_isAnswered) {
                if (isCorrect) {
                  optionColor = AppColors.emeraldLight;
                  borderColor = AppColors.successGreen;
                  textColor = AppColors.successGreen;
                } else if (isSelected) {
                  optionColor = const Color(0xFFFDEDEC);
                  borderColor = AppColors.errorRed;
                  textColor = AppColors.errorRed;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: _isAnswered
                      ? null
                      : () => _handleAnswer(index, currentQuestion.correctOptionIndex),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: optionColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isAnsweredIcon(index, currentQuestion.correctOptionIndex),
                          color: textColor,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          optionText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            if (_isAnswered) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.goldLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.infoBlue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${currentQuestion.explanation} (Lanjut otomatis...)',
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData isAnsweredIcon(int index, int correctIndex) {
    if (!_isAnswered) return Icons.radio_button_unchecked_rounded;
    if (index == correctIndex) return Icons.check_circle_rounded;
    if (_selectedOptionIndex == index) return Icons.cancel_rounded;
    return Icons.radio_button_unchecked_rounded;
  }

  void _handleAnswer(int selectedIndex, int correctIndex) {
    setState(() {
      _selectedOptionIndex = selectedIndex;
      _isAnswered = true;
    });

    final bool isCorrect = selectedIndex == correctIndex;
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    if (isCorrect) {
      _scoreThisSession += 50;
      gameProvider.addQuizScore(
        xpGained: 50,
        isCorrect: true,
      );
    }

    // Auto advance to next question after 1.4 seconds delay automatically!
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex++;
      _selectedOptionIndex = null;
      _isAnswered = false;
    });
  }

  Widget _buildCompletionScreen() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.psychology_rounded,
                size: 90,
                color: AppColors.infoBlue,
              ),
              const SizedBox(height: 20),
              const Text(
                'MasyaAllah!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Anda telah menyelesaikan Kuis Tebak Surat!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 16),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.goldLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '+$_scoreThisSession XP Berhasil Didapatkan',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.infoBlue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali ke Menu Utama'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
