import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MonumentsPage extends StatelessWidget {
  const MonumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jak chcesz poznać zabytek?')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton(
              onPressed: () {
                context.push('/monuments/list');
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Wybierz z listy',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // TODO: Navigate to camera/photo
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Zrób zdjęcie', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // TODO: Navigate to manual description
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Dodaj opis', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
