class CourseModel {
  final String id;
  final String titre;
  final String professeur;
  final String classe;
  final DateTime debutTime;
  final DateTime finTime;
  final String ufr;
  final String niveau;

  CourseModel({
    required this.id,
    required this.titre,
    required this.professeur,
    required this.classe,
    required this.debutTime,
    required this.finTime,
    required this.ufr,
    required this.niveau,
  });
}