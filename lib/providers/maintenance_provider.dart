import 'package:flutter/foundation.dart';
import '../models/maintenance_schedule.dart';
import '../services/notification_service.dart';

class MaintenanceProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  List<MaintenanceSchedule> _schedules = [];

  List<MaintenanceSchedule> get schedules => _schedules;

  List<MaintenanceSchedule> get completedSchedules => 
    _schedules.where((s) => s.isCompleted).toList()
    ..sort((a, b) => b.completedDate!.compareTo(a.completedDate!));

  List<MaintenanceSchedule> get upcomingSchedules =>
    _schedules.where((s) => !s.isCompleted && s.scheduledDate.isAfter(DateTime.now())).toList()
    ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));

  void addSchedule(MaintenanceSchedule schedule) {
    _schedules.add(schedule);
    _notificationService.scheduleMaintenanceReminder(schedule);
    notifyListeners();
  }

  void updateSchedule(MaintenanceSchedule updatedSchedule) {
    final index = _schedules.indexWhere((s) => s.id == updatedSchedule.id);
    if (index != -1) {
      _schedules[index] = updatedSchedule;
      // Cancel existing notifications and schedule new ones
      _notificationService.cancelMaintenanceReminders(updatedSchedule.id);
      if (!updatedSchedule.isCompleted) {
        _notificationService.scheduleMaintenanceReminder(updatedSchedule);
      }
      notifyListeners();
    }
  }

  void completeSchedule(String scheduleId) {
    final index = _schedules.indexWhere((s) => s.id == scheduleId);
    if (index != -1) {
      _schedules[index] = _schedules[index].copyWith(
        isCompleted: true,
        completedDate: DateTime.now(),
      );
      // Cancel notifications since the maintenance is completed
      _notificationService.cancelMaintenanceReminders(scheduleId);
      notifyListeners();
    }
  }

  void deleteSchedule(String scheduleId) {
    _schedules.removeWhere((s) => s.id == scheduleId);
    // Cancel notifications for the deleted schedule
    _notificationService.cancelMaintenanceReminders(scheduleId);
    notifyListeners();
  }

  List<MaintenanceSchedule> getSchedulesForVehicle(String vehicleId) {
    return _schedules.where((s) => s.vehicleId == vehicleId).toList();
  }
} 