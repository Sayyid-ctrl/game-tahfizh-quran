import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../core/constants/app_colors.dart';
import '../core/data/quran_30juz_index.dart';
import '../core/services/quran_api_service.dart';
import '../widgets/level_node_widget.dart';
import 'hafalan_detail_screen.dart';
import 'quiz_sambung_ayat_screen.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  int _selectedJuz = 30; // Default to Juz 30, can select 1..30

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final progress = gameProvider.progress;
        final surahsInJuz = Quran30JuzIndex.getSurahsByJuz(_selectedJuz);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Peta Level Hafalan 30 Juz'),
          ),
          body: Column(
            children: [
              // Juz Selector Bar (Juz 1 to 30)
              Container(
                color: AppColors.cardWhite,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.bookmark_rounded, color: AppColors.primaryTeal),
                    const SizedBox(width: 8),
                    const Text(
                      'Pilih Juz:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.bgIvory,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _selectedJuz,
                            isExpanded: true,
                            items: List.generate(30, (index) => index + 1).map((juzNum) {
                              return DropdownMenuItem<int>(
                                value: juzNum,
                                child: Text(
                                  'Juz $juzNum (${Quran30JuzIndex.getSurahsByJuz(juzNum).length} Surah)',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.primaryTeal,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newJuz) {
                              if (newJuz != null) {
                                setState(() {
                                  _selectedJuz = newJuz;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Level Map Path
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.bgIvory, Colors.emerald.shade50],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: surahsInJuz.isEmpty
                      ? const Center(child: Text('Belum ada data untuk Juz ini'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          itemCount: surahsInJuz.length,
                          itemBuilder: (context, index) {
                            final levelNumber = index + 1;
                            final surahMeta = surahsInJuz[index];
                            final bool isUnlocked = levelNumber <= progress.currentLevel;
                            final int stars = progress.levelStars[levelNumber] ?? (isUnlocked ? 5 : 0);

                            final double alignOffset = (index % 2 == 0) ? -0.4 : 0.4;

                            return Column(
                              children: [
                                Align(
                                  alignment: Alignment(alignOffset, 0),
                                  child: LevelNodeWidget(
                                    levelIndex: levelNumber,
                                    title: surahMeta.nameLatin,
                                    arabicTitle: surahMeta.nameArabic,
                                    isUnlocked: isUnlocked,
                                    stars: stars,
                                    onTap: () async {
                                      _showLevelDialog(context, surahMeta, levelNumber);
                                    },
                                  ),
                                ),
                                if (index < surahsInJuz.length - 1)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: CustomPaint(
                                      size: const Size(40, 30),
                                      painter: PathConnectorPainter(
                                        isUnlocked: levelNumber < progress.currentLevel,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLevelDialog(BuildContext context, SurahMetaInfo surahMeta, int levelNumber) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Juz ${surahMeta.juzNumber} • Level $levelNumber: ${surahMeta.nameLatin}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${surahMeta.nameArabic} (${surahMeta.translation}) • ${surahMeta.numberOfAyahs} Ayat • ${surahMeta.type}',
                style: const TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: AppColors.primaryTeal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  // Load full surah detail
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child: CircularProgressIndicator(color: AppColors.primaryTeal),
                    ),
                  );
                  final fullSurah = await QuranApiService.getSurahDetail(surahMeta.number);
                  if (context.mounted) {
                    Navigator.pop(context); // close loader
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HafalanDetailScreen(
                          surah: fullSurah,
                          levelIndex: levelNumber,
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.menu_book_rounded, color: AppColors.primaryTeal),
                label: const Text(
                  'Latihan Hafalan Surah',
                  style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizSambungAyatScreen(
                        levelIndex: levelNumber,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Mulai Kuis Level Ini'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PathConnectorPainter extends CustomPainter {
  final bool isUnlocked;

  PathConnectorPainter({required this.isUnlocked});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isUnlocked ? AppColors.primaryTeal : Colors.grey.shade300
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 2, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
