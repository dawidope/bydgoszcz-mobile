part of 'app_cubit.dart';

class AppState extends Equatable {
  final UserProfile? userProfile;
  final GeneratedRoute? currentRoute;
  final bool hasCompletedOnboarding;

  const AppState({
    this.userProfile,
    this.currentRoute,
    this.hasCompletedOnboarding = false,
  });

  AppState copyWith({
    UserProfile? userProfile,
    GeneratedRoute? currentRoute,
    bool? hasCompletedOnboarding,
  }) {
    return AppState(
      userProfile: userProfile ?? this.userProfile,
      currentRoute: currentRoute,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  @override
  List<Object?> get props => [
    userProfile,
    currentRoute,
    hasCompletedOnboarding,
  ];
}
