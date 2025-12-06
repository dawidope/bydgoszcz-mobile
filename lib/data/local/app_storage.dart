import 'dart:convert';

import 'package:bydgoszcz/core/constants/app_constants.dart';
import 'package:bydgoszcz/models/generated_route.dart';
import 'package:bydgoszcz/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  final SharedPreferences _prefs;

  AppStorage(this._prefs);

  Future<void> saveUserProfile(UserProfile profile) async {
    final json = jsonEncode(profile.toJson());
    await _prefs.setString(AppConstants.keyUserProfile, json);
  }

  UserProfile? getUserProfile() {
    final json = _prefs.getString(AppConstants.keyUserProfile);
    if (json == null) return null;
    return UserProfile.fromJson(jsonDecode(json));
  }

  Future<void> clearUserProfile() async {
    await _prefs.remove(AppConstants.keyUserProfile);
  }

  bool hasCompletedOnboarding() {
    return getUserProfile() != null;
  }

  // Routes
  Future<void> saveCurrentRoute(GeneratedRoute route) async {
    final json = jsonEncode(route.toJson());
    await _prefs.setString(AppConstants.keyCurrentRoute, json);
  }

  GeneratedRoute? getCurrentRoute() {
    final json = _prefs.getString(AppConstants.keyCurrentRoute);
    if (json == null) return null;
    return GeneratedRoute.fromJson(jsonDecode(json));
  }

  Future<void> clearCurrentRoute() async {
    await _prefs.remove(AppConstants.keyCurrentRoute);
  }

  Future<void> saveCompletedRoute(GeneratedRoute route) async {
    final routes = getCompletedRoutes();
    routes.add(route);

    final jsonList = routes.map((r) => r.toJson()).toList();
    final json = jsonEncode(jsonList);
    await _prefs.setString(AppConstants.keyCompletedRoutes, json);
  }

  List<GeneratedRoute> getCompletedRoutes() {
    final json = _prefs.getString(AppConstants.keyCompletedRoutes);
    if (json == null) return [];

    final List<dynamic> jsonList = jsonDecode(json);
    return jsonList.map((j) => GeneratedRoute.fromJson(j)).toList();
  }
}
