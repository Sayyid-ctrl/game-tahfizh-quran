import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../core/constants/app_colors.dart';
import '../core/data/quran_30juz_index.dart';
import '../core/services/quran_api_service.dart';
import '../models/surah_model.dart';
import '../widgets/quran_verse_card.dart';
import '../widgets/audio_player_widget.dart';

class MurattalScreen extends StatefulWidget {
  const MurattalScreen({super.key});

  @override
  State<MurattalScreen> createState() => _MurattalScreenState();
}

class _MurattalScreenState extends State<MurattalScreen> {
  int _selectedSurahNumber = 1;
  SurahModel? _currentSurah;
  bool _isLoading = true;
  String? _activeAudioUrl;

  @override
  void initState() {
    super.initState();
    _loadSurah(_selectedSurahNumber);
  }

  Future<void> _loadSurah(int surahNumber) async {
    setState(() {
      _isLoading = true;
    });
    final surah = await QuranApiService.getSurahDetail(surahNumber);
    setState(() {
      _currentSurah = surah;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final audioService = gameProvider.audioService;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Murattal & Muraja\'ah 30 Juz'),
      ),
      body: Column(
        children: [
          // Surah Selector Dropdown for 114 Surahs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppColors.cardWhite,
            child: Row(
              children: [
                const Icon(Icons.library_books_rounded, color: AppColors.primaryTeal),
                const SizedBox(width: 12),
                const Text(
                  'Surah:',
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
                        value: _selectedSurahNumber,
                        isExpanded: true,
                        items: Quran30JuzIndex.all114Surahs.map((meta) {
                          return DropdownMenuItem<int>(
                            value: meta.number,
                            child: Text(
                              '${meta.number}. ${meta.nameLatin} (${meta.nameArabic}) • Juz ${meta.juzNumber}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newSurahNumber) {
                          if (newSurahNumber != null) {
                            setState(() {
                              _selectedSurahNumber = newSurahNumber;
                              _activeAudioUrl = null;
                            });
                            audioService.stop();
                            _loadSurah(newSurahNumber);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Loading or Verses List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryTeal),
                  )
                : _currentSurah == null
                    ? const Center(child: Text('Gagal memuat data surah'))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                        itemCount: _currentSurah!.ayahs.length,
                        itemBuilder: (context, index) {
                          final ayah = _currentSurah!.ayahs[index];
                          final bool isPlaying = audioService.isPlaying &&
                              _activeAudioUrl == ayah.audioUrl;

                          return QuranVerseCard(
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
                          );
                        },
                      ),
          ),
        ],
      ),

      // Bottom Audio Player Bar
      bottomSheet: audioService.isPlaying && _activeAudioUrl != null && _currentSurah != null
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: AudioPlayerWidget(
                title: 'Surah ${_currentSurah!.nameLatin}',
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
