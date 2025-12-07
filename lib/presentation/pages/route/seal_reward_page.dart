import 'dart:math' as math;

import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/models/generated_route.dart';
import 'package:bydgoszcz/models/monument.dart';
import 'package:bydgoszcz/models/route_stop.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SealRewardPage extends StatefulWidget {
  final GeneratedRoute route;
  final RouteStop stop;
  final Monument monument;
  final bool allStopsCompleted;

  const SealRewardPage({
    super.key,
    required this.route,
    required this.stop,
    required this.monument,
    required this.allStopsCompleted,
  });

  @override
  State<SealRewardPage> createState() => _SealRewardPageState();
}

class _SealRewardPageState extends State<SealRewardPage>
    with TickerProviderStateMixin {
  late AnimationController _sealController;
  late AnimationController _sparkleController;
  late AnimationController _textController;

  late Animation<double> _sealScale;
  late Animation<double> _sealRotation;
  late Animation<double> _sparkleOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    // Seal animation
    _sealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _sealScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sealController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _sealRotation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _sealController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // Sparkle animation
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _sparkleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sparkleController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Text animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _sealController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _sparkleController.repeat(reverse: true);
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      _textController.forward();
    });
  }

  @override
  void dispose() {
    _sealController.dispose();
    _sparkleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _continue() {
    if (widget.allStopsCompleted) {
      // Navigate to completed route page
      context.pushReplacement(
        '/route/${widget.route.id}/completed',
        extra: {'route': widget.route},
      );
    } else {
      // Go back to adventure
      context.go('/route/adventure/${widget.route.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Animated seal
              _buildAnimatedSeal(),

              const SizedBox(height: 32),

              // Text content
              SlideTransition(
                position: _textSlide,
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: _buildTextContent(),
                ),
              ),

              const SizedBox(height: 40),

              // Continue button
              SlideTransition(
                position: _textSlide,
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: _buildContinueButton(),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSeal() {
    return SizedBox(
      height: 280,
      width: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sparkles background
          AnimatedBuilder(
            animation: _sparkleController,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(280, 280),
                painter: _SparklePainter(
                  progress: _sparkleController.value,
                  opacity: _sparkleOpacity.value,
                ),
              );
            },
          ),

          // Glow effect
          AnimatedBuilder(
            animation: _sealController,
            builder: (context, child) {
              return Container(
                width: 200 * _sealScale.value,
                height: 200 * _sealScale.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              );
            },
          ),

          // Main seal
          AnimatedBuilder(
            animation: _sealController,
            builder: (context, child) {
              return Transform.scale(
                scale: _sealScale.value,
                child: Transform.rotate(
                  angle: _sealRotation.value * math.pi,
                  child: child,
                ),
              );
            },
            child: _buildSealWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildSealWidget() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent,
            AppColors.accent.withRed(200),
            AppColors.accent.withGreen(100),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative border
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 3,
              ),
            ),
          ),

          // Inner design
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_rounded, color: Colors.white, size: 48),
                const SizedBox(height: 4),
                Text(
                  'PIECZĘĆ',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'ODKRYWCY',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    final completedCount = widget.route.stops.where((s) => s.visited).length;
    final totalCount = widget.route.stops.length;

    return Column(
      children: [
        // Title
        Text(
          '🎉 Magiczna Pieczęć! 🎉',
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Description card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            children: [
              Text(
                'Zdobyłeś pieczęć za odkrycie',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.stop.name,
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Progress
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bydgoszczBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      color: AppColors.accent,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pieczęci: $completedCount / $totalCount',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.bydgoszczBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Encouraging message
              Text(
                widget.allStopsCompleted
                    ? 'Wszystkie pieczęci zebrane! Czas odebrać certyfikat! 🏆'
                    : 'Świetna robota! Kontynuuj przygodę i zbierz wszystkie pieczęci, żeby odblokować certyfikat Odkrywcy Bydgoszczy! 🗺️',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: _continue,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.allStopsCompleted
              ? AppColors.accent
              : AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.allStopsCompleted
                  ? Icons.emoji_events_rounded
                  : Icons.arrow_forward_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              widget.allStopsCompleted
                  ? 'Odbierz certyfikat!'
                  : 'Kontynuuj przygodę',
              style: AppTypography.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for sparkle effect
class _SparklePainter extends CustomPainter {
  final double progress;
  final double opacity;

  _SparklePainter({required this.progress, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.accent.withOpacity(opacity * 0.6)
      ..style = PaintingStyle.fill;

    // Draw sparkles at different positions
    final sparklePositions = [
      const Offset(0.2, 0.1),
      const Offset(0.8, 0.15),
      const Offset(0.15, 0.7),
      const Offset(0.85, 0.75),
      const Offset(0.5, 0.05),
      const Offset(0.5, 0.95),
      const Offset(0.05, 0.4),
      const Offset(0.95, 0.5),
    ];

    for (var i = 0; i < sparklePositions.length; i++) {
      final pos = sparklePositions[i];
      final sparkleCenter = Offset(pos.dx * size.width, pos.dy * size.height);

      final phase = (progress + i * 0.125) % 1.0;
      final sparkleSize = 4 + math.sin(phase * math.pi * 2) * 3;

      // Draw 4-pointed star
      _drawStar(canvas, sparkleCenter, sparkleSize, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();

    // Vertical line
    path.moveTo(center.dx, center.dy - size);
    path.lineTo(center.dx, center.dy + size);

    // Horizontal line
    path.moveTo(center.dx - size, center.dy);
    path.lineTo(center.dx + size, center.dy);

    canvas.drawPath(
      path,
      paint
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    // Small circle at center
    canvas.drawCircle(center, size * 0.3, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(_SparklePainter oldDelegate) =>
      progress != oldDelegate.progress || opacity != oldDelegate.opacity;
}
