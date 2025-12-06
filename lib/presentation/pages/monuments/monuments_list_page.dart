import 'package:bydgoszcz/data/repository/monuments_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MonumentsListPage extends StatelessWidget {
  const MonumentsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MonumentsRepository();
    final monuments = repository.getAllMonuments();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wybierz zabytek'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: monuments.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final monument = monuments[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                context.push('/monuments/detail/${monument.id}');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Obrazek po lewej
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: DecorationImage(
                        image: AssetImage(monument.imageUrl),
                        fit: BoxFit.cover,
                        onError: (error, stackTrace) {},
                      ),
                    ),
                  ),
                  // Tekst po prawej
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            monument.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            monument.shortDescription,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
