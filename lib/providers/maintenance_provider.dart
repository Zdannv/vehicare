import 'package:flutter/foundation.dart';
import '../models/maintenance_schedule.dart';
import '../services/notification_service.dart';
import 'dart:developer' as developer;

class MaintenanceProvider with ChangeNotifier {
  final List<MaintenanceSchedule> _schedules = [];
  final NotificationService _notificationService = NotificationService();

  List<MaintenanceSchedule> get schedules => _schedules;

  List<MaintenanceSchedule> get completedSchedules {
    return _schedules.where((schedule) => schedule.isCompleted).toList()
      ..sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
  }

  List<MaintenanceSchedule> get upcomingSchedules {
    return _schedules.where((schedule) => !schedule.isCompleted).toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
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

  Future<void> completeSchedule(String scheduleId) async {
    developer.log('Completing maintenance schedule: $scheduleId');
    
    final index = _schedules.indexWhere((s) => s.id == scheduleId);
    if (index != -1) {
      _schedules[index] = _schedules[index].copyWith(isCompleted: true);
      notifyListeners();

      try {
        developer.log('Cancelling notifications for completed schedule: $scheduleId');
        await _notificationService.cancelMaintenanceReminders(scheduleId);
      } catch (e) {
        developer.log('Error cancelling notifications: $e');
      }
    }
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

  List<MaintenanceSchedule> getSchedulesForVehicle(String vehicleId) {
    return _schedules.where((s) => s.vehicleId == vehicleId).toList();
  }
} 