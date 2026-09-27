import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../core/constants/app_colors.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final progress = gameProvider.progress;
        final double accuracy = progress.quizzesCompleted > 0
            ? (progress.totalCorrectAnswers / progress.quizzesCompleted) * 100
            : 0.0;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Progres & Statistik Hafalan'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Badge & XP Progress Summary
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.goldLight,
                        child: Icon(
                          Icons.person_rounded,
                          color: AppColors.primaryTeal,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              progress.playerTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Level ${progress.currentLevel} • Juz 30',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: (progress.totalXp % 500) / 500,
                                backgroundColor: Colors.white24,
                                color: AppColors.accentGold,
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Statistik Permainan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 14),

                // Grid of statistics cards
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.3,
                  children: [
                    _buildStatCard(
                      title: 'Total Skor XP',
                      value: '${progress.totalXp} XP',
                      icon: Icons.stars_rounded,
                      color: AppColors.accentAmber,
                    ),
                    _buildStatCard(
                      title: 'Kuis Selesai',
                      value: '${progress.quizzesCompleted} Kuis',
                      icon: Icons.quiz_rounded,
                      color: AppColors.secondaryEmerald,
                    ),
                    _buildStatCard(
                      title: 'Jawaban Benar',
                      value: '${progress.totalCorrectAnswers}',
                      icon: Icons.check_circle_rounded,
                      color: AppColors.successGreen,
                    ),
                    _buildStatCard(
                      title: 'Akurasi Kuis',
                      value: '${accuracy.toStringAsFixed(1)}%',
                      icon: Icons.pie_chart_rounded,
                      color: AppColors.infoBlue,
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                const Text(
                  'Kelengkapan Level Juz Amma',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progres Pembukaan Level',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${progress.currentLevel} / 6 Surah',
                            style: const TextStyle(
                              color: AppColors.primaryTeal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (progress.currentLevel / 6).clamp(0.0, 1.0),
                          backgroundColor: Colors.grey.shade200,
                          color: AppColors.primaryTeal,
                          minHeight: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Reset data button
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      _showResetDialog(context, gameProvider);
                    },
                    icon: const Icon(Icons.refresh_rounded, color: AppColors.errorRed),
                    label: const Text(
                      'Reset Progres & Data Lokal',
                      style: TextStyle(color: AppColors.errorRed),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, GameProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Progres?'),
          content: const Text(
            'Seluruh skor XP, level yang terbuka, dan lencana akan dikembalikan ke kondisi awal.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
              ),
              onPressed: () {
                provider.resetProgress();
                Navigator.pop(context);
              },
              child: const Text('Reset Data'),
            ),
          ],
        );
      },
    );
  }
}
