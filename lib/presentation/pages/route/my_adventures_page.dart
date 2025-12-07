import 'dart:convert';

import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/data/local/route_storage.dart';
import 'package:bydgoszcz/models/generated_route.dart';
import 'package:bydgoszcz/presentation/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyAdventuresPage extends StatelessWidget {
  const MyAdventuresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final routeStorage = RouteStorage();
    final routes = routeStorage.getAllRoutes();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
          onPressed: () => context.go('/'),
        ),
        title: Text(
          'Moje przygody',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: routes.isEmpty ? _EmptyState() : _AdventuresList(routes: routes),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.explore_outlined,
                size: 64,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Brak przygód',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Nie masz jeszcze żadnych przygód.\nZaplanuj swoją pierwszą trasę!',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Zaplanuj przygodę',
              icon: Icons.add_rounded,
              onPressed: () => context.push('/route/planning'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdventuresList extends StatelessWidget {
  final List<GeneratedRoute> routes;

  const _AdventuresList({required this.routes});

  @override
  Widget build(BuildContext context) {
    final sortedRoutes = List<GeneratedRoute>.from(routes)
      ..sort(
        (a, b) => (b.createdAt ?? DateTime.now()).compareTo(
          a.createdAt ?? DateTime.now(),
        ),
      );

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: sortedRoutes.length,
      itemBuilder: (context, index) {
        final route = sortedRoutes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _AdventureCard(
            route: route,
            onTap: () => context.push('/route/adventure/${route.id}'),
          ),
        );
      },
    );
  }
}

class _AdventureCard extends StatelessWidget {
  final GeneratedRoute route;
  final VoidCallback onTap;

  const _AdventureCard({required this.route, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final visitedCount = route.stops.where((s) => s.visited).length;
    final totalStops = route.stops.length;
    final progress = totalStops > 0 ? visitedCount / totalStops : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image (if available)
            if (route.coverImageBase64 != null &&
                route.coverImageBase64!.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.memory(
                  base64Decode(route.coverImageBase64!),
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 140,
                      color: AppColors.surfaceVariant,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_rounded,
                          color: AppColors.textDisabled,
                          size: 32,
                        ),
                      ),
                    );
                  },
                ),
              ),
            // Header with medal
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: route.coverImageBase64 == null
                    ? LinearGradient(
                        colors: [
                          AppColors.bydgoszczBlue.withOpacity(0.1),
                          AppColors.primary.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                borderRadius: route.coverImageBase64 == null
                    ? const BorderRadius.vertical(top: Radius.circular(20))
                    : null,
              ),
              child: Row(
                children: [
                  // Medal or progress icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getMedalColor(route.medal).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getMedalIcon(route.medal),
                      color: _getMedalColor(route.medal),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route.title,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(route.createdAt ?? DateTime.now()),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textDisabled,
                  ),
                ],
              ),
            ),

            // Progress section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _buildStatChip(
                        Icons.location_on_rounded,
                        '$totalStops miejsc',
                        AppColors.bydgoszczBlue,
                      ),
                      const SizedBox(width: 12),
                      _buildStatChip(
                        Icons.check_circle_rounded,
                        '$visitedCount odwiedzone',
                        AppColors.success,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Progress bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Postęp',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation(
                            route.completed
                                ? AppColors.success
                                : AppColors.primary,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getMedalColor(MedalType? medal) {
    switch (medal) {
      case MedalType.gold:
        return const Color(0xFFFFD700);
      case MedalType.silver:
        return const Color(0xFFC0C0C0);
      case MedalType.bronze:
        return const Color(0xFFCD7F32);
      default:
        return AppColors.bydgoszczBlue;
    }
  }

  IconData _getMedalIcon(MedalType? medal) {
    if (medal != null) {
      return Icons.emoji_events_rounded;
    }
    return Icons.explore_rounded;
  }

  String _formatDate(DateTime date) {
    final months = [
      'stycznia',
      'lutego',
      'marca',
      'kwietnia',
      'maja',
      'czerwca',
      'lipca',
      'sierpnia',
      'września',
      'października',
      'listopada',
      'grudnia',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
