import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import '../services/alert_sync_service.dart';

/// Background service initialisation for the Safety module.
///
/// Runs as a foreground Android service. Every [_syncIntervalMinutes] minutes:
///   1. Fetches the user's current GPS position.
///   2. Calls [AlertSyncService.sync] to pull live alerts from USGS,
///      NDMA SACHET, and OpenAQ into the local Drift DB.
///   3. If a CRITICAL alert is found that is newer than 30 minutes, pushes
///      a local notification with the real alert title.
///
/// Location is also updated on a shorter [_locationIntervalMinutes] cycle for
/// other Safety features (SOS, check-in timer) that depend on it.
Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'safety_foreground',
    'Safety Foreground Service',
    description: 'Monitors live safety alerts from USGS, NDMA SACHET, and OpenAQ.',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'safety_foreground',
      initialNotificationTitle: 'Adyuta Safety Active',
      initialNotificationContent:
          'Monitoring USGS, NDMA SACHET & OpenAQ in the background…',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

/// How often to sync live alert data (USGS + NDMA + OpenAQ).
const int _syncIntervalMinutes = 15;

/// How often to update the cached user location (for SOS / check-in).
const int _locationIntervalMinutes = 5;

/// Notification ID used for CRITICAL alert push notifications (distinct from
/// the foreground service notification at ID 888).
const int _alertNotificationId = 889;

double _lastLat = 0.0;
double _lastLon = 0.0;

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // ── Location update loop (every 5 minutes) ─────────────────────────────
  Timer.periodic(Duration(minutes: _locationIntervalMinutes), (timer) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _lastLat = position.latitude;
      _lastLon = position.longitude;
      debugPrint(
          'Safety BG: location updated to $_lastLat, $_lastLon');
    } catch (e) {
      debugPrint('Safety BG: GPS error — $e');
    }
  });

  // ── Alert sync loop (every 15 minutes) ────────────────────────────────
  // Also runs immediately on startup.
  Future<void> syncAndNotify() async {
    try {
      await AlertSyncService.sync(userLat: _lastLat, userLon: _lastLon);

      // Check for any CRITICAL alert observed in the last 30 minutes.
      final alerts = await AlertSyncService.getAlerts();
      final thirtyMinAgo = DateTime.now().subtract(const Duration(minutes: 30));

      for (final alert in alerts) {
        if (alert.severity == 'CRITICAL') {
          final observedAt = alert.observedAt > 0
              ? DateTime.fromMillisecondsSinceEpoch(alert.observedAt)
              : alert.timestamp;
          if (observedAt.isAfter(thirtyMinAgo)) {
            // Push a notification for this critical alert.
            await notifications.show(
              _alertNotificationId,
              '🔴 ${alert.source}: ${alert.severity}',
              alert.title,
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'safety_foreground',
                  'Safety Foreground Service',
                  icon: '@mipmap/ic_launcher',
                  ongoing: false,
                  importance: Importance.max,
                  priority: Priority.high,
                ),
              ),
            );
            debugPrint(
                'Safety BG: pushed CRITICAL alert notification — ${alert.title}');
            break; // Only notify once per sync cycle.
          }
        }
      }
    } catch (e) {
      debugPrint('Safety BG: sync error — $e');
    }
  }

  // Run once immediately on start.
  await syncAndNotify();

  // Then on the recurring timer.
  Timer.periodic(Duration(minutes: _syncIntervalMinutes), (timer) async {
    await syncAndNotify();
  });
}
