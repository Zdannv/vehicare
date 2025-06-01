import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/maintenance_schedule.dart';
import 'dart:developer' as developer;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  // Waktu notifikasi dalam format [jam, menit]
  final List<List<int>> _notificationTimes = [
    [9, 0],  // 9:00 AM
    [12, 0], // 12:00 PM
    [18, 0], // 6:00 PM
  ];

  Future<void> initialize() async {
    tz.initializeTimeZones();
    developer.log('Initializing notification service...');
    
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
    
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        developer.log('Notification tapped: ${response.payload}');
      },
    );

    // Request notification permissions for Android 13 and above
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestPermission();
      developer.log('Notification permissions requested');
    }
  }

  Future<void> showImmediateNotification(MaintenanceSchedule schedule) async {
    final now = DateTime.now();
    final daysUntilMaintenance = schedule.scheduledDate.difference(now).inDays;
    
    developer.log('Showing immediate notification for: ${schedule.serviceType}');
    developer.log('Days until maintenance: $daysUntilMaintenance');

    const androidDetails = AndroidNotificationDetails(
      'maintenance_reminders',
      'Maintenance Reminders',
      channelDescription: 'Notifications for upcoming maintenance schedules',
      importance: Importance.high,
      priority: Priority.high,
      enableLights: true,
      enableVibration: true,
      playSound: true,
      showWhen: true,
      autoCancel: false,
      fullScreenIntent: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(
        schedule.id.hashCode,
        'Jadwal Perawatan Baru',
        'Perawatan ${schedule.serviceType} akan dilakukan dalam $daysUntilMaintenance hari',
        details,
      );
      developer.log('Immediate notification shown successfully');
    } catch (e) {
      developer.log('Error showing immediate notification: $e');
    }
  }

  Future<void> scheduleMaintenanceReminder(MaintenanceSchedule schedule) async {
    final now = DateTime.now();
    final daysUntilMaintenance = schedule.scheduledDate.difference(now).inDays;
    
    developer.log('Scheduling notification for maintenance: ${schedule.serviceType}');
    developer.log('Current time: $now');
    developer.log('Scheduled date: ${schedule.scheduledDate}');
    developer.log('Days until maintenance: $daysUntilMaintenance');
    
    // Show immediate notification
    await showImmediateNotification(schedule);
    
    // Only schedule notifications if the maintenance is within the next 7 days
    if (daysUntilMaintenance > 0 && daysUntilMaintenance <= 7) {
      // Schedule a notification for each day until the maintenance date
      for (int i = 1; i <= daysUntilMaintenance; i++) {
        final scheduledDate = schedule.scheduledDate.subtract(Duration(days: i));
        if (scheduledDate.isAfter(now)) {
          // Schedule notifications for each time slot
          for (int j = 0; j < _notificationTimes.length; j++) {
            final time = _notificationTimes[j];
            final notificationId = schedule.id.hashCode + (i * 10) + j;
            
            try {
              // Create scheduled time with specific hour and minute
              final scheduledTime = tz.TZDateTime(
                tz.local,
                scheduledDate.year,
                scheduledDate.month,
                scheduledDate.day,
                time[0], // hour
                time[1], // minute
              );
              
              // Skip if the time has already passed for today
              if (scheduledTime.isBefore(now)) {
                developer.log('Skipping notification for time ${time[0]}:${time[1]} as it has passed');
                continue;
              }
              
              developer.log('Scheduling notification ID: $notificationId for date: $scheduledDate at ${time[0]}:${time[1]}');
              developer.log('Scheduled time in local timezone: $scheduledTime');
              
              await _notifications.zonedSchedule(
                notificationId,
                'Pengingat Perawatan',
                'Perawatan ${schedule.serviceType} akan dilakukan dalam ${daysUntilMaintenance - i + 1} hari',
                scheduledTime,
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                    'maintenance_reminders',
                    'Maintenance Reminders',
                    channelDescription: 'Notifications for upcoming maintenance schedules',
                    importance: Importance.high,
                    priority: Priority.high,
                    enableLights: true,
                    enableVibration: true,
                    playSound: true,
                    showWhen: true,
                    autoCancel: false,
                    fullScreenIntent: true,
                  ),
                  iOS: DarwinNotificationDetails(
                    presentAlert: true,
                    presentBadge: true,
                    presentSound: true,
                  ),
                ),
                androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
              );
              
              // Verify the scheduled notification
              final pendingNotifications = await _notifications.pendingNotificationRequests();
              developer.log('Total pending notifications: ${pendingNotifications.length}');
              for (var notification in pendingNotifications) {
                developer.log('Pending notification ID: ${notification.id}');
              }
              
              developer.log('Successfully scheduled notification ID: $notificationId for ${time[0]}:${time[1]}');
            } catch (e) {
              developer.log('Error scheduling notification for time ${time[0]}:${time[1]}: $e');
            }
          }
        }
      }
    } else {
      developer.log('Maintenance is not within the next 7 days, skipping notification');
    }
  }

  Future<void> cancelMaintenanceReminders(String scheduleId) async {
    developer.log('Cancelling notifications for schedule: $scheduleId');
    // Cancel all notifications for this schedule
    for (int i = 1; i <= 7; i++) {
      for (int j = 0; j < _notificationTimes.length; j++) {
        final notificationId = scheduleId.hashCode + (i * 10) + j;
        await _notifications.cancel(notificationId);
        developer.log('Cancelled notification ID: $notificationId');
      }
    }
  }
} 