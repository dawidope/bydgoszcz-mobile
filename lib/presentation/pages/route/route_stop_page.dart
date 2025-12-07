import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/data/local/route_storage.dart';
import 'package:bydgoszcz/data/repository/monuments_repository.dart';
import 'package:bydgoszcz/models/generated_route.dart';
import 'package:bydgoszcz/models/monument.dart';
import 'package:bydgoszcz/models/route_stop.dart';
import 'package:bydgoszcz/presentation/widgets/simple_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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

class _RouteStopContent extends StatefulWidget {
  final GeneratedRoute route;
  final RouteStop stop;
  final Monument monument;

  const _RouteStopContent({
    required this.route,
    required this.stop,
    required this.monument,
  });

  @override
  State<_RouteStopContent> createState() => _RouteStopContentState();
}

class _RouteStopContentState extends State<_RouteStopContent> {
  final GlobalKey<_SimpleAudioPlayerState> _audioPlayerKey = GlobalKey();

  @override
  void dispose() {
    // Stop audio before navigating away
    _audioPlayerKey.currentState?.stopAudio();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar z obrazkiem
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
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
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    monument.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.surfaceVariant,
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
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStopBadge(),
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
        ],
      ),
    );
  }

  Widget _buildStopBadge() {
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
          const SizedBox(height: 16),
          SimpleAudioPlayer(
            text: stop.shortStory,
            label: 'Posłuchaj bajki',
            color: AppColors.bydgoszczBlue,
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
          onTap: () async {
            if (monument.googleMapsUrl.isNotEmpty) {
              final uri = Uri.parse(monument.googleMapsUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            }
          },
        ),
        const SizedBox(height: 12),
        _ActionButton(
          icon: Icons.info_rounded,
          label: 'Szczegóły zabytku',
          color: AppColors.accent,
          onTap: () {
            context.push('/monuments/detail/${monument.id}', extra: monument);
          },
        ),
        const SizedBox(height: 12),
        _ActionButton(
          icon: stop.visited
              ? Icons.check_circle_rounded
              : Icons.location_on_rounded,
          label: stop.visited ? 'Odwiedzone ✓' : 'Potwierdź obecność',
          color: AppColors.success,
          onTap: stop.visited
              ? null
              : () {
                  context.push(
                    '/route/${route.id}/stop/${stop.id}/confirm',
                    extra: {'route': route, 'stop': stop, 'monument': monument},
                  );
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
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDisabled ? AppColors.surfaceVariant : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDisabled
                ? AppColors.textDisabled.withOpacity(0.3)
                : color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDisabled
                    ? AppColors.textDisabled.withOpacity(0.2)
                    : color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDisabled ? AppColors.textDisabled : color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTypography.titleSmall.copyWith(
                  color: isDisabled ? AppColors.textDisabled : color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: isDisabled ? AppColors.textDisabled : color,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
