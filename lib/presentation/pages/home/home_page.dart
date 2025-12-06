import 'package:bydgoszcz/presentation/bloc/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bydgoszcz')),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final profile = state.userProfile;

          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cześć, ${profile.name}!',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gotowy na przygodę w Bydgoszczy?',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Co chcesz dziś robić?',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _ActionCard(
                        icon: Icons.map,
                        title: 'Wyznacz trasę',
                        subtitle: 'Stwórz swoją przygodę',
                        onTap: () {
                          // TODO: Navigate to route creation
                        },
                      ),
                      _ActionCard(
                        icon: Icons.location_city,
                        title: 'Poznaj zabytek',
                        subtitle: 'Odkryj historię miejsca',
                        onTap: () {
                          // TODO: Navigate to monuments list
                        },
                      ),
                      _ActionCard(
                        icon: Icons.emoji_events,
                        title: 'Moje przygody',
                        subtitle: 'Zobacz zdobyte medale',
                        onTap: () {
                          // TODO: Navigate to adventures history
                        },
                      ),
                      _ActionCard(
                        icon: Icons.info_outline,
                        title: 'O Bydgoszczy',
                        subtitle: 'Poznaj miasto',
                        onTap: () {
                          // TODO: Show intro about Bydgoszcz
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
