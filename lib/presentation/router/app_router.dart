import 'dart:typed_data';

import 'package:bydgoszcz/core/network/openai_service.dart';
import 'package:bydgoszcz/data/local/app_storage.dart';
import 'package:bydgoszcz/data/repository/monuments_repository.dart';
import 'package:bydgoszcz/di/injector.dart';
import 'package:bydgoszcz/models/generated_route.dart';
import 'package:bydgoszcz/models/monument.dart';
import 'package:bydgoszcz/models/route_stop.dart';
import 'package:bydgoszcz/presentation/bloc/app_cubit.dart';
import 'package:bydgoszcz/presentation/bloc/monument_description_cubit.dart';
import 'package:bydgoszcz/presentation/bloc/monument_recognition_cubit.dart';
import 'package:bydgoszcz/presentation/bloc/route_planning_cubit.dart';
import 'package:bydgoszcz/presentation/pages/home/home_page.dart';
import 'package:bydgoszcz/presentation/pages/monuments/camera_page.dart';
import 'package:bydgoszcz/presentation/pages/monuments/description_page.dart';
import 'package:bydgoszcz/presentation/pages/monuments/monument_detail_page.dart';
import 'package:bydgoszcz/presentation/pages/monuments/monuments_list_page.dart';
import 'package:bydgoszcz/presentation/pages/monuments/monuments_page.dart';
import 'package:bydgoszcz/presentation/pages/onboarding/onboarding_page.dart';
import 'package:bydgoszcz/presentation/pages/route/confirm_presence_page.dart';
import 'package:bydgoszcz/presentation/pages/route/my_adventures_page.dart';
import 'package:bydgoszcz/presentation/pages/route/route_adventure_page.dart';
import 'package:bydgoszcz/presentation/pages/route/route_planning_page.dart';
import 'package:bydgoszcz/presentation/pages/route/route_stop_page.dart';
import 'package:bydgoszcz/presentation/pages/route/stop_quiz_page.dart';
import 'package:bydgoszcz/presentation/pages/route/verify_photo_page.dart';
import 'package:bydgoszcz/presentation/pages/start/start_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final AppCubit _appCubit;

  AppRouter() {
    _appCubit = AppCubit(getIt.get<AppStorage>())..initialize();
  }

  AppCubit get appCubit => _appCubit;

  late final GoRouter router = GoRouter(
    initialLocation: '/start',
    routes: [
      GoRoute(path: '/start', builder: (context, state) => const StartPage()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/monuments',
        builder: (context, state) => const MonumentsPage(),
      ),
      GoRoute(
        path: '/route/planning',
        builder: (context, state) => BlocProvider(
          create: (context) => RoutePlanningCubit(
            openAiService: getIt.get<OpenAiService>(),
            monumentsRepository: getIt.get<MonumentsRepository>(),
          ),
          child: const RoutePlanningPage(),
        ),
      ),
      GoRoute(
        path: '/monuments/list',
        builder: (context, state) => const MonumentsListPage(),
      ),
      GoRoute(
        path: '/monuments/camera',
        builder: (context, state) => BlocProvider(
          create: (context) => MonumentRecognitionCubit(
            openAiService: getIt.get<OpenAiService>(),
          ),
          child: const CameraPage(),
        ),
      ),
      GoRoute(
        path: '/monuments/description',
        builder: (context, state) => BlocProvider(
          create: (context) => MonumentDescriptionCubit(
            openAiService: getIt.get<OpenAiService>(),
          ),
          child: const DescriptionPage(),
        ),
      ),
      GoRoute(
        path: '/monuments/detail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          // Check if data was passed via extra
          final extra = state.extra;
          Monument? monument;
          Uint8List? imageBytes;

          if (extra is Map<String, dynamic>) {
            monument = extra['monument'] as Monument?;
            imageBytes = extra['imageBytes'] as Uint8List?;
          } else if (extra is Monument) {
            // Backward compatibility
            monument = extra;
          }

          return MonumentDetailPage(
            monumentId: monument == null ? id : null,
            monument: monument,
            imageBytes: imageBytes,
          );
        },
      ),
      GoRoute(
        path: '/route/adventures',
        builder: (context, state) => const MyAdventuresPage(),
      ),
      GoRoute(
        path: '/route/adventure/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RouteAdventurePage(routeId: id);
        },
      ),
      GoRoute(
        path: '/route/:routeId/stop/:stopId',
        builder: (context, state) {
          final routeId = state.pathParameters['routeId']!;
          final stopId = state.pathParameters['stopId']!;
          return RouteStopPage(routeId: routeId, stopId: stopId);
        },
      ),
      GoRoute(
        path: '/route/:routeId/stop/:stopId/confirm',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final route = extra['route'] as GeneratedRoute;
          final stop = extra['stop'] as RouteStop;
          final monument = extra['monument'] as Monument;
          return ConfirmPresencePage(
            route: route,
            stop: stop,
            monument: monument,
          );
        },
      ),
      GoRoute(
        path: '/route/:routeId/stop/:stopId/verify-photo',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final route = extra['route'] as GeneratedRoute;
          final stop = extra['stop'] as RouteStop;
          final monument = extra['monument'] as Monument;
          return VerifyPhotoPage(route: route, stop: stop, monument: monument);
        },
      ),
      GoRoute(
        path: '/route/:routeId/stop/:stopId/quiz',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final route = extra['route'] as GeneratedRoute;
          final stop = extra['stop'] as RouteStop;
          final monument = extra['monument'] as Monument;
          return StopQuizPage(route: route, stop: stop, monument: monument);
        },
      ),
    ],
  );
}
