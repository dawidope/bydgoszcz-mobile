import 'dart:math';

import 'package:bydgoszcz/presentation/bloc/app_cubit.dart';
import 'package:bydgoszcz/presentation/widgets/audio_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<String> _greetings = [
    'Gotowy, by zamienić spacer po Bydgoszczy w prawdziwą przygodę?',
    'Czas odkryć tajemnice ulic Bydgoszczy!',
    'Które miejsce w Bydgoszczy odwiedzisz dzisiaj?',
    'Przygoda czeka za każdym rogiem miasta!',
    'Poznaj Bydgoszcz jak nigdy wcześniej!',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Witaj ${context.read<AppCubit>().state.userProfile?.name}',
        ),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final profile = state.userProfile;

          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _greetings[Random().nextInt(_greetings.length)],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  // Sekcja "Poznaj Bydgoszcz"
                  Text(
                    'Poznaj Bydgoszcz',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Odkryj historie, które czekają tuż za rogiem.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  // Audio Player
                  AudioPlayerWidget(
                    audioAssetPath: 'assets/audio/dashboard.mp3',
                    imageAssetPath: 'assets/images/dashboard.png',
                  ),
                  const Spacer(),
                  // Przyciski na dole
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Navigate to route creation
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Wyznacz trasę'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Navigate to monuments
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Poznaj zabytek'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      // TODO: Navigate to adventures
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Moje przygody'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
