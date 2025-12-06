import 'dart:convert';
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

    return {
      'title': 'Magiczna wyprawa $userName po Bydgoszczy',
      'narration': response,
      'stops': monuments,
    };
  }

  Future<Map<String, dynamic>> recognizeMonument({
    required String base64Image,
  }) async {
    try {
      final systemPrompt =
          '''You are an expert on Bydgoszcz monuments and landmarks in Poland.
Analyze the provided image and identify the monument or landmark.
This photo was taken in Bydgoszcz, Poland.
Provide detailed information about the monument in Polish language.''';

      final userPrompt = 'Identify this monument and provide all details.';

      final function = {
        'name': 'identify_monument',
        'description':
            'Identifies a monument from Bydgoszcz and provides structured information',
        'parameters': {
          'type': 'object',
          'properties': {
            'name': {
              'type': 'string',
              'description': 'The exact name of the monument in Polish',
            },
            'shortDescription': {
              'type': 'string',
              'description':
                  'A brief 1-2 sentence description of the monument in Polish',
            },
            'facts': {
              'type': 'string',
              'description':
                  'Interesting historical facts about this monument in Polish (3-5 sentences)',
            },
            'imageUrl': {
              'type': 'string',
              'description':
                  'Default placeholder image path: assets/images/monument_placeholder.png',
            },
            'googleMapsUrl': {
              'type': 'string',
              'description':
                  'Google Maps search url in format: https://www.google.com/maps/search/NUMBER+STREET+CITY+STATE',
            },
            'confidence': {
              'type': 'string',
              'enum': ['high', 'medium', 'low'],
              'description': 'Confidence level of identification',
            },
          },
          'required': [
            'name',
            'shortDescription',
            'facts',
            'imageUrl',
            'googleMapsUrl',
            'confidence',
          ],
        },
      };

      final requestBody = {
        'model': 'gpt-4.1',
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': userPrompt},
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:image/jpeg;base64,$base64Image',
                  'detail': 'high',
                },
              },
            ],
          },
        ],
        'functions': [function],
        'function_call': {'name': 'identify_monument'},
      };

      final response = await _dio.post(
        OpenAiConstants.chatCompletions,
        data: requestBody,
      );

      final message = response.data['choices'][0]['message'];

      if (message['function_call'] != null) {
        final functionArgs = message['function_call']['arguments'];
        final j = json.decode(functionArgs);
        return j;
      }

      throw Exception('No function call in response');
    } on DioException catch (e) {
      throw Exception('OpenAI Vision API error: ${e.message}');
    } catch (e) {
      throw Exception('Error recognizing monument: $e');
    }
  }

  Future<Map<String, dynamic>> getMonumentDetailsByName({
    required String monumentName,
  }) async {
    try {
      final systemPrompt =
          '''You are an expert on Bydgoszcz monuments and landmarks in Poland.
The user will provide a name or location of a monument/landmark in Bydgoszcz.
Provide detailed information about this monument in Polish language.
If the name is not exact, try to match it to a known monument in Bydgoszcz.''';

      final userPrompt =
          'Podaj szczegółowe informacje o tym miejscu w Bydgoszczy: $monumentName';

      final function = {
        'name': 'get_monument_details',
        'description':
            'Provides detailed structured information about a monument in Bydgoszcz',
        'parameters': {
          'type': 'object',
          'properties': {
            'name': {
              'type': 'string',
              'description': 'The exact name of the monument in Polish',
            },
            'shortDescription': {
              'type': 'string',
              'description':
                  'A brief 1-2 sentence description of the monument in Polish',
            },
            'facts': {
              'type': 'string',
              'description':
                  'Interesting historical facts about this monument in Polish (3-5 sentences)',
            },
            'imageUrl': {
              'type': 'string',
              'description':
                  'Find any image of this place in the internet and provide its URL. Try to find official or high-quality images.',
            },
            'googleMapsUrl': {
              'type': 'string',
              'description':
                  'Google Maps search url in format: https://www.google.com/maps/search/NUMBER+STREET+CITY+STATE',
            },
            'confidence': {
              'type': 'string',
              'enum': ['high', 'medium', 'low'],
              'description': 'Confidence level of identification',
            },
          },
          'required': [
            'name',
            'shortDescription',
            'facts',
            'imageUrl',
            'googleMapsUrl',
            'confidence',
          ],
        },
      };

      final requestBody = {
        'model': 'gpt-4.1',
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userPrompt},
        ],
        'functions': [function],
        'function_call': {'name': 'get_monument_details'},
        'temperature': 0.3,
        'max_tokens': 800,
      };

      final response = await _dio.post(
        OpenAiConstants.chatCompletions,
        data: requestBody,
      );

      final message = response.data['choices'][0]['message'];

      if (message['function_call'] != null) {
        final functionArgs = message['function_call']['arguments'];
        final j = json.decode(functionArgs);
        return j;
      }

      throw Exception('No function call in response');
    } on DioException catch (e) {
      throw Exception('OpenAI API error: ${e.message}');
    } catch (e) {
      throw Exception('Error getting monument details: $e');
    }
  }
}
