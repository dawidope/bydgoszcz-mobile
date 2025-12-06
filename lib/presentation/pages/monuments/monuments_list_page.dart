import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/data/repository/monuments_repository.dart';
import 'package:bydgoszcz/models/monument.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MonumentsListPage extends StatelessWidget {
  const MonumentsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MonumentsRepository();
    final monuments = repository.getAllMonuments();

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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppColors.textPrimary,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Zabytki Bydgoszczy',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: monuments.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final monument = monuments[index];
          return _MonumentCard(
            monument: monument,
            colorIndex: index,
            onTap: () {
              context.push('/monuments/detail/${monument.id}');
            },
          );
        },
      ),
    );
  }
}

class _MonumentCard extends StatefulWidget {
  final Monument monument;
  final int colorIndex;
  final VoidCallback onTap;

  const _MonumentCard({
    required this.monument,
    required this.colorIndex,
    required this.onTap,
  });

  @override
  State<_MonumentCard> createState() => _MonumentCardState();
}

class _MonumentCardState extends State<_MonumentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  static const List<Color> _accentColors = [
    AppColors.bydgoszczRed,
    AppColors.bydgoszczYellow,
    AppColors.bydgoszczBlue,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColors[widget.colorIndex % _accentColors.length];

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: _isPressed ? AppShadows.soft : AppShadows.card,
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              // Obrazek z kolorowym akcentem
              Stack(
                children: [
                  _buildMonumentImage(widget.monument.imageUrl, accentColor),
                  // Kolorowy pasek akcentowy
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 4, color: accentColor),
                  ),
                ],
              ),
              // Tekst
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.monument.name,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.monument.shortDescription,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: accentColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Poznaj historię',
                            style: AppTypography.labelSmall.copyWith(
                              color: accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonumentImage(String imageUrl, Color accentColor) {
    final isNetworkUrl =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    if (isNetworkUrl) {
      return Container(
        width: 120,
        height: 130,
        color: accentColor.withOpacity(0.1),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
              color: accentColor,
              strokeWidth: 2,
            ),
          ),
          errorWidget: (context, url, error) => Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    } else {
      // Asset image
      return Container(
        width: 120,
        height: 130,
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.1),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
            onError: (error, stackTrace) {},
          ),
        ),
      );
    }
  }
}
