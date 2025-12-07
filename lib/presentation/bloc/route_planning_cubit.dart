import 'package:bydgoszcz/core/network/openai_service.dart';
import 'package:bydgoszcz/data/local/route_storage.dart';
import 'package:bydgoszcz/data/repository/monuments_repository.dart';
import 'package:bydgoszcz/models/generated_route.dart';
import 'package:bydgoszcz/models/quiz_question.dart';
import 'package:bydgoszcz/models/route_stop.dart';
import 'package:bydgoszcz/models/user_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// States
abstract class RoutePlanningState {}

class RoutePlanningInitial extends RoutePlanningState {}

class RoutePlanningGenerating extends RoutePlanningState {
  final String statusMessage;
  RoutePlanningGenerating(this.statusMessage);
}

class RoutePlanningSuccess extends RoutePlanningState {
  final GeneratedRoute route;
  RoutePlanningSuccess(this.route);
}

class RoutePlanningError extends RoutePlanningState {
  final String message;
  RoutePlanningError(this.message);
}

// Cubit
class RoutePlanningCubit extends Cubit<RoutePlanningState> {
  final OpenAiService _openAiService;
  final MonumentsRepository _monumentsRepository;
  final RouteStorage _routeStorage;

  RoutePlanningCubit({
    required OpenAiService openAiService,
    required MonumentsRepository monumentsRepository,
    RouteStorage? routeStorage,
  }) : _openAiService = openAiService,
       _monumentsRepository = monumentsRepository,
       _routeStorage = routeStorage ?? RouteStorage(),
       super(RoutePlanningInitial());

  Future<void> generateRoute({
    required List<String> selectedMonumentIds,
    required UserProfile userProfile,
  }) async {
    emit(RoutePlanningGenerating('Przygotowuję magiczną przygodę...'));

    try {
      // Get monument details
      final monuments = _monumentsRepository.getAllMonuments();
      final selectedMonuments = monuments
          .where((m) => selectedMonumentIds.contains(m.id))
          .toList();

      if (selectedMonuments.isEmpty) {
        emit(RoutePlanningError('Nie wybrano żadnych zabytków'));
        return;
      }

      emit(RoutePlanningGenerating('Tworzę bajkę dla ${userProfile.name}...'));

      // Prepare monuments data for API
      final monumentsData = selectedMonuments
          .map((m) => {'id': m.id, 'name': m.name, 'facts': m.facts})
          .toList();

      emit(RoutePlanningGenerating('Piszę historię i quizy...'));

      // Call OpenAI API
      final result = await _openAiService.generateAdventureRoute(
        monuments: monumentsData,
        userName: userProfile.name,
        userAge: userProfile.age,
        userInterests: userProfile.interests,
      );

      // Generate cover image from txt2imgPrompt
      String? coverImageBase64;
      final txt2imgPrompt = result['txt2imgPrompt'] as String?;
      if (txt2imgPrompt != null && txt2imgPrompt.isNotEmpty) {
        emit(RoutePlanningGenerating('Generuję ilustrację do bajki...'));
        try {
          coverImageBase64 = await _openAiService.generateImage(
            prompt: txt2imgPrompt,
          );
        } catch (e) {
          // Image generation failed, but we can continue without it
          coverImageBase64 = null;
        }
      }

      emit(RoutePlanningGenerating('Finalizuję trasę...'));

      // Parse response and create GeneratedRoute
      final route = _parseRouteFromResponse(
        result,
        selectedMonuments,
        coverImageBase64: coverImageBase64,
      );

      // Save route to storage
      _routeStorage.saveRoute(route);
      _routeStorage.setCurrentRoute(route);

      emit(RoutePlanningSuccess(route));
    } catch (e) {
      emit(RoutePlanningError('Wystąpił błąd: ${e.toString()}'));
    }
  }

  GeneratedRoute _parseRouteFromResponse(
    Map<String, dynamic> response,
    List<dynamic> selectedMonuments, {
    String? coverImageBase64,
  }) {
    final stopsData = response['stops'] as List<dynamic>;
    final stops = <RouteStop>[];

    for (final stopData in stopsData) {
      final quizData = stopData['quiz'] as Map<String, dynamic>;
      final quiz = QuizQuestion(
        question: quizData['question'] as String,
        answers: List<String>.from(quizData['answers'] as List),
        correctAnswerIndex: quizData['correctAnswerIndex'] as int,
      );

      // Find matching monument for imageUrl
      final monumentId = stopData['monumentId'] as String;

      stops.add(
        RouteStop(
          id: monumentId,
          name: stopData['name'] as String,
          order: stopData['order'] as int,
          shortStory: stopData['story'] as String,
          funFact: stopData['funFact'] as String,
          quiz: quiz,
        ),
      );
    }

    // Sort stops by order
    stops.sort((a, b) => a.order.compareTo(b.order));

    return GeneratedRoute(
      id: 'route_${DateTime.now().millisecondsSinceEpoch}',
      title: response['title'] as String,
      narration: response['introduction'] as String,
      stops: stops,
      createdAt: DateTime.now(),
      coverImageBase64: coverImageBase64,
    );
  }

  void reset() {
    emit(RoutePlanningInitial());
  }
}
