import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_themes.dart';

class QuranVerseCard extends StatelessWidget {
  final int ayahNumber;
  final String textArabic;
  final String textTranslation;
  final String textTransliteration;
  final String? audioUrl;
  final bool isPlaying;
  final VoidCallback? onPlayAudio;

  const QuranVerseCard({
    super.key,
    required this.ayahNumber,
    required this.textArabic,
    required this.textTranslation,
    required this.textTransliteration,
    this.audioUrl,
    this.isPlaying = false,
    this.onPlayAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isPlaying ? AppColors.emeraldLight.withOpacity(0.3) : AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPlaying ? AppColors.secondaryEmerald : Colors.grey.shade200,
          width: isPlaying ? 1.5 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.primaryTeal,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$ayahNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              if (onPlayAudio != null)
                IconButton(
                  onPressed: onPlayAudio,
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                    color: AppColors.secondaryEmerald,
                    size: 36,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            textArabic,
            textAlign: TextAlign.right,
            direction: TextDirection.rtl,
            style: AppThemes.arabicTextStyle(fontSize: 26),
          ),
          const SizedBox(height: 12),
          if (textTransliteration.isNotEmpty)
            Text(
              textTransliteration,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.primaryTeal,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 6),
          Text(
            textTranslation,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
