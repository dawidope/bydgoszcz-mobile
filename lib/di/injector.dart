import 'package:bydgoszcz/core/network/dio_service.dart';
import 'package:bydgoszcz/core/network/openai_service.dart';
import 'package:bydgoszcz/data/local/app_storage.dart';
import 'package:bydgoszcz/data/repository/monuments_repository.dart';
import 'package:bydgoszcz/data/repository/story_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

class Injector {
  Future<void> setup() async {
    // Storage
    final prefs = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(prefs);

    getIt.registerLazySingleton<AppStorage>(
      () => AppStorage(getIt.get<SharedPreferences>()),
    );

    // Network - OpenAI Dio client
    getIt.registerLazySingleton<Dio>(
      () => DioService.createOpenAiDio(),
      instanceName: 'openai',
    );

    // OpenAI Service
    getIt.registerLazySingleton<OpenAiService>(
      () => OpenAiService(getIt.get<Dio>(instanceName: 'openai')),
    );

    // Repositories
    getIt.registerLazySingleton<MonumentsRepository>(
      () => MonumentsRepository(),
    );

    getIt.registerLazySingleton<StoryRepository>(
      () => StoryRepository(getIt.get<OpenAiService>()),
    );
  }
}
