import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAiConstants {
  static const String baseUrl = 'https://api.openai.com/v1';

  static const String chatCompletions = '/chat/completions';
  static const String audioSpeech = '/audio/speech';

  static const String gpt4Model = 'gpt-4o';
  static const String ttsModel = 'gpt-4o-mini-tts';
  static const String ttsVoice = 'cedar';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 60);

  static final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
}
