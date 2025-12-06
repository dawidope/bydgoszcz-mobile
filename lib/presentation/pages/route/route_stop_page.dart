import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/data/local/route_storage.dart';
import 'package:bydgoszcz/data/repository/monuments_repository.dart';
import 'package:bydgoszcz/models/generated_route.dart';
import 'package:bydgoszcz/models/monument.dart';
import 'package:bydgoszcz/models/route_stop.dart';
import 'package:bydgoszcz/presentation/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteStopPage extends StatelessWidget {
  final String routeId;
  final String stopId;

  const RouteStopPage({super.key, required this.routeId, required this.stopId});

  @override
  Widget build(BuildContext context) {
    final routeStorage = RouteStorage();
    final route = routeStorage.getRoute(routeId);

    if (route == null) {
      return _NotFoundPage(message: 'Nie znaleziono trasy');
    }

    try {
      final stop = route.stops.firstWhere((s) => s.id == stopId);
      final monumentsRepository = MonumentsRepository();
      final monument = monumentsRepository.getMonumentById(stopId);

      if (monument == null) {
        return _NotFoundPage(message: 'Nie znaleziono zabytku');
      }

      return _RouteStopContent(route: route, stop: stop, monument: monument);
    } catch (e) {
      return _NotFoundPage(message: 'Nie znaleziono przystanku');
    }
  }
}

class _NotFoundPage extends StatelessWidget {
  final String message;

  const _NotFoundPage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteStopContent extends StatelessWidget {
  final GeneratedRoute route;
  final RouteStop stop;
  final Monument monument;

  const _RouteStopContent({
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildMonumentImage(),
                const SizedBox(height: 24),
                _buildStorySection(),
                const SizedBox(height: 24),
                _buildFunFactSection(),
                const SizedBox(height: 32),
                _buildActionButtons(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: stop.visited
                    ? AppColors.success
                    : AppColors.bydgoszczBlue,
                shape: BoxShape.circle,
                boxShadow: AppShadows.soft,
              ),
              child: Center(
                child: stop.visited
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 24,
                      )
                    : Text(
                        '${stop.order}',
                        style: AppTypography.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Przystanek ${stop.order}',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    route.title,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textDisabled,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          stop.name,
          style: AppTypography.displaySmall.copyWith(
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildMonumentImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        monument.imageUrl,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(
                Icons.image_not_supported_rounded,
                size: 64,
                color: AppColors.textDisabled,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStorySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.bydgoszczBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: AppColors.bydgoszczBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Twoja przygoda',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            stop.shortStory,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunFactSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: AppColors.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ciekawostka',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  stop.funFact,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _ActionButton(
          icon: Icons.map_rounded,
          label: 'Otwórz w mapie',
          color: AppColors.bydgoszczBlue,
          onTap: () {
            // TODO: Open map with monument location
          },
        ),
        const SizedBox(height: 12),
        _ActionButton(
          icon: Icons.info_rounded,
          label: 'Szczegóły zabytku',
          color: AppColors.primary,
          onTap: () {
            // TODO: Navigate to monument details
          },
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: stop.visited ? 'Odwiedzone ✓' : 'Potwierdź obecność',
          icon: stop.visited
              ? Icons.check_circle_rounded
              : Icons.location_on_rounded,
          onPressed: stop.visited
              ? null
              : () {
                  // TODO: Confirm presence
                },
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTypography.titleSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
