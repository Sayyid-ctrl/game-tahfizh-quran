import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/surah_model.dart';
import '../providers/game_provider.dart';
import '../core/constants/app_colors.dart';
import '../widgets/quran_verse_card.dart';
import '../widgets/audio_player_widget.dart';

class HafalanDetailScreen extends StatefulWidget {
  final SurahModel surah;
  final int levelIndex;

  const HafalanDetailScreen({
    super.key,
    required this.surah,
    required this.levelIndex,
  });

  @override
  State<HafalanDetailScreen> createState() => _HafalanDetailScreenState();
}

class _HafalanDetailScreenState extends State<HafalanDetailScreen> {
  String? _activeAudioUrl;
  final Set<int> _memorizedAyahs = {};

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final audioService = gameProvider.audioService;
    final double completionProgress = widget.surah.ayahs.isNotEmpty
        ? (_memorizedAyahs.length / widget.surah.ayahs.length)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Latihan Hafalan Level ${widget.levelIndex}'),
      ),
      body: Column(
        children: [
          // Surah Header Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Surah ${widget.surah.nameLatin}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.surah.translation} • ${widget.surah.numberOfAyahs} Ayat',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.surah.nameArabic,
                      style: const TextStyle(
                        color: AppColors.accentGold,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Memorization progress indicator
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: completionProgress,
                          backgroundColor: Colors.white24,
                          color: AppColors.accentGold,
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(completionProgress * 100).toInt()}% Dihafal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Verses list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: widget.surah.ayahs.length,
              itemBuilder: (context, index) {
                final ayah = widget.surah.ayahs[index];
                final bool isPlaying =
                    audioService.isPlaying && _activeAudioUrl == ayah.audioUrl;
                final bool isMemorized = _memorizedAyahs.contains(ayah.numberInSurah);

                return Stack(
                  children: [
                    QuranVerseCard(
                      ayahNumber: ayah.numberInSurah,
                      textArabic: ayah.textArabic,
                      textTranslation: ayah.textTranslation,
                      textTransliteration: ayah.textTransliteration,
                      audioUrl: ayah.audioUrl,
                      isPlaying: isPlaying,
                      onPlayAudio: () {
                        setState(() {
                          _activeAudioUrl = ayah.audioUrl;
                        });
                        audioService.playAudioUrl(ayah.audioUrl);
                      },
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: IconButton(
                        icon: Icon(
                          isMemorized
                              ? Icons.check_circle_rounded
                              : Icons.check_circle_outline_rounded,
                          color: isMemorized
                              ? AppColors.successGreen
                              : Colors.grey.shade400,
                          size: 26,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isMemorized) {
                              _memorizedAyahs.remove(ayah.numberInSurah);
                            } else {
                              _memorizedAyahs.add(ayah.numberInSurah);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: audioService.isPlaying && _activeAudioUrl != null
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: AudioPlayerWidget(
                title: 'Surah ${widget.surah.nameLatin}',
                subtitle: 'Lantunan Murattal Syaikh Mishary Alafasy',
                isPlaying: audioService.isPlaying,
                onPlayPause: () {
                  if (_activeAudioUrl != null) {
                    audioService.playAudioUrl(_activeAudioUrl!);
                    setState(() {});
                  }
                },
                onStop: () {
                  audioService.stop();
                  setState(() {
                    _activeAudioUrl = null;
                  });
                },
              ),
            )
          : null,
    );
  }
}
