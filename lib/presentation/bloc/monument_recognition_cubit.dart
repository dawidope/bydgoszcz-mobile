import 'dart:convert';
import 'dart:typed_data';

import 'package:bydgoszcz/core/network/openai_service.dart';
import 'package:bydgoszcz/models/monument.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

// States
abstract class MonumentRecognitionState {}

class MonumentRecognitionInitial extends MonumentRecognitionState {}

class MonumentRecognitionLoading extends MonumentRecognitionState {}

class MonumentRecognitionSuccess extends MonumentRecognitionState {
  final Monument monument;
  final Uint8List imageBytes;
  MonumentRecognitionSuccess(this.monument, this.imageBytes);
}

class MonumentRecognitionError extends MonumentRecognitionState {
  final String message;
  MonumentRecognitionError(this.message);
}

// Cubit
class MonumentRecognitionCubit extends Cubit<MonumentRecognitionState> {
  final OpenAiService _openAiService;

  MonumentRecognitionCubit({required OpenAiService openAiService})
    : _openAiService = openAiService,
      super(MonumentRecognitionInitial());

  Future<void> recognizeMonument(XFile imageFile) async {
    emit(MonumentRecognitionLoading());

    try {
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final recognitionResult = await _openAiService.recognizeMonument(
        base64Image: base64Image,
      );

      final confidence = recognitionResult['confidence'] as String?;
      if (confidence == 'low' || recognitionResult['name'] == 'unknown') {
        emit(
          MonumentRecognitionError(
            'Nie udało się rozpoznać zabytku. Spróbuj zrobić zdjęcie z innej perspektywy.',
          ),
        );
        return;
      }

      final resultMonument = Monument.fromRecognition(
        recognitionResult,
        'memory', // Placeholder since we use bytes now
      );

      emit(MonumentRecognitionSuccess(resultMonument, imageBytes));
    } catch (e) {
      emit(
        MonumentRecognitionError(
          'Wystąpił błąd podczas rozpoznawania: ${e.toString()}',
        ),
      );
    }
  }

  void reset() {
    emit(MonumentRecognitionInitial());
  }
}
