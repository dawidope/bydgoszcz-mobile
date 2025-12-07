import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/data/local/route_storage.dart';
import 'package:bydgoszcz/data/repository/monuments_repository.dart';
import 'package:bydgoszcz/models/generated_route.dart';
import 'package:bydgoszcz/models/route_stop.dart';
import 'package:bydgoszcz/presentation/widgets/buttons/primary_button.dart';
import 'package:bydgoszcz/presentation/widgets/simple_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteAdventurePage extends StatefulWidget {
  final String routeId;

  const RouteAdventurePage({super.key, required this.routeId});

  @override
  State<RouteAdventurePage> createState() => _RouteAdventurePageState();
}

class _RouteAdventurePageState extends State<RouteAdventurePage> {
  final GlobalKey<_SimpleAudioPlayerState> _audioPlayerKey = GlobalKey();

  @override
  void dispose() {
    // Stop audio before navigating away
    _audioPlayerKey.currentState?.stopAudio();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeStorage = RouteStorage();
    final route = routeStorage.getRoute(widget.routeId);

    if (route == null) {
      return _buildNotFoundPage(context);
    }

    return _buildContent(context, route);
  }

  Widget _buildNotFoundPage(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/'),
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
              'Nie znaleziono trasy',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Wróć do strony głównej',
              onPressed: () => context.go('/'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, GeneratedRoute route) {
    final monumentsRepository = MonumentsRepository();
    final allMonuments = monumentsRepository.getAllMonuments();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            pinned: true,
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
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppShadows.soft,
                  ),
                  child: const Icon(
                    Icons.share_rounded,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                onPressed: () {
                  // TODO: Share route
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Title
                Text(
                  route.title,
                  style: AppTypography.headlineLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Story introduction
                _buildStoryCard(route.narration),

                const SizedBox(height: 32),

                // Stops header
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Miejsca do odwiedzenia',
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Stops list
                ...route.stops.map((stop) {
                  final monument = allMonuments.firstWhere(
                    (m) => m.id == stop.id,
                    orElse: () => allMonuments.first,
                  );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _StopCard(
                      stop: stop,
                      imageUrl: monument.imageUrl,
                      onTap: () {
                        context.push('/route/${route.id}/stop/${stop.id}');
                      },
                    ),
                  );
                }),

                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(String story) {
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
                'Historia',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            story,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          SimpleAudioPlayer(
            key: _audioPlayerKey,
            text: story,
            label: 'Posłuchaj bajki',
            color: AppColors.bydgoszczBlue,
          ),
        ],
      ),
    );
  }
}

class _StopCard extends StatelessWidget {
  final RouteStop stop;
  final String imageUrl;
  final VoidCallback onTap;

  const _StopCard({
    required this.stop,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: stop.visited
              ? AppColors.success.withOpacity(0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: stop.visited
                ? AppColors.success
                : AppColors.textDisabled.withOpacity(0.2),
            width: stop.visited ? 2 : 1,
          ),
          boxShadow: AppShadows.card,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image with order badge
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Order badge
                  Positioned(
                    top: -4,
                    left: -4,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: stop.visited
                            ? AppColors.success
                            : AppColors.bydgoszczBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: stop.visited
                            ? const Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: Colors.white,
                              )
                            : Text(
                                '${stop.order}',
                                style: AppTypography.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Name
              Expanded(
                child: Text(
                  stop.name,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Status indicator
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: stop.visited
                      ? AppColors.success
                      : AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  stop.visited
                      ? Icons.check_rounded
                      : Icons.chevron_right_rounded,
                  color: stop.visited ? Colors.white : AppColors.textDisabled,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
