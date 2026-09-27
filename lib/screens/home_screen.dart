import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/islamic_header.dart';
import '../widgets/islamic_card.dart';
import '../core/constants/app_colors.dart';
import 'level_map_screen.dart';
import 'quiz_sambung_ayat_screen.dart';
import 'quiz_tebak_surat_screen.dart';
import 'murattal_screen.dart';
import 'badges_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        if (gameProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryTeal,
              ),
            ),
          );
        }

        final progress = gameProvider.progress;

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IslamicHeader(
                  title: 'ASSALAMU\'ALAIKUM',
                  subtitle: 'Game Edukasi Tahfizh',
                  playerTitle: progress.playerTitle,
                  totalXp: progress.totalXp,
                  streakDays: progress.streakDays,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pilih Mode Permainan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      IslamicCard(
                        title: 'Peta Level Hafalan',
                        subtitle: 'Selesaikan misi per tingkat Surah Juz 30',
                        icon: Icons.map_rounded,
                        iconColor: AppColors.primaryTeal,
                        gradient: AppColors.cardGradient,
                        badgeText: 'Level ${progress.currentLevel}',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LevelMapScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      IslamicCard(
                        title: 'Kuis Sambung Ayat',
                        subtitle: 'Lanjutkan potongan ayat Al-Qur\'an dengan benar',
                        icon: Icons.alt_route_rounded,
                        iconColor: AppColors.accentAmber,
                        badgeText: '+50 XP',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QuizSambungAyatScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      IslamicCard(
                        title: 'Kuis Tebak Surat',
                        subtitle: 'Dengarkan/baca ayat & tebak nama surahnya',
                        icon: Icons.psychology_rounded,
                        iconColor: AppColors.infoBlue,
                        badgeText: '+50 XP',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QuizTebakSuratScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Fitur Tambahan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSmallFeatureCard(
                              context: context,
                              title: 'Murattal',
                              subtitle: 'Muraja\'ah Audio',
                              icon: Icons.headset_rounded,
                              color: AppColors.secondaryEmerald,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MurattalScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSmallFeatureCard(
                              context: context,
                              title: 'Badge',
                              subtitle: 'Galeri Lencana',
                              icon: Icons.military_tech_rounded,
                              color: AppColors.accentGold,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const BadgesScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildSmallFeatureCard(
                        context: context,
                        title: 'Progres & Statistik',
                        subtitle: 'Pantau hafalan, kuis selesai & pencapaian',
                        icon: Icons.bar_chart_rounded,
                        color: AppColors.primaryTeal,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProgressScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSmallFeatureCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
