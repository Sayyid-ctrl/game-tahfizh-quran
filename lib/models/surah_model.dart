class AyahModel {
  final int numberInSurah;
  final String textArabic;
  final String textTranslation;
  final String textTransliteration;
  final String audioUrl;

  const AyahModel({
    required this.numberInSurah,
    required this.textArabic,
    required this.textTranslation,
    required this.textTransliteration,
    required this.audioUrl,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      numberInSurah: json['numberInSurah'] as int,
      textArabic: json['textArabic'] as String,
      textTranslation: json['textTranslation'] as String,
      textTransliteration: json['textTransliteration'] as String? ?? '',
      audioUrl: json['audioUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numberInSurah': numberInSurah,
      'textArabic': textArabic,
      'textTranslation': textTranslation,
      'textTransliteration': textTransliteration,
      'audioUrl': audioUrl,
    };
  }
}

class SurahModel {
  final int number;
  final String nameArabic;
  final String nameLatin;
  final String translation;
  final int numberOfAyahs;
  final int juzNumber;
  final List<AyahModel> ayahs;

  const SurahModel({
    required this.number,
    required this.nameArabic,
    required this.nameLatin,
    required this.translation,
    required this.numberOfAyahs,
    required this.juzNumber,
    required this.ayahs,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int,
      nameArabic: json['nameArabic'] as String,
      nameLatin: json['nameLatin'] as String,
      translation: json['translation'] as String,
      numberOfAyahs: json['numberOfAyahs'] as int,
      juzNumber: json['juzNumber'] as int? ?? 30,
      ayahs: (json['ayahs'] as List<dynamic>?)
              ?.map((e) => AyahModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'nameArabic': nameArabic,
      'nameLatin': nameLatin,
      'translation': translation,
      'numberOfAyahs': numberOfAyahs,
      'juzNumber': juzNumber,
      'ayahs': ayahs.map((e) => e.toJson()).toList(),
    };
  }
}
