import 'package:flutter/material.dart';
import '../models/maintenance_schedule.dart';
import '../services/location_tracking_service.dart';

class MaintenanceProvider with ChangeNotifier {
  final List<MaintenanceSchedule> _schedules = [];
  final LocationTrackingService _locationService = LocationTrackingService();

  List<MaintenanceSchedule> get upcomingSchedules =>
      _schedules.where((s) => !s.isCompleted).toList();

  List<MaintenanceSchedule> get completedSchedules =>
      _schedules.where((s) => s.isCompleted).toList();

  // Get schedules that need attention based on auto-tracking
  List<MaintenanceSchedule> get overdueSchedules {
    final now = DateTime.now();
    final currentDistance = _locationService.totalDistanceKm;

    return _schedules.where((schedule) {
      if (!schedule.autoTrackingEnabled || !schedule.isCompleted) return false;

      // Check time-based overdue
      if (schedule.intervalDays != null) {
        final daysSinceService = now.difference(schedule.completedDate!).inDays;
        if (daysSinceService >= schedule.intervalDays!) return true;
      }

      // Check distance-based overdue
      if (schedule.intervalKm != null && schedule.kmAtService != null) {
        final kmSinceService = currentDistance - schedule.kmAtService!;
        if (kmSinceService >= schedule.intervalKm!) return true;
      }

      return false;
    }).toList();
  }

  Future<void> initialize() async {
    await _locationService.initialize();
    notifyListeners();
  }

  void addSchedule(MaintenanceSchedule schedule) {
    _schedules.add(schedule);
    notifyListeners();
  }

  void completeSchedule(String id, {double? currentKm}) {
    final index = _schedules.indexWhere((s) => s.id == id);
    if (index != -1) {
      final schedule = _schedules[index];
      _schedules[index] = schedule.copyWith(
        isCompleted: true,
        completedDate: DateTime.now(),
        kmAtService: currentKm ?? _locationService.totalDistanceKm,
      );

      // If auto-tracking is enabled, create next schedule
      if (schedule.autoTrackingEnabled) {
        _createNextSchedule(
            schedule, currentKm ?? _locationService.totalDistanceKm);
      }

      notifyListeners();
    }
  }

  void _createNextSchedule(
      MaintenanceSchedule completedSchedule, double currentKm) {
    DateTime nextDate = DateTime.now();
    if (completedSchedule.intervalDays != null) {
      nextDate =
          DateTime.now().add(Duration(days: completedSchedule.intervalDays!));
    }

    final nextSchedule = MaintenanceSchedule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      vehicleId: completedSchedule.vehicleId,
      serviceType: completedSchedule.serviceType,
      scheduledDate: nextDate,
      notes: 'Auto-generated based on previous service',
      intervalKm: completedSchedule.intervalKm,
      intervalDays: completedSchedule.intervalDays,
      autoTrackingEnabled: true,
    );

    _schedules.add(nextSchedule);
  }

  void deleteSchedule(String id) {
    _schedules.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  Future<void> startLocationTracking() async {
    try {
      await _locationService.startTracking();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to start location tracking: $e');
    }
  }

  Future<void> stopLocationTracking() async {
    await _locationService.stopTracking();
    notifyListeners();
  }

  bool get isTrackingLocation => _locationService.isTracking;
  double get totalDistanceKm => _locationService.totalDistanceKm;
}
