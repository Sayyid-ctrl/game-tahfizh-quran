import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../core/constants/app_colors.dart';
import '../models/badge_model.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final badges = gameProvider.badges;
        final unlockedCount = badges.where((b) => b.isUnlocked).length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Galeri Badge Pencapaian'),
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.military_tech_rounded,
                        color: AppColors.accentGold,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$unlockedCount dari ${badges.length} Badge Terbuka',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kumpulkan skor XP & selesaikan kuis!',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: badges.length,
                  itemBuilder: (context, index) {
                    final badge = badges[index];
                    return _buildBadgeCard(context, badge);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadgeCard(BuildContext context, BadgeModel badge) {
    return InkWell(
      onTap: () {
        _showBadgeDetails(context, badge);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: badge.isUnlocked ? AppColors.cardWhite : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: badge.isUnlocked
                ? badge.iconColor.withOpacity(0.4)
                : Colors.grey.shade300,
            width: badge.isUnlocked ? 1.5 : 1,
          ),
          boxShadow: badge.isUnlocked
              ? [
                  BoxShadow(
                    color: badge.iconColor.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badge.isUnlocked
                    ? badge.iconColor.withOpacity(0.15)
                    : Colors.grey.shade300,
              ),
              child: Icon(
                badge.isUnlocked ? badge.icon : Icons.lock_rounded,
                color: badge.isUnlocked ? badge.iconColor : Colors.grey.shade600,
                size: 36,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              badge.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: badge.isUnlocked ? AppColors.textDark : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              badge.isUnlocked ? 'Terbuka' : 'Syarat: ${badge.requiredXp} XP',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: badge.isUnlocked ? AppColors.successGreen : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetails(BuildContext context, BadgeModel badge) {
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
              Icon(
                badge.isUnlocked ? badge.icon : Icons.lock_rounded,
                size: 64,
                color: badge.isUnlocked ? badge.iconColor : Colors.grey,
              ),
              const SizedBox(height: 14),
              Text(
                badge.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                badge.description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: badge.isUnlocked ? AppColors.goldLight : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge.isUnlocked
                      ? 'Status: Lencana Telah Diraih!'
                      : 'Membutuhkan minimal ${badge.requiredXp} XP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: badge.isUnlocked ? AppColors.textDark : Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
