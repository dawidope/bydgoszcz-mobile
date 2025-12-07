import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Widget tworzący tło z falami w górnej części ekranu
/// Używany głównie jako tło nagłówkowe na ekranach
class WaveBackground extends StatelessWidget {
  final Widget child;
  final double waveHeight;
  final Color? topColor;
  final Color? bottomColor;
  final bool showSecondWave;

  const WaveBackground({
    super.key,
    required this.child,
    this.waveHeight = 200,
    this.topColor,
    this.bottomColor,
    this.showSecondWave = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Główne tło
        Container(color: AppColors.background),
        // Fala
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            size: Size(
              MediaQuery.of(context).size.width,
              waveHeight + MediaQuery.of(context).padding.top,
            ),
            painter: _WavePainter(
              topColor: topColor ?? AppColors.primary,
              bottomColor: bottomColor ?? AppColors.primaryLight,
              showSecondWave: showSecondWave,
            ),
          ),
        ),
        // Zawartość
        child,
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color topColor;
  final Color bottomColor;
  final bool showSecondWave;

  _WavePainter({
    required this.topColor,
    required this.bottomColor,
    required this.showSecondWave,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [topColor, bottomColor],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.75);

    // Pierwsza fala (główna)
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.95,
      size.width * 0.5,
      size.height * 0.75,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.55,
      size.width,
      size.height * 0.75,
    );

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);

    // Druga fala (dekoracyjna) z mniejszą przejrzystością
    if (showSecondWave) {
      final paint2 = Paint()..color = Colors.white.withOpacity(0.1);

      final path2 = Path();
      path2.moveTo(0, size.height * 0.6);
      path2.quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.8,
        size.width * 0.6,
        size.height * 0.6,
      );
      path2.quadraticBezierTo(
        size.width * 0.85,
        size.height * 0.4,
        size.width,
        size.height * 0.55,
      );
      path2.lineTo(size.width, 0);
      path2.lineTo(0, 0);
      path2.close();

      canvas.drawPath(path2, paint2);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Nagłówek strony z tłem gradientowym i falą
class GradientHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final double height;
  final Color? startColor;
  final Color? endColor;

  const GradientHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.height = 180,
    this.startColor,
    this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            startColor ?? AppColors.primary,
            endColor ?? AppColors.primaryLight,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Dekoracyjne kółka
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 60,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          // Zawartość
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                subtitle!,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (trailing != null) trailing!,
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Fala na dole
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 30),
              painter: _BottomWavePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.background;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.6);

    path.quadraticBezierTo(
      size.width * 0.25,
      0,
      size.width * 0.5,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width,
      size.height * 0.3,
    );

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
