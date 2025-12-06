import 'package:bydgoszcz/data/local/app_storage.dart';
import 'package:bydgoszcz/models/generated_route.dart';
import 'package:bydgoszcz/models/user_profile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final AppStorage _storage;

  AppCubit(this._storage) : super(const AppState());

  void initialize() {
    final profile = _storage.getUserProfile();
    final currentRoute = _storage.getCurrentRoute();

    emit(
      state.copyWith(
        userProfile: profile,
        currentRoute: currentRoute,
        hasCompletedOnboarding: profile != null,
      ),
    );
  }

  Future<void> completeOnboarding(UserProfile profile) async {
    await _storage.saveUserProfile(profile);
    emit(state.copyWith(userProfile: profile, hasCompletedOnboarding: true));
  }

  Future<void> setCurrentRoute(GeneratedRoute route) async {
    await _storage.saveCurrentRoute(route);
    emit(state.copyWith(currentRoute: route));
  }

  Future<void> updateCurrentRoute(GeneratedRoute route) async {
    await _storage.saveCurrentRoute(route);
    emit(state.copyWith(currentRoute: route));
  }

  Future<void> completeCurrentRoute(GeneratedRoute completedRoute) async {
    await _storage.saveCompletedRoute(completedRoute);
    await _storage.clearCurrentRoute();
    emit(state.copyWith(currentRoute: null));
  }

  Future<void> clearCurrentRoute() async {
    await _storage.clearCurrentRoute();
    emit(state.copyWith(currentRoute: null));
  }

  List<GeneratedRoute> getCompletedRoutes() {
    return _storage.getCompletedRoutes();
  }
}
