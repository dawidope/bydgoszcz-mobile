import 'package:bydgoszcz/core/network/openai_service.dart';
import 'package:bydgoszcz/models/generated_route.dart';
import 'package:bydgoszcz/models/monument.dart';
import 'package:bydgoszcz/models/quiz_question.dart';
import 'package:bydgoszcz/models/route_stop.dart';
import 'package:bydgoszcz/models/user_profile.dart';

class StoryRepository {
  final OpenAiService _openAiService;

  StoryRepository(this._openAiService);

  Future<String> generateIntro(UserProfile profile) async {
    try {
      final systemPrompt =
          '''Jesteś przewodnikiem po Bydgoszczy dla dzieci i młodzieży.
Stwórz krótkie, ciepłe powitanie dla dziecka odwiedzającego miasto (max 100 słów).
Użyj prostego języka i wzbudź ciekawość.''';

      final userPrompt =
          '''Przywitaj ${profile.name}, ${profile.age} lat, które lubi: ${profile.interests.join(", ")}.
Opowiedz 2-3 ciekawe fakty o Bydgoszczy dostosowane do zainteresowań dziecka.''';

      return await _openAiService.generateStory(
        systemPrompt: systemPrompt,
        userPrompt: userPrompt,
      );
    } catch (e) {
      // Fallback do mock data jeśli API nie działa
      return 'Cześć ${profile.name}! Witaj w magicznej Bydgoszczy – mieście, gdzie historia spotyka się z przygodą! '
          'Czy wiesz, że Bydgoszcz została założona ponad 600 lat temu? To miasto pełne tajemniczych zakątków, '
          'pięknych parków i fascynujących zabytków. Przygotuj się na niezwykłą wyprawę!';
    }
  }

  Future<String> generateMonumentStory(
    UserProfile profile,
    Monument monument,
  ) async {
    try {
      return await _openAiService.generateMonumentStory(
        monumentName: monument.name,
        monumentFacts: monument.facts,
        userName: profile.name,
        userAge: profile.age,
        userInterests: profile.interests,
      );
    } catch (e) {
      return 'Historia ${monument.name}\n\n'
          '${monument.facts}\n\n'
          'Wyobraź sobie ${profile.name}, że przenosisz się w czasie do miejsc, '
          'gdzie to wszystko się zaczęło...';
    }
  }

  Future<GeneratedRoute> generateRoute(
    UserProfile profile,
    List<Monument> monuments,
  ) async {
    try {
      final monumentsData = monuments
          .map((m) => {'name': m.name, 'facts': m.facts})
          .toList();

      final result = await _openAiService.generateRouteStory(
        monuments: monumentsData,
        userName: profile.name,
        userAge: profile.age,
        userInterests: profile.interests,
      );

      final stops = monuments.asMap().entries.map((entry) {
        final index = entry.key;
        final monument = entry.value;

        return RouteStop(
          id: monument.id,
          name: monument.name,
          order: index + 1,
          shortStory: monument.facts,
          funFact: 'Ciekawostka o ${monument.name}!',
          quiz: QuizQuestion(
            question: 'Co wiesz o ${monument.name}?',
            answers: [
              'Odpowiedź A',
              'Odpowiedź B',
              'Odpowiedź C',
              'Odpowiedź D',
            ],
            correctAnswerIndex: 0,
          ),
        );
      }).toList();

      return GeneratedRoute(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: result['title'] as String,
        narration: result['narration'] as String,
        stops: stops,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      final stops = monuments.asMap().entries.map((entry) {
        final index = entry.key;
        final monument = entry.value;

        return RouteStop(
          id: monument.id,
          name: monument.name,
          order: index + 1,
          shortStory: monument.facts,
          funFact: 'Ciekawostka o ${monument.name}!',
          quiz: QuizQuestion(
            question: 'Co wiesz o ${monument.name}?',
            answers: [
              'Odpowiedź A',
              'Odpowiedź B',
              'Odpowiedź C',
              'Odpowiedź D',
            ],
            correctAnswerIndex: 0,
          ),
        );
      }).toList();

      return GeneratedRoute(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Magiczna wyprawa ${profile.name} po Bydgoszczy',
        narration:
            'To jest Twoja osobista przygoda przez najpiękniejsze zakątki miasta. '
            'Każde miejsce kryje swoją tajemnicę, czekającą na odkrycie!',
        stops: stops,
        createdAt: DateTime.now(),
      );
    }
  }

  Future<List<int>> generateAudio(String text, {String? voice}) async {
    return await _openAiService.generateSpeech(text: text, voice: voice);
  }
}
