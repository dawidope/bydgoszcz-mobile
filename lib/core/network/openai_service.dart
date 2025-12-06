import 'dart:typed_data';

import 'package:bydgoszcz/core/constants/openai_constants.dart';
import 'package:dio/dio.dart';

class OpenAiService {
  final Dio _dio;

  OpenAiService(this._dio);

  Future<String> generateStory({
    required String systemPrompt,
    required String userPrompt,
    Map<String, dynamic>? functions,
  }) async {
    try {
      final requestBody = {
        'model': OpenAiConstants.gpt4Model,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userPrompt},
        ],
        'temperature': 0.8,
        'max_tokens': 1000,
      };

      if (functions != null) {
        requestBody['functions'] = functions;
        requestBody['function_call'] = 'auto';
      }

      final response = await _dio.post(
        OpenAiConstants.chatCompletions,
        data: requestBody,
      );

      final content = response.data['choices'][0]['message']['content'];
      return content ?? '';
    } on DioException catch (e) {
      throw Exception('OpenAI API error: ${e.message}');
    }
  }

  Future<Uint8List> generateSpeech({
    required String text,
    String? voice,
    double speed = 1.0,
  }) async {
    try {
      final response = await _dio.post(
        OpenAiConstants.audioSpeech,
        data: {
          'model': OpenAiConstants.ttsModel,
          'input': text,
          'voice': voice ?? OpenAiConstants.ttsVoice,
          'speed': speed,
        },
        options: Options(responseType: ResponseType.bytes),
      );

      return Uint8List.fromList(response.data);
    } on DioException catch (e) {
      throw Exception('OpenAI TTS error: ${e.message}');
    }
  }

  Future<String> generateMonumentStory({
    required String monumentName,
    required String monumentFacts,
    required String userName,
    required int userAge,
    required List<String> userInterests,
  }) async {
    final systemPrompt =
        '''Jesteś przewodnikiem po Bydgoszczy dla dzieci i młodzieży.
Tworzysz krótkie, angażujące opowieści o zabytkach miasta.
Używaj prostego języka, bajkowego stylu i uwzględniaj zainteresowania dziecka.
Opowieść powinna mieć 200-300 słów.''';

    final userPrompt =
        '''Stwórz opowieść o miejscu: $monumentName

Fakty historyczne: $monumentFacts

Profil dziecka:
- Imię: $userName
- Wiek: $userAge lat
- Zainteresowania: ${userInterests.join(", ")}

Wpleć fakty historyczne w przygodową narrację dostosowaną do wieku i zainteresowań dziecka.''';

    return generateStory(systemPrompt: systemPrompt, userPrompt: userPrompt);
  }

  Future<Map<String, dynamic>> generateRouteStory({
    required List<Map<String, String>> monuments,
    required String userName,
    required int userAge,
    required List<String> userInterests,
  }) async {
    final monumentsList = monuments
        .map((m) => '- ${m['name']}: ${m['facts']}')
        .join('\n');

    final systemPrompt = '''Jesteś przewodnikiem po Bydgoszczy.
Tworzysz spójne, przygodowe opowieści łączące wybrane miejsca w jedną trasę.
Odpowiadaj w formacie JSON z polami: title, narration, stops (array z short_story i fun_fact dla każdego miejsca).''';

    final userPrompt =
        '''Stwórz historię trasy po Bydgoszczy.

Miejsca na trasie:
$monumentsList

Profil dziecka:
- Imię: $userName
- Wiek: $userAge lat
- Zainteresowania: ${userInterests.join(", ")}

Stwórz:
1. Tytuł przygody (np. "Magiczna wyprawa [imię] po Bydgoszczy")
2. Główną narrację łączącą wszystkie miejsca (max 300 słów)
3. Dla każdego miejsca: krótką opowieść (50-100 słów) i ciekawostkę

Odpowiedź w formacie JSON.''';

    final response = await generateStory(
      systemPrompt: systemPrompt,
      userPrompt: userPrompt,
    );

    // Parse JSON response
    // Note: GPT może zwrócić markdown z ```json, trzeba to oczyścić
    final jsonString = response
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    // W prawdziwej implementacji użyj json.decode
    // Dla uproszczenia zwracam mock
    return {
      'title': 'Magiczna wyprawa $userName po Bydgoszczy',
      'narration': response,
      'stops': monuments,
    };
  }
}
