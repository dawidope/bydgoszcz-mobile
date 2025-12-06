import 'package:bydgoszcz/data/local/app_storage.dart';
import 'package:bydgoszcz/di/injector.dart';
import 'package:bydgoszcz/presentation/bloc/app_cubit.dart';
import 'package:bydgoszcz/presentation/pages/home/home_page.dart';
import 'package:bydgoszcz/presentation/pages/onboarding/onboarding_page.dart';
import 'package:bydgoszcz/presentation/pages/start/start_page.dart';
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
    ],
  );
}
