import 'package:flutter/foundation.dart';
import '../models/maintenance_schedule.dart';

class MaintenanceProvider with ChangeNotifier {
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
    notifyListeners();
  }

  void updateSchedule(MaintenanceSchedule updatedSchedule) {
    final index = _schedules.indexWhere((s) => s.id == updatedSchedule.id);
    if (index != -1) {
      _schedules[index] = updatedSchedule;
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
      notifyListeners();
    }
  }

  void deleteSchedule(String scheduleId) {
    _schedules.removeWhere((s) => s.id == scheduleId);
    notifyListeners();
  }

  List<MaintenanceSchedule> getSchedulesForVehicle(String vehicleId) {
    return _schedules.where((s) => s.vehicleId == vehicleId).toList();
  }
} 