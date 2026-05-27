// lib/presentation/providers/course_reminder_provider.dart

import 'dart:async';
import 'package:campuspulse/data/models/mock_data.dart';
import 'package:campuspulse/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseReminderNotifier extends StateNotifier<void> {
  Timer? _timer;
  final Set<String> _notifiedCourses = {};
  BuildContext? _appContext;

  CourseReminderNotifier() : super(null);

  void setAppContext(BuildContext context) {
    _appContext = context;
    NotificationService.setAppContext(context);
  }

  void startReminderCheck(String userUid) {
    // Arrêter tout timer existant
    _timer?.cancel();
    _notifiedCourses.clear();

    // Vérifier immédiatement
    _checkUpcomingCourses(userUid);

    // Vérifier toutes les minutes
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _checkUpcomingCourses(userUid),
    );
  }

  void stopReminderCheck() {
    _timer?.cancel();
    _notifiedCourses.clear();
  }

  void _checkUpcomingCourses(String userUid) {
    final now = DateTime.now();
    final userCourses =
        mockSchedule.where((course) => course.studentUid == userUid).toList();

    for (final course in userCourses) {
      final courseDateTime = _nextCourseDateTime(course.day, course.startTime);
      final minutesUntilCourse = courseDateTime.difference(now).inMinutes;

      // Si le cours est dans les 15 prochaines minutes et qu'on n'a pas encore notifié
      if (minutesUntilCourse == 15) {
        final courseKey =
            '${course.studentUid}_${course.title}_${courseDateTime.toIso8601String()}';

        if (!_notifiedCourses.contains(courseKey)) {
          _notifiedCourses.add(courseKey);

          // 1. Planifier notification système (pour la veille du téléphone)
          _scheduleSystemNotification(course, courseDateTime);

          // 2. Afficher notification in-app (si l'app est ouverte)
          if (_appContext != null) {
            NotificationService.showCourseReminderBanner(
              context: _appContext!,
              courseName: course.title,
              room: course.room,
              minutesLeft: 15,
            );
          }
        }
      }
    }
  }

  void _scheduleSystemNotification(
      CourseModel course, DateTime courseDateTime) {
    final reminderDateTime =
        courseDateTime.subtract(const Duration(minutes: 15));

    // Si le rappel est dans le futur, le planifier
    if (reminderDateTime.isAfter(DateTime.now())) {
      NotificationService.scheduleNotification(
        id: course.title.hashCode,
        title: 'Rappel de cours',
        body: '${course.title} commence dans 15 minutes à ${course.room}',
        scheduledDateTime: reminderDateTime,
      );
    }
  }

  DateTime _nextCourseDateTime(String dayName, String startTime) {
    final now = DateTime.now();
    final Map<String, int> weekdayMap = {
      'Lundi': DateTime.monday,
      'Mardi': DateTime.tuesday,
      'Mercredi': DateTime.wednesday,
      'Jeudi': DateTime.thursday,
      'Vendredi': DateTime.friday,
      'Samedi': DateTime.saturday,
      'Dimanche': DateTime.sunday,
    };

    final targetWeekday = weekdayMap[dayName] ?? now.weekday;
    final parts = startTime.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    var candidate = DateTime(now.year, now.month, now.day, hour, minute);
    final difference = targetWeekday - now.weekday;

    if (difference > 0) {
      candidate = candidate.add(Duration(days: difference));
    } else if (difference < 0) {
      candidate = candidate.add(Duration(days: difference + 7));
    } else if (candidate.isBefore(now)) {
      candidate = candidate.add(const Duration(days: 7));
    }

    return candidate;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final courseReminderProvider =
    StateNotifierProvider<CourseReminderNotifier, void>((ref) {
  return CourseReminderNotifier();
});
