class CourseModel {
  final String? studentUid;
  final String id;
  final String titre;
  final String professeur;
  final String classe;
  final DateTime debutTime;
  final DateTime finTime;
  final String ufr;
  final String niveau;

  CourseModel({
    this.studentUid,
    required this.id,
    required this.titre,
    required this.professeur,
    required this.classe,
    required this.debutTime,
    required this.finTime,
    required this.ufr,
    required this.niveau,
  });

  factory CourseModel.fromMap(Map<dynamic, dynamic> map, {String? id}) {
    final m = Map<String, dynamic>.from(map);

    DateTime parseTime(dynamic v) {
      if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      if (v is String) {
        // Essayez parsing ISO-8601 sinon heure simple
        try {
          return DateTime.parse(v);
        } catch (_) {
          return DateTime.fromMillisecondsSinceEpoch(0);
        }
      }
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    return CourseModel(
      studentUid: m['studentUid'] ??
          m['student_uid'] ??
          m['student'] ??
          m['studentId'] ??
          m['studentId'],
      id: id ?? m['id'] ?? m['courseId'] ?? '',
      titre: m['titre'] ?? m['title'] ?? m['name'] ?? '',
      professeur: m['professeur'] ?? m['teacher'] ?? m['enseignant'] ?? '',
      classe: m['classe'] ?? m['room'] ?? m['salle'] ?? '',
      debutTime: parseTime(
          m['debutTime'] ?? m['startTime'] ?? m['debut'] ?? m['start']),
      finTime: parseTime(m['finTime'] ?? m['endTime'] ?? m['fin'] ?? m['end']),
      ufr: m['ufr'] ?? m['department'] ?? '',
      niveau: m['niveau'] ?? m['level'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentUid': studentUid,
      'id': id,
      'titre': titre,
      'professeur': professeur,
      'classe': classe,
      'debutTime': debutTime.toIso8601String(),
      'finTime': finTime.toIso8601String(),
      'ufr': ufr,
      'niveau': niveau,
    };
  }
}
