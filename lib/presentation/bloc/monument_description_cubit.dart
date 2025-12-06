import 'package:bydgoszcz/core/network/openai_service.dart';
import 'package:bydgoszcz/data/repository/monuments_repository.dart';
import 'package:bydgoszcz/models/monument.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// States
abstract class MonumentDescriptionState {}

class MonumentDescriptionInitial extends MonumentDescriptionState {}

class MonumentDescriptionLoading extends MonumentDescriptionState {}

class MonumentDescriptionSuccess extends MonumentDescriptionState {
  final Monument monument;
  MonumentDescriptionSuccess(this.monument);
}

class MonumentDescriptionError extends MonumentDescriptionState {
  final String message;
  MonumentDescriptionError(this.message);
}

// Cubit
class MonumentDescriptionCubit extends Cubit<MonumentDescriptionState> {
  final OpenAiService _openAiService;
  final MonumentsRepository _monumentsRepository;

  MonumentDescriptionCubit({
    required OpenAiService openAiService,
    required MonumentsRepository monumentsRepository,
  }) : _openAiService = openAiService,
       _monumentsRepository = monumentsRepository,
       super(MonumentDescriptionInitial());

  Future<void> getMonumentDetails(String monumentName) async {
    if (monumentName.trim().isEmpty) {
      emit(MonumentDescriptionError('Proszę wpisać nazwę miejsca'));
      return;
    }

    emit(MonumentDescriptionLoading());

    try {
      final result = await _openAiService.getMonumentDetailsByName(
        monumentName: monumentName,
      );

      final confidence = result['confidence'] as String?;
      if (confidence == 'low' || result['name'] == 'unknown') {
        emit(
          MonumentDescriptionError(
            'Nie znaleziono informacji o tym miejscu. Sprawdź nazwę i spróbuj ponownie.',
          ),
        );
        return;
      }

      final resultMonument = Monument.fromRecognition(
        result,
        'assets/images/logo.png',
      );

      emit(MonumentDescriptionSuccess(resultMonument));
    } catch (e) {
      emit(
        MonumentDescriptionError(
          'Wystąpił błąd podczas pobierania informacji: ${e.toString()}',
        ),
      );
    }
  }

  void reset() {
    emit(MonumentDescriptionInitial());
  }
}
