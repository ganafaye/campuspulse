// lib/data/mock_data.dart

import 'user_model.dart'; // Import local du modèle d'utilisateur

// ==========================================
// 1. LISTE DES 4 UTILISATEURS DE TEST
// ==========================================
final List<UserModel> mockUsers = [
  UserModel(
    uid: "uadb_student_gana_2026",
    name: "Gana FAYE",
    email: "gana.faye@uadb.edu.sn",
    codeEtudiant: "GANA.FAYE",
    ufr: "UFR SAT",
    niveau: "Master 1 IS",
  ),
  UserModel(
    uid: "uadb_student_aimee_2026",
    name: "Aimée DIEDHIOU",
    email: "aimee.diedhiou@uadb.edu.sn",
    codeEtudiant: "AIMEE.DIEDHIOU",
    ufr: "UFR SEG",
    niveau: "Licence 3 Gestion",
  ),
  UserModel(
    uid: "uadb_student_moussa_2026",
    name: "Moussa DIOP",
    email: "moussa.diop@uadb.edu.sn",
    codeEtudiant: "MOUSSA.DIOP",
    ufr: "UFR Sante",
    niveau: "Licence 2 Médecine",
  ),
  UserModel(
    uid: "uadb_student_fatou_2026",
    name: "Fatou SOW",
    email: "fatou.sow@uadb.edu.sn",
    codeEtudiant: "FATOU.SOW",
    ufr: "UFR CRAC",
    niveau: "Master 2 Communication",
  ),
];

// ==========================================
// 2. MODÈLE ET DONNÉES DE L'EMPLOI DU TEMPS
// ==========================================
class CourseModel {
  final String studentUid; // 🌟 Le lien magique : associé à l'UID de l'étudiant
  final String title;
  final String room;
  final String teacher;
  final String day;
  final String startTime;
  final String endTime;

  CourseModel({
    required this.studentUid,
    required this.title,
    required this.room,
    required this.teacher,
    required this.day,
    required this.startTime,
    required this.endTime,
  });
}

// EMPLOIS DU TEMPS PERSONNALISÉS
final List<CourseModel> mockSchedule = [
  // 💻 COURS DE GANA FAYE (Master 1 IS - UFR SAT)
  CourseModel(
    studentUid: "uadb_student_gana_2026",
    title: "Architecture DevOps & IaC",
    room: "Salle B1 - SATIC",
    teacher: "Dr. Babou",
    day: "Lundi",
    startTime: "08:00",
    endTime: "12:00",
  ),
  CourseModel(
    studentUid: "uadb_student_gana_2026",
    title: "Développement Mobile Flutter",
    room: "Laboratoire Info",
    teacher: "M. Diop",
    day: "Mardi",
    startTime: "14:30",
    endTime: "17:30",
  ),
  CourseModel(
    studentUid: "uadb_student_gana_2026",
    title: "Data Science & Machine Learning",
    room: "Amphi SAT",
    teacher: "Dr. Diallo",
    day: "Mercredi",
    startTime: "09:00",
    endTime: "13:00",
  ),
  CourseModel(
    studentUid: "uadb_student_gana_2026",
    title: "Sécurité des SI & OSINT",
    room: "Salle B1 - SATIC",
    teacher: "M. Ndiaye",
    day: "Jeudi",
    startTime: "10:30",
    endTime: "12:30",
  ),

  // 📈 COURS DE AIMÉE DIEDHIOU (Licence 3 Gestion - UFR SEG)
  CourseModel(
    studentUid: "uadb_student_aimee_2026",
    title: "Gestion de la Logistique",
    room: "Salle C2",
    teacher: "Mme. Ba",
    day: "Lundi",
    startTime: "10:00",
    endTime: "13:00",
  ),
  CourseModel(
    studentUid: "uadb_student_aimee_2026",
    title: "Comptabilité Analytique",
    room: "Amphi SEG",
    teacher: "M. Sané",
    day: "Mardi",
    startTime: "08:00",
    endTime: "11:00",
  ),
  CourseModel(
    studentUid: "uadb_student_aimee_2026",
    title: "Marketing Opérationnel",
    room: "Salle C4",
    teacher: "Dr. Sy",
    day: "Jeudi",
    startTime: "15:00",
    endTime: "18:00",
  ),

  // 🩺 COURS DE MOUSSA DIOP (Licence 2 Médecine - UFR Santé)
  CourseModel(
    studentUid: "uadb_student_moussa_2026",
    title: "Anatomie Humaine",
    room: "Laboratoire d'Anatomie",
    teacher: "Prof. Kane",
    day: "Lundi",
    startTime: "08:00",
    endTime: "11:00",
  ),
  CourseModel(
    studentUid: "uadb_student_moussa_2026",
    title: "Physiologie Générale",
    room: "Amphi Santé",
    teacher: "Dr. Faye",
    day: "Mercredi",
    startTime: "14:00",
    endTime: "17:00",
  ),
  CourseModel(
    studentUid: "uadb_student_moussa_2026",
    title: "Biochimie Clinique",
    room: "Salle S1",
    teacher: "Mme. Cissé",
    day: "Vendredi",
    startTime: "09:00",
    endTime: "12:00",
  ),

  // 📢 COURS DE FATOU SOW (Master 2 Communication - UFR CRAC)
  CourseModel(
    studentUid: "uadb_student_fatou_2026",
    title: "Stratégie Digitale & Réseaux Sociaux",
    room: "Studio CRAC",
    teacher: "M. Thiam",
    day: "Mardi",
    startTime: "09:00",
    endTime: "13:00",
  ),
  CourseModel(
    studentUid: "uadb_student_fatou_2026",
    title: "Communication de Crise",
    room: "Salle R2",
    teacher: "Dr. Ndiaye",
    day: "Jeudi",
    startTime: "14:00",
    endTime: "17:00",
  ),
];

// ==========================================
// 3. MODÈLE ET DONNÉES DES ALERTES
// ==========================================
class CampusAlertModel {
  final String id;
  final String studentUid;
  final String title;
  final String subtitle;
  final String category;
  final DateTime timestamp;

  CampusAlertModel({
    required this.id,
    required this.studentUid,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.timestamp,
  });
}

final List<CampusAlertModel> mockAlerts = [
  CampusAlertModel(
    id: "alert_1",
    studentUid: "uadb_student_gana_2026",
    title: "Changement de salle",
    subtitle:
        "Le cours Architecture DevOps & IaC de 10h30 est déplacé à l'Amphi A.",
    category: "URGENT",
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  CampusAlertModel(
    id: "alert_2",
    studentUid: "uadb_student_aimee_2026",
    title: "Cours annulé",
    subtitle:
        "Le cours Marketing Opérationnel de 15h00 est annulé aujourd'hui.",
    category: "ANNULÉ",
    timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
  ),
  CampusAlertModel(
    id: "alert_3",
    studentUid: "uadb_student_fatou_2026",
    title: "Changement de salle",
    subtitle:
        "Le cours Communication de Crise de 14h00 se tiendra désormais en salle R3.",
    category: "URGENT",
    timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 10)),
  ),
  CampusAlertModel(
    id: "alert_4",
    studentUid: "all",
    title: "Maintenance serveurs UADB",
    subtitle:
        "La plateforme pédagogique sera inaccessible ce samedi de 22h à 04h.",
    category: "INFO",
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
