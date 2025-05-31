import 'dart:async';
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationTrackingService {
  static final LocationTrackingService _instance =
      LocationTrackingService._internal();
  factory LocationTrackingService() => _instance;
  LocationTrackingService._internal();

  StreamSubscription<Position>? _positionSubscription;
  Position? _lastPosition;
  double _totalDistance = 0.0;
  bool _isTracking = false;

  // Keys for SharedPreferences
  static const String _totalDistanceKey = 'total_distance';
  static const String _lastLatKey = 'last_lat';
  static const String _lastLngKey = 'last_lng';
  static const String _isTrackingKey = 'is_tracking';

  Future<void> initialize() async {
    await _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    _totalDistance = prefs.getDouble(_totalDistanceKey) ?? 0.0;
    _isTracking = prefs.getBool(_isTrackingKey) ?? false;

    final lastLat = prefs.getDouble(_lastLatKey);
    final lastLng = prefs.getDouble(_lastLngKey);

    if (lastLat != null && lastLng != null) {
      _lastPosition = Position(
        longitude: lastLng,
        latitude: lastLat,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_totalDistanceKey, _totalDistance);
    await prefs.setBool(_isTrackingKey, _isTracking);

    if (_lastPosition != null) {
      await prefs.setDouble(_lastLatKey, _lastPosition!.latitude);
      await prefs.setDouble(_lastLngKey, _lastPosition!.longitude);
    }
  }

  Future<bool> requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<void> startTracking() async {
    if (_isTracking) return;

    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      throw Exception('Location permissions not granted');
    }

    _isTracking = true;
    await _saveData();

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Only update when moved 10 meters
    );

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _updateDistance(position);
    });
  }

  void _updateDistance(Position newPosition) {
    if (_lastPosition != null) {
      final distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );

      // Only add distance if it's reasonable (not GPS jumping)
      if (distance > 0 && distance < 1000) {
        // Max 1km per update
        _totalDistance += distance / 1000; // Convert to kilometers
        _saveData();
      }
    }
    _lastPosition = newPosition;
  }

  Future<void> stopTracking() async {
    _isTracking = false;
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    await _saveData();
  }

  double get totalDistanceKm => _totalDistance;
  bool get isTracking => _isTracking;

  void resetDistance() async {
    _totalDistance = 0.0;
    await _saveData();
  }

  // Get distance since a specific date
  double getDistanceSince(DateTime date) {
    // This is simplified - in a real app, you'd store distance history
    // For now, we'll return total distance if the date is recent
    final daysDiff = DateTime.now().difference(date).inDays;
    if (daysDiff <= 30) {
      // If within last 30 days
      return _totalDistance;
    }
    return 0.0; // Would need historical data for older dates
  }
}
