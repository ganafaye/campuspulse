// lib/presentation/screens/alerts_screen.dart

import 'package:campuspulse/data/models/mock_data.dart';
import 'package:campuspulse/presentation/providers/auth_provider.dart';
import 'package:campuspulse/service/local_storage_service.dart';
import 'package:campuspulse/service/firebase_service.dart';
import 'package:campuspulse/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  // Constantes de couleur tirées de ta maquette et harmonisées UADB
  static const Color primaryColor = Color(0xFF00113A);
  static const Color primaryContainer = Color(0xFF002366);
  static const Color secondaryColor = Color(0xFF115CB9);
  static const Color secondaryContainer = Color(0xFF659DFE);
  static const Color onSurfaceVariant = Color(0xFF444650);
  static const Color backgroundColor = Color(0xFFF8F9FB);
  static const Color outlineVariant = Color(0xFFC5C6D2);
  static const Color errorColor = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  static const Color secondaryFixed = Color(0xFFD7E2FF);
  static const Color onSecondaryFixedVariant = Color(0xFF004491);

  Future<List<dynamic>> _loadCoursesAndAlerts(String currentUserUid) async {
    final firebaseService = FirebaseService();
    try {
      final coursesSnap = await firebaseService.getCoursesRef().get();
      final alertsSnap = await firebaseService.getAlertsRef().get();

      final List<Map<String, dynamic>> courses = [];
      final List<Map<String, dynamic>> alerts = [];

      if (coursesSnap.exists && coursesSnap.value != null) {
        final Map<dynamic, dynamic> coursesData =
            coursesSnap.value as Map<dynamic, dynamic>;
        for (var entry in coursesData.entries) {
          final raw = Map<String, dynamic>.from(entry.value as Map);
          final studentUid = raw['studentUid'] ??
              raw['student'] ??
              raw['student_uid'] ??
              raw['studentId'] ??
              '';
          if (studentUid == currentUserUid ||
              (raw['students'] is List &&
                  (raw['students'] as List).contains(currentUserUid))) {
            raw['id'] = entry.key;
            raw['studentUid'] = studentUid;
            courses.add(raw);
          }
        }
      }

      if (alertsSnap.exists && alertsSnap.value != null) {
        final Map<dynamic, dynamic> alertsData =
            alertsSnap.value as Map<dynamic, dynamic>;
        for (var entry in alertsData.entries) {
          final raw = Map<String, dynamic>.from(entry.value as Map);
          final studentUid = raw['studentUid'] ??
              raw['student'] ??
              raw['student_uid'] ??
              'all';
          if (studentUid == currentUserUid || studentUid == 'all') {
            raw['id'] = entry.key;
            raw['studentUid'] = studentUid;
            alerts.add(raw);
          }
        }
      }

      await LocalStorageService.saveCachedCourses(currentUserUid, courses);
      await LocalStorageService.saveCachedAlerts(currentUserUid, alerts);

      return [coursesSnap, alertsSnap];
    } catch (e) {
      final cachedCourses =
          LocalStorageService.getCachedCourses(currentUserUid);
      final cachedAlerts = LocalStorageService.getCachedAlerts(currentUserUid);
      if (cachedCourses.isNotEmpty || cachedAlerts.isNotEmpty) {
        return [cachedCourses, cachedAlerts];
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final bool isAuthenticated = authState is AuthAuthenticated;
    final String currentUserUid =
        isAuthenticated ? authState.user.uid : 'guest';

    if (!isAuthenticated) {
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "AUJOURD'HUI",
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      'Tout marquer comme lu',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: outlineVariant),
                ),
                child: const Text(
                  'Connectez-vous pour afficher vos alertes personnalisées de cours.',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 16,
                    color: onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Si l'utilisateur est authentifié, on surveille les changements Firebase
    // et on affiche les alertes en temps réel
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _loadCoursesAndAlerts(currentUserUid),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                final dynamic coursesSource = snapshot.data?[0];
                final dynamic alertsSource = snapshot.data?[1];

                List<CourseModel> userCourses = [];
                List<CampusAlertModel> userStaticAlerts = [];

                try {
                  List<Map<String, dynamic>> coursesData = [];
                  List<Map<String, dynamic>> alertsData = [];

                  if (coursesSource is List) {
                    coursesData = coursesSource.cast<Map<String, dynamic>>();
                  } else if (coursesSource != null &&
                      coursesSource.value != null) {
                    coursesData = Map<String, dynamic>.from(
                            coursesSource.value as Map<dynamic, dynamic>)
                        .entries
                        .map((entry) {
                      final item =
                          Map<String, dynamic>.from(entry.value as Map);
                      item['id'] = entry.key;
                      return item;
                    }).toList();
                  }

                  if (alertsSource is List) {
                    alertsData = alertsSource.cast<Map<String, dynamic>>();
                  } else if (alertsSource != null &&
                      alertsSource.value != null) {
                    alertsData = Map<String, dynamic>.from(
                            alertsSource.value as Map<dynamic, dynamic>)
                        .entries
                        .map((entry) {
                      final item =
                          Map<String, dynamic>.from(entry.value as Map);
                      item['id'] = entry.key;
                      return item;
                    }).toList();
                  }

                  String parseTimeString(dynamic v) {
                    if (v == null) return '00:00';
                    if (v is String) return v;
                    if (v is int) {
                      final dt = DateTime.fromMillisecondsSinceEpoch(v);
                      final hh = dt.hour.toString().padLeft(2, '0');
                      final mm = dt.minute.toString().padLeft(2, '0');
                      return '$hh:$mm';
                    }
                    if (v is DateTime) {
                      final hh = v.hour.toString().padLeft(2, '0');
                      final mm = v.minute.toString().padLeft(2, '0');
                      return '$hh:$mm';
                    }
                    return v.toString();
                  }

                  for (var map in coursesData) {
                    final studentUid = map['studentUid'] ??
                        map['student'] ??
                        map['student_uid'] ??
                        map['studentId'] ??
                        '';
                    final start = parseTimeString(map['startTime'] ??
                        map['debutTime'] ??
                        map['start'] ??
                        map['debut'] ??
                        map['start_time']);
                    final end = parseTimeString(map['endTime'] ??
                        map['finTime'] ??
                        map['end'] ??
                        map['fin'] ??
                        map['end_time']);

                    final course = CourseModel(
                      studentUid: studentUid,
                      title: map['title'] ?? map['titre'] ?? map['name'] ?? '',
                      room: map['room'] ?? map['classe'] ?? map['salle'] ?? '',
                      teacher: map['teacher'] ??
                          map['professeur'] ??
                          map['enseignant'] ??
                          '',
                      day: map['day'] ?? map['jour'] ?? '',
                      startTime: start,
                      endTime: end,
                    );
                    userCourses.add(course);
                  }

                  for (var map in alertsData) {
                    final ts = map['timestamp'] ?? map['time'] ?? map['date'];
                    DateTime parsedTs = DateTime.now();
                    try {
                      if (ts is int) {
                        parsedTs = DateTime.fromMillisecondsSinceEpoch(ts);
                      } else if (ts is String) {
                        parsedTs = DateTime.parse(ts);
                      }
                    } catch (_) {}

                    final alert = CampusAlertModel(
                      id: map['id']?.toString() ?? 'unknown',
                      studentUid: map['studentUid'] ??
                          map['student'] ??
                          map['student_uid'] ??
                          'all',
                      title: map['title'] ?? map['tag'] ?? map['titre'] ?? '',
                      subtitle: map['subtitle'] ??
                          map['message'] ??
                          map['body'] ??
                          '',
                      category: (map['category'] ?? map['type'] ?? 'INFO')
                          .toString()
                          .toUpperCase(),
                      timestamp: parsedTs,
                    );
                    userStaticAlerts.add(alert);
                  }
                } catch (e) {
                  userCourses = mockSchedule
                      .where((c) => c.studentUid == currentUserUid)
                      .toList();
                  userStaticAlerts = mockAlerts
                      .where((a) =>
                          a.studentUid == currentUserUid ||
                          a.studentUid == 'all')
                      .toList();
                }

                final currentUserCourses = userCourses
                    .where((c) => c.studentUid == currentUserUid)
                    .toList();
                final reminderAlerts = _buildReminderAlerts(currentUserCourses);

                // Combiner les alertes : rappels et statiques
                final allAlerts = [
                  // Alertes de rappel
                  ...reminderAlerts,
                  // Alertes statiques Firebase
                  ...userStaticAlerts.where((a) =>
                      a.studentUid == currentUserUid || a.studentUid == 'all'),
                ]..sort((a, b) => b.timestamp.compareTo(a.timestamp));

                return _alertsBody(
                  context,
                  isAuthenticated,
                  currentUserCourses,
                  allAlerts,
                  currentUserUid,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _alertsBody(
    BuildContext context,
    bool isAuthenticated,
    List<CourseModel> currentUserCourses,
    List<CampusAlertModel> allAlerts,
    String currentUserUid,
  ) {
    final bool hasCourses = currentUserCourses.isNotEmpty;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "AUJOURD'HUI",
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AlertsScreen.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text(
                  'Tout marquer comme lu',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AlertsScreen.secondaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!hasCourses)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AlertsScreen.outlineVariant),
              ),
              child: const Text(
                'Connectez-vous pour afficher vos alertes personnalisées de cours.',
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontSize: 16,
                  color: AlertsScreen.onSurfaceVariant,
                ),
              ),
            )
          else ...[
            if (allAlerts.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AlertsScreen.outlineVariant),
                ),
                child: const Text(
                  'Aucune notification active pour le moment.',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 16,
                    color: AlertsScreen.onSurfaceVariant,
                  ),
                ),
              )
            else
              ...allAlerts.map((alert) {
                return Column(
                  children: [
                    _buildNotificationCard(
                      indicatorColor: _getIndicatorColor(alert.category),
                      iconWidget: _getIconWidget(alert.category),
                      tagText: alert.category,
                      tagColor: _getIndicatorColor(alert.category),
                      timeText: _formatRelativeTime(alert.timestamp),
                      bodyText: alert.subtitle,
                      actionWidget: _buildActionWidget(context, alert),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),
          ],
        ],
      ),
    );
  }

  List<CampusAlertModel> _buildReminderAlerts(List<CourseModel> courses) {
    final now = DateTime.now();
    final List<CampusAlertModel> reminders = [];

    for (final course in courses) {
      final courseDateTime = _nextCourseDateTime(course.day, course.startTime);
      final reminderDateTime =
          courseDateTime.subtract(const Duration(minutes: 15));
      final bool isUpcoming = courseDateTime.isAfter(now);

      if (!isUpcoming) continue;

      reminders.add(
        CampusAlertModel(
          id: 'reminder_${course.studentUid}_${course.title}_${course.day}',
          studentUid: course.studentUid,
          title: 'RAPPEL',
          subtitle:
              'Rappel : Votre cours de ${course.title} commence dans ${courseDateTime.difference(now).inMinutes} minutes en ${course.room}.',
          category: 'RAPPEL',
          timestamp: reminderDateTime.isAfter(now) ? reminderDateTime : now,
        ),
      );
    }

    if (reminders.isEmpty && courses.isNotEmpty) {
      final nextCourse = _findNextCourse(courses);
      if (nextCourse != null) {
        reminders.add(
          CampusAlertModel(
            id: 'reminder_sample_${nextCourse.studentUid}',
            studentUid: nextCourse.studentUid,
            title: 'RAPPEL',
            subtitle:
                'Rappel : Votre prochain cours ${nextCourse.title} aura lieu demain à ${nextCourse.startTime} en ${nextCourse.room}.',
            category: 'RAPPEL',
            timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
          ),
        );
      }
    }

    return reminders;
  }

  DateTime _nextCourseDateTime(String dayName, String startTime) {
    final now = DateTime.now();
    final weekDays = [
      'lundi',
      'mardi',
      'mercredi',
      'jeudi',
      'vendredi',
      'samedi',
      'dimanche'
    ];
    final targetDay = weekDays.indexOf(dayName.toLowerCase());
    if (targetDay == -1) return now.add(const Duration(days: 1));

    DateTime courseDate = now;
    while (courseDate.weekday - 1 != targetDay) {
      courseDate = courseDate.add(const Duration(days: 1));
    }

    final timeParts = startTime.split(':');
    final hour = int.tryParse(timeParts[0]) ?? 0;
    final minute = int.tryParse(timeParts.length > 1 ? timeParts[1] : '0') ?? 0;

    return DateTime(
        courseDate.year, courseDate.month, courseDate.day, hour, minute);
  }

  CourseModel? _findNextCourse(List<CourseModel> courses) {
    final now = DateTime.now();
    CourseModel? nextCourse;
    Duration? shortestDuration;

    for (final course in courses) {
      final courseDateTime = _nextCourseDateTime(course.day, course.startTime);
      if (courseDateTime.isAfter(now)) {
        final duration = courseDateTime.difference(now);
        if (shortestDuration == null || duration < shortestDuration) {
          nextCourse = course;
          shortestDuration = duration;
        }
      }
    }

    return nextCourse;
  }

  String _formatRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  Color _getIndicatorColor(String category) {
    switch (category) {
      case 'ADMINISTRATION':
        return errorColor;
      case 'RAPPEL':
        return secondaryColor;
      default:
        return secondaryColor;
    }
  }

  Widget _getIconWidget(String category) {
    IconData icon = Icons.notification_important;
    switch (category) {
      case 'ADMINISTRATION':
        icon = Icons.admin_panel_settings;
        break;
      case 'RAPPEL':
        icon = Icons.alarm;
        break;
      default:
        icon = Icons.notification_important;
    }
    return Icon(icon, color: Colors.white, size: 24);
  }

  Widget? _buildActionWidget(BuildContext context, CampusAlertModel alert) {
    if (alert.category == 'RAPPEL') {
      return ElevatedButton(
        onPressed: () {
          NotificationService.showImmediateNotification(
            id: alert.id.hashCode,
            title: 'Notification de test',
            body: alert.subtitle.isNotEmpty
                ? alert.subtitle
                : 'Test de rappel pour ${alert.title}',
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          elevation: 0,
        ),
        child: const Text(
          'Tester urgent',
          style: TextStyle(
            fontFamily: 'Public Sans',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );
    }
    return null;
  }

  Widget _buildNotificationCard({
    required Color indicatorColor,
    required Widget iconWidget,
    required String tagText,
    required Color tagColor,
    required String timeText,
    required String bodyText,
    Widget? actionWidget,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 120,
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(12)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: indicatorColor,
                          shape: BoxShape.circle,
                        ),
                        child: iconWidget,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tagText,
                              style: const TextStyle(
                                fontFamily: 'Public Sans',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              timeText,
                              style: const TextStyle(
                                fontFamily: 'Public Sans',
                                fontSize: 11,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    bodyText,
                    style: const TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 15,
                      height: 1.4,
                      color: primaryColor,
                    ),
                  ),
                  if (actionWidget != null) ...[
                    const SizedBox(height: 12),
                    actionWidget,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
