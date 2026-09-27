import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class LevelNodeWidget extends StatelessWidget {
  final int levelIndex;
  final String title;
  final String arabicTitle;
  final bool isUnlocked;
  final int stars; // 0..5 bintang
  final VoidCallback onTap;

  const LevelNodeWidget({
    super.key,
    required this.levelIndex,
    required this.title,
    required this.arabicTitle,
    required this.isUnlocked,
    required this.stars,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: Column(
        children: [
          // 1-5 Star Rating Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(
                index < stars ? Icons.star_rounded : Icons.star_border_rounded,
                color: isUnlocked ? AppColors.accentGold : Colors.grey.shade400,
                size: 16,
              );
            }),
          ),
          const SizedBox(height: 4),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isUnlocked
                  ? AppColors.primaryGradient
                  : LinearGradient(
                      colors: [Colors.grey.shade400, Colors.grey.shade500],
                    ),
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: AppColors.primaryTeal.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
              border: Border.all(
                color: isUnlocked ? AppColors.accentGold : Colors.white,
                width: 3,
              ),
            ),
            child: Center(
              child: isUnlocked
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$levelIndex',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          arabicTitle,
                          style: const TextStyle(
                            color: AppColors.goldLight,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : const Icon(
                      Icons.lock_rounded,
                      color: Colors.white70,
                      size: 32,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? AppColors.primaryTealDark.withOpacity(0.08)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isUnlocked ? AppColors.primaryTeal : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
