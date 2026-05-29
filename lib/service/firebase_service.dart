// lib/service/firebase_service.dart

import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  // Référence officielle vers la racine de ta Realtime Database
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// 1. TENTATIVE DE CONNEXION ÉTUDIANT
  /// Saisir le code étudiant (ex: GANA.FAYE) et vérifier s'il existe dans le nœud /users
  Future<Map<String, dynamic>?> loginStudent(String codeEtudiantSaisi) async {
    try {
      // On cherche dans le nœud "users"
      final DataSnapshot snapshot = await _dbRef.child('users').get();

      if (snapshot.exists && snapshot.value != null) {
        final Map<dynamic, dynamic> usersData =
            snapshot.value as Map<dynamic, dynamic>;

        // On parcourt les utilisateurs pour trouver celui qui a le bon codeEtudiant
        for (var entry in usersData.entries) {
          final userMap = Map<String, dynamic>.from(entry.value as Map);
          // Injecte l'UID (clé Firebase) dans la map pour faciliter la construction du modèle
          userMap['uid'] = entry.key;

          // Comparaison en majuscules pour éviter les erreurs de saisie
          final codeInDb =
              (userMap['codeEtudiant'] ?? userMap['code'] ?? '').toString();
          if (codeInDb.trim().toUpperCase() ==
              codeEtudiantSaisi.trim().toUpperCase()) {
            print("🚀 ÉTUDIANT TROUVÉ : ${userMap['name']}");
            return userMap; // Renvoie les infos de l'étudiant (avec uid)
          }
        }
      }
      print("⚠️ Aucun étudiant trouvé avec le code : $codeEtudiantSaisi");
      return null;
    } catch (e) {
      print("❌ Erreur FirebaseService (loginStudent) : $e");
      return null;
    }
  }

  /// 2. RÉCUPÉRATION DES COURS (TEMPS RÉEL OU FLUX)
  /// Permet d'écouter le nœud /courses
  DatabaseReference getCoursesRef() {
    return _dbRef.child('courses');
  }

  /// 3. RÉCUPÉRATION DES ALERTES (TEMPS RÉEL)
  /// Permet d'écouter le nœud /alerts
  DatabaseReference getAlertsRef() {
    return _dbRef.child('alerts');
  }

  /// 4. ÉCOUTER LES CHANGEMENTS DE COURS EN TEMPS RÉEL
  /// Retourne un stream des changements pour un utilisateur spécifique
  Stream<List<Map<String, dynamic>>> watchUserCourses(String studentUid) {
    return getCoursesRef().onValue.map((event) {
      final List<Map<String, dynamic>> courses = [];
      if (event.snapshot.exists && event.snapshot.value != null) {
        final Map<dynamic, dynamic> coursesData =
            event.snapshot.value as Map<dynamic, dynamic>;

        for (var entry in coursesData.entries) {
          final courseMap = Map<String, dynamic>.from(entry.value as Map);
          courseMap['id'] = entry.key;
          courseMap['studentUid'] = courseMap['studentUid'] ?? studentUid;

          // Filtrer les cours de l'utilisateur
          if (courseMap['studentUid'] == studentUid ||
              courseMap['students'] is List &&
                  (courseMap['students'] as List).contains(studentUid)) {
            courses.add(courseMap);
          }
        }
      }
      return courses;
    });
  }

  /// 5. ÉCOUTER LES ALERTES EN TEMPS RÉEL
  /// Retourne un stream des alertes pour un utilisateur spécifique
  Stream<List<Map<String, dynamic>>> watchUserAlerts(String studentUid) {
    return getAlertsRef().onValue.map((event) {
      final List<Map<String, dynamic>> alerts = [];
      if (event.snapshot.exists && event.snapshot.value != null) {
        final Map<dynamic, dynamic> alertsData =
            event.snapshot.value as Map<dynamic, dynamic>;

        for (var entry in alertsData.entries) {
          final alertMap = Map<String, dynamic>.from(entry.value as Map);
          alertMap['id'] = entry.key;

          // Filtrer les alertes pour cet utilisateur ou alertes globales
          final studentUidInAlert =
              alertMap['studentUid'] ?? alertMap['student_uid'];
          if (studentUidInAlert == studentUid || studentUidInAlert == 'all') {
            alerts.add(alertMap);
          }
        }
      }
      return alerts;
    });
  }
}
