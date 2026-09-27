enum QuizType {
  sambungAyat,
  tebakSurat,
}

class QuizQuestionModel {
  final String id;
  final QuizType type;
  final String promptText;
  final String? audioUrl;
  final String surahName;
  final int ayahNumber;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  const QuizQuestionModel({
    required this.id,
    required this.type,
    required this.promptText,
    this.audioUrl,
    required this.surahName,
    required this.ayahNumber,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
}
