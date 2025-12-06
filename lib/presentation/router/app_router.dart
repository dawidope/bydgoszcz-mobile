import 'package:bydgoszcz/data/local/app_storage.dart';
import 'package:bydgoszcz/di/injector.dart';
import 'package:bydgoszcz/presentation/bloc/app_cubit.dart';
import 'package:bydgoszcz/presentation/pages/home/home_page.dart';
import 'package:bydgoszcz/presentation/pages/onboarding/onboarding_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final AppCubit _appCubit;

  AppRouter() {
    _appCubit = AppCubit(getIt.get<AppStorage>())..initialize();
  }

  AppCubit get appCubit => _appCubit;

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final hasCompletedOnboarding = _appCubit.state.hasCompletedOnboarding;

      final isOnboarding = state.matchedLocation == '/onboarding';

      if (!hasCompletedOnboarding && !isOnboarding) {
        return '/onboarding';
      }

      if (hasCompletedOnboarding && isOnboarding) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
    ],
  );
}
