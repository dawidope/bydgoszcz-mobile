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
      // Call OpenAI API with monument name
      final result = await _openAiService.getMonumentDetailsByName(
        monumentName: monumentName,
      );

      // Check confidence level
      final confidence = result['confidence'] as String?;
      if (confidence == 'low' || result['name'] == 'unknown') {
        emit(
          MonumentDescriptionError(
            'Nie znaleziono informacji o tym miejscu. Sprawdź nazwę i spróbuj ponownie.',
          ),
        );
        return;
      }

      // Try to find matching monument from repository first
      final allMonuments = _monumentsRepository.getMonuments();
      Monument? foundMonument;

      for (final monument in allMonuments) {
        if (_nameMatches(monument.name, result['name'] as String?)) {
          foundMonument = monument;
          break;
        }
      }

      // If found in repository, use that (has audio, image, etc.)
      // Otherwise create new Monument from AI data
      final resultMonument =
          foundMonument ??
          Monument.fromRecognition(
            result,
            'assets/images/monument_placeholder.png',
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

  bool _nameMatches(String monumentName, String? recognizedName) {
    if (recognizedName == null) return false;

    final monumentLower = monumentName.toLowerCase();
    final recognizedLower = recognizedName.toLowerCase();

    // Check if recognized name contains key words from monument name
    return monumentLower.contains(recognizedLower) ||
        recognizedLower.contains(monumentLower) ||
        _containsKeyWords(monumentLower, recognizedLower);
  }

  bool _containsKeyWords(String monumentName, String recognizedName) {
    // Extract key words (ignore common words)
    final ignoreWords = {
      'w',
      'na',
      'przy',
      'pod',
      'z',
      'do',
      'i',
      'the',
      'of',
      'in',
    };

    final monumentWords = monumentName
        .split(' ')
        .where((w) => w.length > 3 && !ignoreWords.contains(w))
        .toList();

    final recognizedWords = recognizedName.split(' ').toSet();

    // Check if at least one key word matches
    return monumentWords.any(
      (word) =>
          recognizedWords.any((rw) => rw.contains(word) || word.contains(rw)),
    );
  }

  void reset() {
    emit(MonumentDescriptionInitial());
  }
}
