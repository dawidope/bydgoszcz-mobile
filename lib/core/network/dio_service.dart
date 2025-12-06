import 'package:bydgoszcz/core/constants/openai_constants.dart';
import 'package:dio/dio.dart';

class DioService {
  static Dio createOpenAiDio() {
    final dio = Dio();

    dio.options = BaseOptions(
      baseUrl: OpenAiConstants.baseUrl,
      connectTimeout: OpenAiConstants.connectTimeout,
      receiveTimeout: OpenAiConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${OpenAiConstants.apiKey}',
      },
    );

    return dio;
  }
}
