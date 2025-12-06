import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/models/generated_route.dart';
import 'package:bydgoszcz/models/monument.dart';
import 'package:bydgoszcz/models/route_stop.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmPresencePage extends StatelessWidget {
  final GeneratedRoute route;
  final RouteStop stop;
  final Monument monument;

  const ConfirmPresencePage({
    super.key,
    required this.route,
    required this.stop,
    required this.monument,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppShadows.soft,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppColors.textPrimary,
            ),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  size: 64,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                'Potwierdź obecność',
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Czy jesteś przy ${stop.name}?',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Możesz potwierdzić swoją obecność zdjęciem lub bez niego.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textDisabled,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Options
              _OptionCard(
                icon: Icons.camera_alt_rounded,
                title: 'Potwierdź zdjęciem',
                subtitle: 'Zrób zdjęcie miejsca, a sprawdzimy czy to ono',
                color: AppColors.bydgoszczBlue,
                onTap: () {
                  context.push(
                    '/route/${route.id}/stop/${stop.id}/verify-photo',
                    extra: {'route': route, 'stop': stop, 'monument': monument},
                  );
                },
              ),
              const SizedBox(height: 16),
              _OptionCard(
                icon: Icons.check_circle_outline_rounded,
                title: 'Potwierdź bez zdjęcia',
                subtitle: 'Zaufaj, że jesteś na miejscu',
                color: AppColors.success,
                onTap: () {
                  context.push(
                    '/route/${route.id}/stop/${stop.id}/quiz',
                    extra: {'route': route, 'stop': stop, 'monument': monument},
                  );
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.card,
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
