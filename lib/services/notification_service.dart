import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'watchlist_channel',
          channelName: 'Jadwal Nonton',
          channelDescription: 'Notifikasi untuk pengingat nonton',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      debug: true,
    );
  }

  Future<bool> requestPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return isAllowed;
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'watchlist_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Reminder,
        wakeUpScreen: true,
      ),
      schedule: NotificationCalendar(
        year: scheduledTime.year,
        month: scheduledTime.month,
        day: scheduledTime.day,
        hour: scheduledTime.hour,
        minute: scheduledTime.minute,
        second: 0,
        millisecond: 0,
        timeZone: localTimeZone,
        preciseAlarm: true,
        allowWhileIdle: true,
      ),
    );
  }

  Future<void> scheduleInactivityReminder() async {
    const int inactivityId = 888888;
    
    await AwesomeNotifications().cancel(inactivityId);
    //set 10 second untuk demo
    final scheduledTime = DateTime.now().add(const Duration(seconds: 10));
    String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: inactivityId,
        channelKey: 'watchlist_channel',
        title: 'Kangen nih! 🥺',
        body: 'Sudah seminggu gak lanjutin tontonanmu. Ayo nonton sekarang!',
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Recommendation,
        wakeUpScreen: true,
      ),
      schedule: NotificationCalendar(
        year: scheduledTime.year,
        month: scheduledTime.month,
        day: scheduledTime.day,
        hour: scheduledTime.hour,
        minute: scheduledTime.minute,
        second: scheduledTime.second,
        millisecond: 0,
        timeZone: localTimeZone,
        preciseAlarm: true,
        allowWhileIdle: true,
      ),
    );
  }
}