import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

class NotificationService {
  // Singleton — chỉ tạo 1 instance NotificationService
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();
  // Plugin chính để hiển thị notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // Stream lắng nghe khi người dùng bấm vào notification
  final StreamController<NotificationResponse> selectNotificationStream =
      StreamController<NotificationResponse>.broadcast();
  // Khởi tạo notification service
  Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    // Khi user bấm vào một thông báo
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
            selectNotificationStream.add(notificationResponse);
          },
    );

    _configureSelectNotificationSubject(navigatorKey);
  }

  // Khi người dùng bấm vào thông báo
  void _configureSelectNotificationSubject(
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    selectNotificationStream.stream.listen((
      NotificationResponse response,
    ) async {
      debugPrint('Notification Tapped! Payload: ${response.payload}');
      if (response.payload == 'payment_success') {
        navigatorKey.currentContext?.go('/payment_history');
      }
    });
  }

  // Yêu cầu quyền thông báo
  Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  // Hiển thị thông báo
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'pkmoto_channel_id', // Channel ID
          'PKMOTO Notifications', // Channel Name
          channelDescription: 'Channel for important app notifications.',
          importance: Importance.max,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound(
            'bell_notification_337658',
          ),
          timeoutAfter: 5000, // Thông báo sẽ tự biến mất sau 5000ms (5 giây)
          ticker: 'ticker',
        );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
