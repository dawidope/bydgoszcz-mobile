import 'dart:math' as math;

import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/models/generated_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompletedRoutePage extends StatefulWidget {
  final GeneratedRoute route;

  const CompletedRoutePage({super.key, required this.route});

  @override
  State<CompletedRoutePage> createState() => _CompletedRoutePageState();
}

class _CompletedRoutePageState extends State<CompletedRoutePage>
    with TickerProviderStateMixin {
  late AnimationController _certificateController;
  late AnimationController _confettiController;
  late AnimationController _textController;

  late Animation<double> _certificateScale;
  late Animation<double> _certificateRotation;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    // Certificate animation
    _certificateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _certificateScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _certificateController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _certificateRotation = Tween<double>(begin: -0.3, end: 0.0).animate(
      CurvedAnimation(
        parent: _certificateController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    // Confetti animation
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
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
    _certificateController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _confettiController.repeat();
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      _textController.forward();
    });
  }

  @override
  void dispose() {
    _certificateController.dispose();
    _confettiController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _goToAdventures() {
    context.go('/route/adventures');
  }

  void _goHome() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Confetti background
            AnimatedBuilder(
              animation: _confettiController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height,
                  ),
                  painter: _ConfettiPainter(
                    progress: _confettiController.value,
                  ),
                );
              },
            ),

            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Animated certificate
                  _buildAnimatedCertificate(),

                  const SizedBox(height: 24),

                  // Text content
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: _buildTextContent(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Buttons
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: _buildButtons(),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCertificate() {
    return AnimatedBuilder(
      animation: _certificateController,
      builder: (context, child) {
        return Transform.scale(
          scale: _certificateScale.value,
          child: Transform.rotate(
            angle: _certificateRotation.value * math.pi,
            child: child,
          ),
        );
      },
      child: _buildCertificateWidget(),
    );
  }

  Widget _buildCertificateWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent.withValues(alpha: 0.9),
            AppColors.accent,
            AppColors.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          // Decorative top border
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
            ),
            child: Text(
              '✦ CERTYFIKAT ✦',
              style: AppTypography.labelMedium.copyWith(
                color: Colors.white,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Trophy icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Colors.white,
              size: 56,
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            'ODKRYWCA',
            style: AppTypography.headlineLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          Text(
            'BYDGOSZCZY',
            style: AppTypography.headlineMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 20),

          // Seals collected
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(
                  widget.route.stops.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.verified_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            '${widget.route.stops.length} / ${widget.route.stops.length} pieczęci',
            style: AppTypography.titleSmall.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),

          const SizedBox(height: 20),

          // Route name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.route.title,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      children: [
        // Congratulations
        Text(
          '🎊 Gratulacje! 🎊',
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Message card
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
                'Zebrałeś wszystkie magiczne pieczęci!',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Twoja przygoda "${widget.route.title}" została ukończona! '
                'Ten certyfikat potwierdza, że jesteś prawdziwym odkrywcą '
                'Bydgoszczy. Możesz go użyć do podbicia oficjalnego certyfikatu '
                'w punkcie informacji turystycznej! 🏆',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        // Primary button - go to adventures
        GestureDetector(
          onTap: _goToAdventures,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.explore_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  'Moje przygody',
                  style: AppTypography.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Secondary button - go home
        GestureDetector(
          onTap: _goHome,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.textDisabled.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_rounded, color: AppColors.textSecondary),
                const SizedBox(width: 12),
                Text(
                  'Wróć do menu',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Custom painter for confetti effect
class _ConfettiPainter extends CustomPainter {
  final double progress;

  _ConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistent pattern

    for (var i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final startY = -50.0 + random.nextDouble() * 100;
      final speed = 0.5 + random.nextDouble() * 0.5;
      final y = startY + (size.height + 100) * ((progress * speed) % 1.0);

      final colors = [
        AppColors.accent,
        AppColors.primary,
        AppColors.success,
        AppColors.bydgoszczBlue,
        Colors.pink,
        Colors.orange,
      ];

      final color = colors[i % colors.length];
      final paint = Paint()
        ..color = color.withValues(alpha: 0.7)
        ..style = PaintingStyle.fill;

      // Draw different shapes
      final shape = i % 3;
      final rotation = progress * math.pi * 4 + i;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      if (shape == 0) {
        // Rectangle
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: 8, height: 12),
          paint,
        );
      } else if (shape == 1) {
        // Circle
        canvas.drawCircle(Offset.zero, 5, paint);
      } else {
        // Triangle
        final path = Path()
          ..moveTo(0, -6)
          ..lineTo(5, 6)
          ..lineTo(-5, 6)
          ..close();
        canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
