import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/gen/assets.gen.dart';
import 'package:bydgoszcz/presentation/widgets/buttons/primary_button.dart';
import 'package:bydgoszcz/presentation/widgets/simple_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo z animacją
              FadeTransition(opacity: _fadeAnimation, child: _buildLogo()),

              const SizedBox(height: 48),

              // Teksty z animacją slide
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildTexts(),
                ),
              ),

              const Spacer(flex: 3),
              SimpleAudioPlayer(text: "witam serdecznie"),

              // Przycisk
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildButton(),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // Dekoracyjne domki w kolorach Bydgoszczy
        SizedBox(
          height: 180,
          child: Assets.images.logo.image(fit: BoxFit.contain),
        ),
      ],
    );
  }

  Widget _buildTexts() {
    return Column(
      children: [
        // Główny tytuł
        Text(
          'Witaj w Bydgoszczy!',
          textAlign: TextAlign.center,
          style: AppTypography.displayMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        // Podtytuł
        Text(
          'Zamień spacer po mieście\nw interaktywną przygodę',
          textAlign: TextAlign.center,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        // Kolorowe kropki jako dekoracja
        _buildColorDots(),
      ],
    );
  }

  Widget _buildColorDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(AppColors.bydgoszczRed),
        const SizedBox(width: 12),
        _buildDot(AppColors.bydgoszczYellow),
        const SizedBox(width: 12),
        _buildDot(AppColors.bydgoszczBlue),
      ],
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Column(
      children: [
        PrimaryButton(
          label: 'Zaczynamy!',
          icon: Icons.arrow_forward_rounded,
          onPressed: () {
            context.push('/onboarding');
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Odkryj historię miasta krok po kroku',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
