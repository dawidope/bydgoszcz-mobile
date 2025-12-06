import 'package:bydgoszcz/data/repository/monuments_repository.dart';
import 'package:bydgoszcz/presentation/widgets/audio_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MonumentDetailPage extends StatelessWidget {
  final String monumentId;

  const MonumentDetailPage({super.key, required this.monumentId});

  Future<void> _openGoogleMaps(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = MonumentsRepository();
    final monument = repository.getMonumentById(monumentId);

    if (monument == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Błąd')),
        body: const Center(child: Text('Nie znaleziono zabytku')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(monument.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Audio player zamiast zwykłego obrazka
            if (monument.audioUrl != null)
              SizedBox(
                height: 250,
                child: AudioPlayerWidget(
                  roundedCorners: false,
                  audioAssetPath: monument.audioUrl!,
                  imageAssetPath: monument.imageUrl,
                ),
              )
            else
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    image: DecorationImage(
                      image: AssetImage(monument.imageUrl),
                      fit: BoxFit.cover,
                      onError: (error, stackTrace) {},
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nazwa
                  Text(
                    monument.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Krótki opis
                  Text(
                    monument.shortDescription,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  // Pełny opis
                  Text(
                    monument.facts,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  // Przycisk nawigacji
                  FilledButton.icon(
                    onPressed: () => _openGoogleMaps(monument.googleMapsUrl),
                    icon: const Icon(Icons.map),
                    label: const Text('Nawiguj do zabytku'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
