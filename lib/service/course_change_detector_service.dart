// lib/service/course_change_detector_service.dart

import 'package:campuspulse/data/models/alert_model.dart'; // Importation de ton vrai AlertModel
import 'notification_service.dart';

/// Modèle pour représenter un changement détecté
class CourseChange {
  final String courseId;
  final String title;
  final String changeType; // 'ANNULÉ', 'SALLE_CHANGÉE', 'HEURE_CHANGÉE', 'PROFESSEUR_CHANGÉ', 'AUTRE'
  final String oldValue;
  final String newValue;
  final DateTime timestamp;

  CourseChange({
    required this.courseId,
    required this.title,
    required this.changeType,
    required this.oldValue,
    required this.newValue,
    required this.timestamp,
  });

  /// Génère une description lisible du changement
  String getDescription() {
    switch (changeType) {
      case 'ANNULÉ':
        return '❌ COURS ANNULÉ : $title';
      case 'SALLE_CHANGÉE':
        return '📍 CHANGEMENT DE SALLE : $title\n$oldValue → $newValue';
      case 'HEURE_CHANGÉE':
        return '⏰ CHANGEMENT D\'HEURE : $title\n$oldValue → $newValue';
      case 'PROFESSEUR_CHANGÉ':
        return '👨‍🏫 CHANGEMENT DE PROFESSEUR : $title\n$oldValue → $newValue';
      default:
        return '📢 MISE À JOUR : $title\n$oldValue → $newValue';
    }
  }

  /// Génère une alerte officielle basée sur le changement
  AlertModel toAlert(String studentUid) {
    return AlertModel(
      id: 'change_${courseId}_${timestamp.millisecondsSinceEpoch}',
      type: AlertType.urgent, 
      tag: changeType,        
      message: getDescription(),
      timestamp: timestamp,
      actionLabel: null,
      onAction: null,
    );
  }
}

/// Service pour détecter les changements de cours
class CourseChangeDetectorService {
  static final CourseChangeDetectorService _instance =
      CourseChangeDetectorService._internal();

  factory CourseChangeDetectorService() {
    return _instance;
  }

  CourseChangeDetectorService._internal();

  /// Cache pour comparer les états précédents
  final Map<String, Map<String, dynamic>> _courseCache = {};

  /// Détecte les changements entre l'état précédent et le nouvel état
  Future<List<CourseChange>> detectChanges(
    List<Map<String, dynamic>> newCourses,
    String studentUid,
  ) async {
    final List<CourseChange> changes = [];

    // 1. Vérifier les cours supprimés/annulés
    for (var cachedCourseId in _courseCache.keys.toList()) {
      final cachedCourse = _courseCache[cachedCourseId];
      final exists =
          newCourses.any((c) => (c['id'] ?? c['title']).toString() == cachedCourseId);

      if (!exists && cachedCourse != null) {
        final courseTitle = cachedCourse['title'] ?? cachedCourse['titre'] ?? 'Cours';
        
        final change = CourseChange(
          courseId: cachedCourseId,
          title: courseTitle,
          changeType: 'ANNULÉ',
          oldValue: 'Programmé',
          newValue: 'Annulé',
          timestamp: DateTime.now(),
        );
        changes.add(change);

        // Notification push locale immédiate
        await NotificationService.showImmediateNotification(
          id: cachedCourseId.hashCode, 
          title: '❌ COURS ANNULÉ',
          body: 'Le cours "$courseTitle" a été annulé.',
        );

        _courseCache.remove(cachedCourseId);
      }
    }

    // 2. Vérifier les changements de propriétés
    for (var newCourse in newCourses) {
      final courseId = (newCourse['id'] ?? newCourse['title']).toString();
      final cachedCourse = _courseCache[courseId];
      final courseTitle = newCourse['title'] ?? newCourse['titre'] ?? 'Cours';

      if (cachedCourse != null) {
        // Comparer la salle
        final oldRoom = cachedCourse['room'] ?? cachedCourse['classe'] ?? cachedCourse['salle'];
        final newRoom = newCourse['room'] ?? newCourse['classe'] ?? newCourse['salle'];

        if (oldRoom != newRoom && newRoom != null && oldRoom != null) {
          changes.add(CourseChange(
            courseId: courseId,
            title: courseTitle,
            changeType: 'SALLE_CHANGÉE',
            oldValue: oldRoom.toString(),
            newValue: newRoom.toString(),
            timestamp: DateTime.now(),
          ));

          // CORRIGÉ : Ajout des accolades {} autour de courseId
          await NotificationService.showImmediateNotification(
            id: '${courseId}_room'.hashCode,
            title: '📍 CHANGEMENT DE SALLE',
            body: 'Le cours "$courseTitle" a été déplacé:\n$oldRoom → $newRoom',
          );
        }

        // Comparer l'heure de début
        final oldStartTime = cachedCourse['startTime'] ?? cachedCourse['debut'];
        final newStartTime = newCourse['startTime'] ?? newCourse['debut'];

        if (oldStartTime != newStartTime && newStartTime != null && oldStartTime != null) {
          changes.add(CourseChange(
            courseId: courseId,
            title: courseTitle,
            changeType: 'HEURE_CHANGÉE',
            oldValue: oldStartTime.toString(),
            newValue: newStartTime.toString(),
            timestamp: DateTime.now(),
          ));

          // CORRIGÉ : Ajout des accolades {} autour de courseId
          await NotificationService.showImmediateNotification(
            id: '${courseId}_time'.hashCode,
            title: '⏰ CHANGEMENT D\'HEURE',
            body: 'Le cours "$courseTitle" a changé d\'heure:\n$oldStartTime → $newStartTime',
          );
        }

        // Comparer le professeur
        final oldTeacher = cachedCourse['teacher'] ?? cachedCourse['professeur'];
        final newTeacher = newCourse['teacher'] ?? newCourse['professeur'];

        if (oldTeacher != newTeacher && newTeacher != null && oldTeacher != null) {
          changes.add(CourseChange(
            courseId: courseId,
            title: courseTitle,
            changeType: 'PROFESSEUR_CHANGÉ',
            oldValue: oldTeacher.toString(),
            newValue: newTeacher.toString(),
            timestamp: DateTime.now(),
          ));

          // CORRIGÉ : Ajout des accolades {} autour de courseId
          await NotificationService.showImmediateNotification(
            id: '${courseId}_prof'.hashCode,
            title: '👨‍🏫 CHANGEMENT DE PROFESSEUR',
            body: 'Le cours "$courseTitle" aura un nouveau professeur:\n$oldTeacher → $newTeacher',
          );
        }
      }

      // Mettre à jour le cache avec le nouvel état
      _courseCache[courseId] = newCourse;
    }

    return changes;
  }

  /// Initialise le cache avec les cours actuels
  void initializeCache(List<Map<String, dynamic>> courses) {
    _courseCache.clear();
    for (var course in courses) {
      final courseId = (course['id'] ?? course['title']).toString();
      _courseCache[courseId] = course;
    }
  }

  /// Réinitialise complètement le cache
  void clearCache() {
    _courseCache.clear();
  }
}