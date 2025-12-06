import 'dart:io';

import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/data/repository/monuments_repository.dart';
import 'package:bydgoszcz/models/monument.dart';
import 'package:bydgoszcz/presentation/widgets/audio_player_widget.dart';
import 'package:bydgoszcz/presentation/widgets/buttons/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MonumentDetailPage extends StatelessWidget {
  final String? monumentId;
  final Monument? monument;

  const MonumentDetailPage({super.key, this.monumentId, this.monument})
    : assert(
        monumentId != null || monument != null,
        'Either monumentId or monument must be provided',
      );

  Future<void> _openGoogleMaps(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareMonument(Monument monument) async {
    final shareText =
        '''
🏛️ ${monument.name}

${monument.shortDescription}

📍 Zobacz na mapie: ${monument.googleMapsUrl.isNotEmpty ? monument.googleMapsUrl : 'Brak lokalizacji'}

Odkryj więcej zabytków Bydgoszczy! 🌟
''';

    await Share.share(shareText, subject: monument.name);
  }

  @override
  Widget build(BuildContext context) {
    final Monument? displayMonument =
        monument ??
        (monumentId != null
            ? MonumentsRepository().getMonumentById(monumentId!)
            : null);

    if (displayMonument == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Błąd'),
        ),
        body: const Center(child: Text('Nie znaleziono zabytku')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
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
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final isCollapsed =
                    constraints.maxHeight <= kToolbarHeight + 50;

                return FlexibleSpaceBar(
                  title: AnimatedOpacity(
                    opacity: isCollapsed ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      displayMonument.name,
                      style: AppTypography.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  titlePadding: const EdgeInsets.only(
                    left: 60,
                    bottom: 16,
                    right: 16,
                  ),
                  centerTitle: false,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Audio player lub obrazek
                      if (displayMonument.audioUrl != null)
                        AudioPlayerWidget(
                          roundedCorners: false,
                          audioAssetPath: displayMonument.audioUrl!,
                          imageAssetPath: displayMonument.imageUrl,
                        )
                      else
                        _buildImage(displayMonument.imageUrl),
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
                );
              },
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              transform: Matrix4.translationValues(0, -24, 0),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kolorowy pasek dekoracyjny
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.bydgoszczRed,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 20,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.bydgoszczYellow,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 10,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.bydgoszczBlue,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Nazwa
                    Text(
                      displayMonument.name,
                      style: AppTypography.displaySmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Krótki opis w boxie
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.bydgoszczYellow.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.lightbulb_outline_rounded,
                              color: AppColors.bydgoszczYellow,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              displayMonument.shortDescription,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Sekcja "Historia"
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.bydgoszczBlue,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Historia',
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Pełny opis
                    Text(
                      displayMonument.facts,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Przycisk nawigacji
                    if (displayMonument.googleMapsUrl.isNotEmpty)
                      PrimaryButton(
                        label: 'Nawiguj do zabytku',
                        icon: Icons.map_rounded,
                        onPressed: () =>
                            _openGoogleMaps(displayMonument.googleMapsUrl),
                      ),
                    if (displayMonument.googleMapsUrl.isNotEmpty)
                      const SizedBox(height: 16),
                    // Przycisk udostępniania
                    SecondaryButton(
                      label: 'Udostępnij',
                      icon: Icons.share_rounded,
                      color: AppColors.bydgoszczBlue,
                      onPressed: () => _shareMonument(displayMonument),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    final isFilePath =
        imageUrl.startsWith('/') ||
        imageUrl.contains('\\') ||
        imageUrl.startsWith('file://');

    final isNetworkUrl =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    final fallbackWidget = Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/logo.png'),
          fit: BoxFit.contain,
        ),
        color: AppColors.surfaceVariant,
      ),
    );

    if (isFilePath) {
      // It's a file from camera
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallbackWidget,
      );
    } else if (isNetworkUrl) {
      // It's a network URL - use cached_network_image
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.surfaceVariant,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        ),
        errorWidget: (context, url, error) => fallbackWidget,
      );
    } else {
      // It's an asset
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
            onError: (error, stackTrace) {},
          ),
        ),
        child: fallbackWidget,
      );
    }
  }
}
