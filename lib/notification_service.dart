
import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // In-memory timers for app-running repeating notifications.
  static final Map<int, Timer> _timers = {};
  static int _nextTimerId = 1;

  // Initialize notification plugin
  static Future<void> init() async {
    // Android initialization settings
    final AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialization settings
    final InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    // Initialize notifications
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse? response) {
        // Optional: handle notification tap
      },
    );

    // Create Android notification channel (for Android 8.0+)
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel',
      'Reminders',
      importance: Importance.max,
      description: 'Channel for pet reminders',
    );

    try {
      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      print('[NotificationService] Created Android notification channel reminder_channel');
    } catch (e) {
      print('[NotificationService] Failed to create channel: $e');
    }

    // Request runtime permission on Android 13+ using permission_handler
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final status = await Permission.notification.status;
        if (!status.isGranted) {
          final result = await Permission.notification.request();
          print('[NotificationService] notification permission status=$result');
        } else {
          print('[NotificationService] notification permission already granted');
        }
      }
    } catch (e) {
      print('[NotificationService] Permission request failed: $e');
    }
  }

  // Show a notification
  static Future<void> showNotification(String title, String body) async {
    // Android notification details (cannot be const)
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_channel', // channel id
      'Reminders',        // channel name
      importance: Importance.max,
      priority: Priority.high,
    );

    final NotificationDetails details = NotificationDetails(android: androidDetails);

    // Show notification
    final int notifId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    print('[NotificationService] showNotification id=$notifId title="$title" body="$body" at ${DateTime.now().toIso8601String()}');
    await _notifications.show(
      notifId,
      title,
      body,
      details,
    );
  }

  // Schedule a repeating notification that starts at [start].
  // NOTE: This implementation uses in-memory Dart timers, so it only works
  // while the app process is running. For background/terminated apps
  // platform-specific alarm or background services are required.
  static Future<int> scheduleRepeatingFrom(
    DateTime start,
    String title,
    String body, {
    int intervalSeconds = 60,
  }) async {
    final int id = _nextTimerId++;
    Duration delay = start.difference(DateTime.now());
    if (delay.isNegative) delay = Duration.zero;

    print('[NotificationService] scheduling id=$id start=${start.toIso8601String()} interval=${intervalSeconds}s (now=${DateTime.now().toIso8601String()})');

    // When the start time arrives, fire one notification immediately
    // then start a periodic timer that fires every [intervalSeconds].
    int tick = 0;
    Timer startTimer = Timer(delay, () {
      print('[NotificationService] start timer fired for id=$id at ${DateTime.now().toIso8601String()}');
      showNotification(title, body);

      // 1-second debug tick (single run) to help verify timing
      Timer(Duration(seconds: 1), () {
        print('[NotificationService] 1s debug tick for id=$id at ${DateTime.now().toIso8601String()}');
      });

      // Cancel any existing periodic timer for this id first.
      _timers[id]?.cancel();
      _timers[id] = Timer.periodic(Duration(seconds: intervalSeconds), (timer) {
        tick++;
        print('[NotificationService] periodic tick #$tick for id=$id at ${DateTime.now().toIso8601String()}');
        showNotification(title, body);
      });
    });

    _timers[id] = startTimer;
    return id;
  }

  // Cancel a scheduled repeating notification created by scheduleRepeatingFrom.
  static Future<void> cancelSchedule(int id) async {
    _timers[id]?.cancel();
    _timers.remove(id);
  }
}
