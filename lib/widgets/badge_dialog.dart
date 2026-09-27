import 'package:flutter/material.dart';
import '../models/badge_model.dart';
import '../core/constants/app_colors.dart';

class BadgeDialog extends StatelessWidget {
  final BadgeModel badge;

  const BadgeDialog({super.key, required this.badge});

  static void show(BuildContext context, BadgeModel badge) {
    showDialog(
      context: context,
      builder: (_) => BadgeDialog(badge: badge),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.goldLight,
                border: Border.all(color: AppColors.accentGold, width: 3),
              ),
              child: Icon(
                badge.icon,
                size: 60,
                color: badge.iconColor,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Selamat! Badge Baru Terbuka',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTeal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              badge.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Alhamdulillah'),
            ),
          ],
        ),
      ),
    );
  }
}
