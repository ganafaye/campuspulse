// lib/presentation/providers/course_change_provider.dart

import 'package:campuspulse/data/models/mock_data.dart';
import 'package:campuspulse/service/course_change_detector_service.dart';
import 'package:campuspulse/service/firebase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modèle pour retourner les changements et les cours
class CourseChangesData {
  final List<CourseChange> changes;
  final List<Map<String, dynamic>> courses;

  CourseChangesData({required this.changes, required this.courses});
}

/// Provider pour surveiller les changements de cours en temps réel
final courseChangeProvider =
    StreamProvider.family<CourseChangesData, String>((ref, studentUid) {
  final firebaseService = FirebaseService();
  final changeDetector = CourseChangeDetectorService();

  return firebaseService
      .watchUserCourses(studentUid)
      .asyncMap((newCourses) async {
    final changes = await changeDetector.detectChanges(newCourses, studentUid);
    return CourseChangesData(changes: changes, courses: newCourses);
  });
});

/// Provider pour obtenir les alertes urgentes liées aux changements
/// (Prêt pour utilisation future avec des écouteurs de changements en temps réel)

/// Provider pour obtenir les cours Firebase en temps réel
final firebaseCoursesProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>(
        (ref, studentUid) {
  final firebaseService = FirebaseService();
  return firebaseService.watchUserCourses(studentUid);
});

/// Provider pour obtenir les alertes Firebase en temps réel
final firebaseAlertsProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>(
        (ref, studentUid) {
  final firebaseService = FirebaseService();
  return firebaseService.watchUserAlerts(studentUid);
});
