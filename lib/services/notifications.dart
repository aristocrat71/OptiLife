import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Local daily reminders (Settings → Notifications). Two nudges: a morning
/// quests prompt and an evening journal prompt, each at a user-picked time.
/// Times are stored in `settings` as minutes-since-midnight.
class Reminders {
  Reminders._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static const _morningId = 0;
  static const _eveningId = 1;
  static const _channelId = 'daily_reminders';

  /// Call once at startup (before `runApp`): loads tz data + initializes the
  /// plugin. Does NOT request permission (we do that when the user opts in).
  static Future<void> init() async {
    tzdata.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation(await FlutterTimezone.getLocalTimezone()));
    } catch (_) {
      // Falls back to UTC — reminders still fire, just on UTC wall-clock.
    }
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
        const InitializationSettings(android: android, iOS: darwin));
  }

  /// Requests OS notification permission. Returns true if granted.
  static Future<bool> requestPermission() async {
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(
              alert: true, badge: true, sound: true) ??
          false;
    }
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      // Pre-13 returns null (no runtime permission needed) → treat as granted.
      return await android.requestNotificationsPermission() ?? true;
    }
    return true;
  }

  /// Re-schedules both reminders, or cancels everything when [enabled] is false.
  /// Call after any change to the toggle or the times.
  static Future<void> reschedule({
    required bool enabled,
    required int morningMin,
    required int eveningMin,
  }) async {
    await _plugin.cancelAll();
    if (!enabled) return;
    await _daily(_morningId, morningMin, '🎲 Your side quests await',
        "Roll today's quests and grow your biome.");
    await _daily(_eveningId, eveningMin, '🌙 Journal time',
        'Take a moment to reflect on your day.');
  }

  static Future<void> _daily(
      int id, int minutes, String title, String body) {
    return _plugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOf(minutes),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Daily reminders',
          channelDescription: 'Morning quest + evening journal nudges',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // Repeat daily at the same wall-clock time.
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOf(int minutes) {
    final now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, minutes ~/ 60, minutes % 60);
    if (!when.isAfter(now)) when = when.add(const Duration(days: 1));
    return when;
  }
}
