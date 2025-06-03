import 'package:flutter/material.dart';
import '../models/maintenance_schedule.dart';
import '../services/notification_service.dart';
import '../services/location_tracking_service.dart';
import 'dart:developer' as developer;

class MaintenanceProvider with ChangeNotifier {
  final List<MaintenanceSchedule> _schedules = [];
  final NotificationService _notificationService = NotificationService();
  final LocationTrackingService _locationService = LocationTrackingService();

  List<MaintenanceSchedule> get schedules => _schedules;

  List<MaintenanceSchedule> get completedSchedules {
    return _schedules.where((schedule) => schedule.isCompleted).toList()
      ..sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
  }

  List<MaintenanceSchedule> get upcomingSchedules {
    return _schedules.where((schedule) => !schedule.isCompleted).toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

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

  Future<void> addSchedule(MaintenanceSchedule schedule) async {
    developer.log('Adding new maintenance schedule: ${schedule.serviceType}');
    developer.log('Scheduled date: ${schedule.scheduledDate}');
    
    _schedules.add(schedule);
    notifyListeners();

    try {
      developer.log('Attempting to schedule notification for: ${schedule.serviceType}');
      await _notificationService.scheduleMaintenanceReminder(schedule);
      developer.log('Successfully scheduled notification for: ${schedule.serviceType}');
    } catch (e) {
      developer.log('Error scheduling notification: $e');
    }
  }

  Future<void> updateSchedule(MaintenanceSchedule updatedSchedule) async {
    developer.log('Updating maintenance schedule: ${updatedSchedule.serviceType}');
    developer.log('New scheduled date: ${updatedSchedule.scheduledDate}');
    
    final index = _schedules.indexWhere((s) => s.id == updatedSchedule.id);
    if (index != -1) {
      _schedules[index] = updatedSchedule;
      notifyListeners();

      try {
        developer.log('Cancelling old notifications for: ${updatedSchedule.serviceType}');
        await _notificationService.cancelMaintenanceReminders(updatedSchedule.id);
        
        if (!updatedSchedule.isCompleted) {
          developer.log('Scheduling new notifications for: ${updatedSchedule.serviceType}');
          await _notificationService.scheduleMaintenanceReminder(updatedSchedule);
        }
      } catch (e) {
        developer.log('Error updating notifications: $e');
      }
    }
  }

  Future<void> completeSchedule(String scheduleId, {double? currentKm}) async {
    developer.log('Completing maintenance schedule: $scheduleId');
    
    final index = _schedules.indexWhere((s) => s.id == scheduleId);
    if (index != -1) {
      final schedule = _schedules[index];
      _schedules[index] = schedule.copyWith(
        isCompleted: true,
        completedDate: DateTime.now(),
        kmAtService: currentKm ?? _locationService.totalDistanceKm,
      );

      // If auto-tracking is enabled, create next schedule
      if (schedule.autoTrackingEnabled) {
        await _createNextSchedule(schedule, currentKm ?? _locationService.totalDistanceKm);
      }

      notifyListeners();

      try {
        developer.log('Cancelling notifications for completed schedule: $scheduleId');
        await _notificationService.cancelMaintenanceReminders(scheduleId);
      } catch (e) {
        developer.log('Error cancelling notifications: $e');
      }
    }
  }

  Future<void> _createNextSchedule(MaintenanceSchedule completedSchedule, double currentKm) async {
    DateTime nextDate = DateTime.now();
    if (completedSchedule.intervalDays != null) {
      nextDate = DateTime.now().add(Duration(days: completedSchedule.intervalDays!));
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

    developer.log('Creating next auto-generated schedule: ${nextSchedule.serviceType}');
    await addSchedule(nextSchedule);
  }

  Future<void> deleteSchedule(String scheduleId) async {
    developer.log('Deleting maintenance schedule: $scheduleId');
    
    _schedules.removeWhere((s) => s.id == scheduleId);
    notifyListeners();

    try {
      developer.log('Cancelling notifications for deleted schedule: $scheduleId');
      await _notificationService.cancelMaintenanceReminders(scheduleId);
    } catch (e) {
      developer.log('Error cancelling notifications: $e');
    }
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