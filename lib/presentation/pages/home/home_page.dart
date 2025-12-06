import 'dart:math';

import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/presentation/bloc/app_cubit.dart';
import 'package:bydgoszcz/presentation/widgets/audio_player_widget.dart';
import 'package:bydgoszcz/presentation/widgets/cards/action_card.dart';
import 'package:bydgoszcz/presentation/widgets/decorations/wave_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<String> _greetings = [
    'Gotowy na przygodę?',
    'Czas odkryć tajemnice!',
    'Co odwiedzisz dzisiaj?',
    'Przygoda czeka!',
    'Poznaj Bydgoszcz!',
  ];

  @override
  Widget build(BuildContext context) {
    final userName = context.read<AppCubit>().state.userProfile?.name ?? '';

    return Scaffold(
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final profile = state.userProfile;

          if (profile == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return WaveBackground(
            waveHeight: 110,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header z powitaniem
                    _buildHeader(context, userName),

                    const SizedBox(height: 24),

                    // Audio Player
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildAudioSection(context),
                    ),

                    const SizedBox(height: 32),

                    // Akcje
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildActionsSection(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Text(
            'Cześć, $userName! 👋',
            style: AppTypography.greeting.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            _greetings[Random().nextInt(_greetings.length)],
            style: AppTypography.subtitle.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
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
            Text('Poznaj Bydgoszcz', style: AppTypography.headlineMedium),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'Odkryj historie, które czekają tuż za rogiem.',
            style: AppTypography.subtitle,
          ),
        ),
        const SizedBox(height: 16),
        // Audio Player z zaokrąglonymi rogami
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AudioPlayerWidget(
            audioAssetPath: 'assets/audio/dashboard.mp3',
            imageAssetPath: 'assets/images/dashboard.png',
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text('Co chcesz robić?', style: AppTypography.headlineMedium),
          ],
        ),
        const SizedBox(height: 16),

        // Action Cards
        ActionCard.primary(
          title: 'Zaplanuj przygodę',
          subtitle: 'Stwórz własną ścieżkę po zabytkach',
          icon: Icons.route_rounded,
          onTap: () {
            context.push('/route/planning');
          },
        ),
        const SizedBox(height: 12),
        ActionCard.secondary(
          title: 'Poznaj zabytek',
          subtitle: 'Odkryj historię pojedynczego miejsca',
          icon: Icons.account_balance_rounded,
          onTap: () {
            context.push('/monuments');
          },
        ),
        const SizedBox(height: 12),
        ActionCard.light(
          title: 'Moje przygody',
          subtitle: 'Zobacz swoje osiągnięcia i medale',
          icon: Icons.emoji_events_rounded,
          accentColor: AppColors.accent,
          onTap: () {
            // TODO: Navigate to adventures
          },
        ),
      ],
    );
  }
}
