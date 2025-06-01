import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/maintenance_schedule.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(initSettings);
  }

  Future<void> scheduleMaintenanceReminder(MaintenanceSchedule schedule) async {
    final now = DateTime.now();
    final daysUntilMaintenance = schedule.scheduledDate.difference(now).inDays;
    
    // Only schedule notifications if the maintenance is within the next 7 days
    if (daysUntilMaintenance > 0 && daysUntilMaintenance <= 7) {
      // Schedule a notification for each day until the maintenance date
      for (int i = 1; i <= daysUntilMaintenance; i++) {
        final scheduledDate = schedule.scheduledDate.subtract(Duration(days: i));
        if (scheduledDate.isAfter(now)) {
          await _notifications.zonedSchedule(
            schedule.id.hashCode + i, // Unique ID for each notification
            'Pengingat Perawatan',
            'Perawatan ${schedule.serviceType} akan dilakukan dalam ${daysUntilMaintenance - i + 1} hari',
            tz.TZDateTime.from(scheduledDate, tz.local),
            NotificationDetails(
              android: AndroidNotificationDetails(
                'maintenance_reminders',
                'Maintenance Reminders',
                channelDescription: 'Notifications for upcoming maintenance schedules',
                importance: Importance.high,
                priority: Priority.high,
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
        }
      }
    }
  }

  Future<void> cancelMaintenanceReminders(String scheduleId) async {
    // Cancel all notifications for this schedule
    for (int i = 1; i <= 7; i++) {
      await _notifications.cancel(scheduleId.hashCode + i);
    }
  }
} 