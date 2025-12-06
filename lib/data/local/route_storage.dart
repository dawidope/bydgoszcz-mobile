import 'package:bydgoszcz/models/generated_route.dart';

/// In-memory storage for routes during app session
/// This is temporary storage - routes are lost when app is closed
class RouteStorage {
  static final RouteStorage _instance = RouteStorage._internal();
  factory RouteStorage() => _instance;
  RouteStorage._internal();

  final Map<String, GeneratedRoute> _routes = {};
  GeneratedRoute? _currentRoute;

  /// Save a route to storage
  void saveRoute(GeneratedRoute route) {
    _routes[route.id] = route;
    _currentRoute = route;
  }

  /// Get route by ID
  GeneratedRoute? getRoute(String id) {
    return _routes[id];
  }

  /// Get current active route
  GeneratedRoute? getCurrentRoute() {
    return _currentRoute;
  }

  /// Set current active route
  void setCurrentRoute(GeneratedRoute? route) {
    _currentRoute = route;
    if (route != null) {
      _routes[route.id] = route;
    }
  }

  /// Get all saved routes
  List<GeneratedRoute> getAllRoutes() {
    return _routes.values.toList();
  }

  /// Update a route (e.g., mark stop as visited)
  void updateRoute(GeneratedRoute route) {
    _routes[route.id] = route;
    if (_currentRoute?.id == route.id) {
      _currentRoute = route;
    }
  }

  /// Delete a route
  void deleteRoute(String id) {
    _routes.remove(id);
    if (_currentRoute?.id == id) {
      _currentRoute = null;
    }
  }

  /// Clear all routes
  void clearAll() {
    _routes.clear();
    _currentRoute = null;
  }
}
