import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/surah_model.dart';
import '../data/quran_dataset.dart';
import '../data/quran_30juz_index.dart';

class QuranApiService {
  static final Map<int, SurahModel> _cachedSurahs = {};

  static Future<SurahModel> getSurahDetail(int surahNumber) async {
    // Check if in-memory cache has it
    if (_cachedSurahs.containsKey(surahNumber)) {
      return _cachedSurahs[surahNumber]!;
    }

    // Check if pre-packaged dataset has it
    final localSurah = QuranDataset.surahs.where((s) => s.number == surahNumber).firstOrNull;
    if (localSurah != null && localSurah.ayahs.isNotEmpty) {
      _cachedSurahs[surahNumber] = localSurah;
      return localSurah;
    }

    // Fetch from Alquran Cloud API
    try {
      final url = Uri.parse(
          'https://api.alquran.cloud/v1/surah/$surahNumber/editions/quran-uthmani,id.indonesian,ar.alafasy');
      final response = await http.get(url).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final editions = data['data'] as List;

        final arabicAyahs = editions[0]['ayahs'] as List;
        final translationAyahs = editions[1]['ayahs'] as List;
        final audioAyahs = editions[2]['ayahs'] as List;

        List<AyahModel> ayahs = [];
        for (int i = 0; i < arabicAyahs.length; i++) {
          ayahs.add(
            AyahModel(
              numberInSurah: arabicAyahs[i]['numberInSurah'] as int,
              textArabic: arabicAyahs[i]['text'] as String,
              textTranslation: translationAyahs[i]['text'] as String,
              textTransliteration: '',
              audioUrl: audioAyahs[i]['audio'] as String,
            ),
          );
        }

        final metaInfo = Quran30JuzIndex.all114Surahs.firstWhere(
          (s) => s.number == surahNumber,
          orElse: () => SurahMetaInfo(
            number: surahNumber,
            nameArabic: editions[0]['name'],
            nameLatin: editions[0]['englishName'],
            translation: editions[0]['englishNameTranslation'],
            numberOfAyahs: ayahs.length,
            juzNumber: 1,
            type: 'Makkiyah',
          ),
        );

        final result = SurahModel(
          number: surahNumber,
          nameArabic: metaInfo.nameArabic,
          nameLatin: metaInfo.nameLatin,
          translation: metaInfo.translation,
          numberOfAyahs: ayahs.length,
          juzNumber: metaInfo.juzNumber,
          ayahs: ayahs,
        );

        _cachedSurahs[surahNumber] = result;
        return result;
      }
    } catch (e) {
      // Fallback fallback metadata representation
    }

    final metaInfo = Quran30JuzIndex.all114Surahs.firstWhere(
      (s) => s.number == surahNumber,
      orElse: () => const SurahMetaInfo(
        number: 1,
        nameArabic: 'الفاتحة',
        nameLatin: 'Al-Fatihah',
        translation: 'Pembukaan',
        numberOfAyahs: 7,
        juzNumber: 1,
        type: 'Makkiyah',
      ),
    );

    return SurahModel(
      number: metaInfo.number,
      nameArabic: metaInfo.nameArabic,
      nameLatin: metaInfo.nameLatin,
      translation: metaInfo.translation,
      numberOfAyahs: metaInfo.numberOfAyahs,
      juzNumber: metaInfo.juzNumber,
      ayahs: const [
        AyahModel(
          numberInSurah: 1,
          textArabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          textTranslation: 'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang.',
          textTransliteration: 'Bismillahir-rahmanir-rahim',
          audioUrl: 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1.mp3',
        )
      ],
    );
  }
}
