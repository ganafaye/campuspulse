// lib/service/notification_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static BuildContext? _appContext;
  static final Set<String> _shownNotificationIds = {};

  // Initialisation globale
  static Future<void> init({BuildContext? appContext}) async {
    _appContext = appContext;
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Logique quand l'utilisateur clique sur la notification (optionnel)
      },
    );

    // Demander la permission sur Android 13+ et iOS
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static void setAppContext(BuildContext context) {
    _appContext = context;
  }

  // 1. Notification immédiate avec foreground overlay (Type: Changement de salle, Cours annulé)
  static Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    bool showInApp = true,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'campus_alerts_channel',
      'Alertes Campus',
      channelDescription:
          'Notifications urgentes (Changements de salles, etc.)',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      enableLights: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(id, title, body, platformDetails);

    // Afficher aussi dans l'app si le contexte est disponible
    if (showInApp && _appContext != null) {
      _showInAppNotificationBanner(
        context: _appContext!,
        title: title,
        body: body,
        type: 'urgent',
      );
    }
  }

  // 2. Planifier une notification (Ex: 15 minutes avant un cours)
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
  }) async {
    // Si l'heure planifiée est déjà passée, on ne fait rien
    if (scheduledDateTime.isBefore(DateTime.now())) return;

    await _notificationsPlugin.cancel(id);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'course_reminders_channel',
          'Rappels de cours',
          channelDescription: 'Rappels de cours 15 minutes avant',
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
          enableLights: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // 3. Notification in-app (Banner/Overlay style WhatsApp)
  static void _showInAppNotificationBanner({
    required BuildContext context,
    required String title,
    required String body,
    String type = 'reminder', // 'reminder', 'urgent', 'info'
  }) {
    final String notifId = '${title}_${DateTime.now().millisecondsSinceEpoch}';

    // Éviter les doublons
    if (_shownNotificationIds.contains(notifId)) return;
    _shownNotificationIds.add(notifId);

    final Color backgroundColor = type == 'urgent'
        ? const Color(0xFFBA1A1A)
        : type == 'reminder'
            ? const Color(0xFF115CB9)
            : const Color(0xFF444650);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Public Sans',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              body,
              style: const TextStyle(
                fontFamily: 'Public Sans',
                fontSize: 14,
                color: Colors.white70,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    // Nettoyer après affichage
    Future.delayed(const Duration(seconds: 6), () {
      _shownNotificationIds.remove(notifId);
    });
  }

  // 4. Afficher notification in-app pour rappel de cours
  static void showCourseReminderBanner({
    required BuildContext context,
    required String courseName,
    required String room,
    required int minutesLeft,
  }) {
    _showInAppNotificationBanner(
      context: context,
      title: 'Rappel de cours',
      body: '$courseName commence dans $minutesLeft minutes à $room',
      type: 'reminder',
    );
  }

  // 5. Tout annuler lors d'un changement de compte / déconnexion
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    _shownNotificationIds.clear();
  }
}
