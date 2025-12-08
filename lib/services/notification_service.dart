import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const int _retentionId = 888888;

  Future<void> init() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/ic_notification', // Pastikan icon app sudah di-setup di android/app/src/main/res/drawable
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
        ),
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'retention_channel',
          channelName: 'Pengingat Kembali',
          channelDescription: 'Notifikasi agar user kembali membuka aplikasi',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Default,
        ),
      ],
      debug: true,
    );
  }

  Future<bool> requestPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await AwesomeNotifications()
          .requestPermissionToSendNotifications();
    }
    return isAllowed;
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    String localTimeZone = await AwesomeNotifications()
        .getLocalTimeZoneIdentifier();

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'watchlist_channel', // Masuk ke channel Watchlist
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

  Future<void> cancelScheduledRetention() async {
    await AwesomeNotifications().cancel(_retentionId);
    debugPrint("User kembali! Notifikasi retention dibatalkan.");
  }

  Future<void> scheduleAppClosedNotification() async {
    await AwesomeNotifications().cancel(_retentionId);

    String localTimeZone = await AwesomeNotifications()
        .getLocalTimeZoneIdentifier();

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _retentionId,
        channelKey: 'retention_channel', // Masuk ke channel Retention
        title: 'Kangen nih! 🥺',
        body:
            'Sudah lama tidak membuka Netlify, Ayo jadwalkan film baru untuk ditonton ',
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Recommendation,
        wakeUpScreen: true,
      ),
      schedule: NotificationInterval(
        interval: const Duration(seconds: 10), // 10 Detik untuk Demo
        timeZone: localTimeZone,
        repeats: true,
        preciseAlarm: true,
        allowWhileIdle: true,
      ),
    );
    debugPrint("App closed. Notifikasi dijadwalkan dalam 10 detik.");
  }
}
