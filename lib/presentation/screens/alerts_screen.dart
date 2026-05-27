// lib/presentation/screens/alerts_screen.dart

import 'package:campuspulse/data/models/mock_data.dart';
import 'package:campuspulse/presentation/providers/auth_provider.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final bool isAuthenticated = authState is AuthAuthenticated;
    final String currentUserUid =
        isAuthenticated ? authState.user.uid : 'guest';

    final List<CourseModel> userCourses = isAuthenticated
        ? mockSchedule
            .where((course) => course.studentUid == currentUserUid)
            .toList()
        : [];

    final List<CampusAlertModel> userStaticAlerts = isAuthenticated
        ? mockAlerts
            .where((alert) =>
                alert.studentUid == currentUserUid || alert.studentUid == 'all')
            .toList()
        : [];

    final List<CampusAlertModel> reminderAlerts =
        _buildReminderAlerts(userCourses);

    final List<CampusAlertModel> allAlerts = [
      ...reminderAlerts,
      ...userStaticAlerts,
    ]..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Public Sans',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: primaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: primaryColor),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: primaryColor),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
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
              if (!isAuthenticated) ...[
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
                const SizedBox(height: 24),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        userCourses.isEmpty
                            ? 'Aucune alerte de cours pour le moment.'
                            : 'Vous avez ${userCourses.length} cours programmés. Utilisez les tests de notification ci-dessous.',
                        style: const TextStyle(
                          fontFamily: 'Public Sans',
                          fontSize: 15,
                          color: onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (userCourses.isNotEmpty) ...[
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final nextCourse = _findNextCourse(userCourses);
                          if (nextCourse == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Aucun cours disponible pour tester.'),
                              ),
                            );
                            return;
                          }

                          final scheduledTime = _nextReminderTime(nextCourse);
                          await NotificationService.scheduleNotification(
                            id: nextCourse.title.hashCode,
                            title: 'Rappel de cours',
                            body:
                                'Votre cours de ${nextCourse.title} commence dans 15 minutes à ${nextCourse.room}.',
                            scheduledDateTime: scheduledTime,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Notification programmée pour ${nextCourse.title}'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryContainer,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Tester rappel',
                          style: TextStyle(
                            fontFamily: 'Public Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () async {
                          await NotificationService.showImmediateNotification(
                            id: userCourses.first.title.hashCode,
                            title: 'Changement de salle',
                            body:
                                'Votre prochain cours a une modification de salle ou d’horaire.',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Notification de test envoyée immédiatement.'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
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
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
              ],
              if (allAlerts.isEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: outlineVariant),
                  ),
                  child: const Text(
                    'Aucune notification active pour le moment.',
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 16,
                      color: onSurfaceVariant,
                    ),
                  ),
                ),
              ] else
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
                }).toList(),
            ],
          ),
        ),
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

  CourseModel? _findNextCourse(List<CourseModel> courses) {
    if (courses.isEmpty) return null;
    final sorted = List<CourseModel>.from(courses)
      ..sort((a, b) {
        final aDate = _nextCourseDateTime(a.day, a.startTime);
        final bDate = _nextCourseDateTime(b.day, b.startTime);
        return aDate.compareTo(bDate);
      });
    return sorted.first;
  }

  String _formatRelativeTime(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inSeconds < 60) {
      return 'À l\'instant';
    }
    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    }
    if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours} h';
    }
    return 'Il y a ${difference.inDays} j';
  }

  Color _getIndicatorColor(String category) {
    if (category == 'URGENT' || category == 'ANNULÉ') {
      return errorColor;
    }
    if (category == 'RAPPEL') {
      return secondaryColor;
    }
    return onSurfaceVariant;
  }

  Widget _getIconWidget(String category) {
    if (category == 'URGENT' || category == 'ANNULÉ') {
      return Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: errorContainer,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.warning, color: onErrorContainer, size: 24),
      );
    }
    if (category == 'RAPPEL') {
      return Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: secondaryFixed,
          shape: BoxShape.circle,
        ),
        child:
            const Icon(Icons.alarm, color: onSecondaryFixedVariant, size: 24),
      );
    }
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0xFFECEEF0),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.info_outline, color: onSurfaceVariant, size: 24),
    );
  }

  Widget? _buildActionWidget(BuildContext context, CampusAlertModel alert) {
    if (alert.category == 'URGENT' || alert.category == 'ANNULÉ') {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryContainer,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            elevation: 0,
          ),
          child: const Text(
            'Voir sur le plan',
            style: TextStyle(
              fontFamily: 'Public Sans',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    if (alert.category == 'INFO') {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: InkWell(
          onTap: () {},
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'En savoir plus ',
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                  fontSize: 14,
                ),
              ),
              Icon(Icons.open_in_new, color: secondaryColor, size: 16),
            ],
          ),
        ),
      );
    }
    return null;
  }

  DateTime _nextReminderTime(CourseModel course) {
    final courseDateTime = _nextCourseDateTime(course.day, course.startTime);
    final reminderDateTime =
        courseDateTime.subtract(const Duration(minutes: 15));
    if (reminderDateTime.isBefore(DateTime.now())) {
      return DateTime.now().add(const Duration(seconds: 10));
    }
    return reminderDateTime;
  }

  // Widget constructeur pour centraliser la logique des cartes de notifications de la maquette
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Bandelette de couleur latérale gauche (w-1.5 de ta maquette)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 6,
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
          ),
          // Contenu principal de la notification
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                iconWidget,
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tagText,
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: tagColor,
                            ),
                          ),
                          Text(
                            timeText,
                            style: const TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 12,
                              color: onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        bodyText,
                        style: const TextStyle(
                          fontFamily: 'Public Sans',
                          fontSize: 15,
                          height: 1.4,
                          color: primaryColor,
                        ),
                      ),
                      if (actionWidget != null) actionWidget,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
