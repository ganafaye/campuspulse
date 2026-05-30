import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/user_model.dart';

class LocalStorageService {
  static const String _boxName = 'campus_pulse_box';
  static late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  static UserModel? getPersistedUser() {
    final raw = _box.get('persisted_user');
    if (raw is Map) {
      try {
        return UserModel.fromMap(Map<String, dynamic>.from(raw));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static Future<void> saveUser(UserModel user) async {
    await _box.put('persisted_user', user.toMap());
  }

  static Future<void> clearUser() async {
    await _box.delete('persisted_user');
  }

  static Future<void> saveCachedCourses(
      String studentUid, List<Map<String, dynamic>> courses) async {
    final safeCourses = courses
        .map((course) => Map<String, dynamic>.from(course))
        .toList(growable: false);
    await _box.put('cached_courses_$studentUid', safeCourses);
  }

  static List<Map<String, dynamic>> getCachedCourses(String studentUid) {
    final raw = _box.get('cached_courses_$studentUid');
    if (raw is List) {
      return raw
          .cast<Map>()
          .map((entry) => Map<String, dynamic>.from(entry))
          .toList(growable: false);
    }
    return <Map<String, dynamic>>[];
  }

  static bool hasCachedCourses(String studentUid) {
    final raw = _box.get('cached_courses_$studentUid');
    return raw is List && raw.isNotEmpty;
  }

  static Future<void> saveCachedAlerts(
      String studentUid, List<Map<String, dynamic>> alerts) async {
    final safeAlerts = alerts
        .map((alert) => Map<String, dynamic>.from(alert))
        .toList(growable: false);
    await _box.put('cached_alerts_$studentUid', safeAlerts);
  }

  static List<Map<String, dynamic>> getCachedAlerts(String studentUid) {
    final raw = _box.get('cached_alerts_$studentUid');
    if (raw is List) {
      return raw
          .cast<Map>()
          .map((entry) => Map<String, dynamic>.from(entry))
          .toList(growable: false);
    }
    return <Map<String, dynamic>>[];
  }

  static Future<void> clearCachedData(String studentUid) async {
    await _box.delete('cached_courses_$studentUid');
    await _box.delete('cached_alerts_$studentUid');
  }
}
