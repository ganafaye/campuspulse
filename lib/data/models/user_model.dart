class UserModel {
  final String uid;
  final String name;
  final String email;
  final String codeEtudiant; // Code permanent de l'étudiant
  final String ufr; // Ex: UFR SAT, UFR Sante...
  final String niveau; // Ex: L1, L2, L3MAGE

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.codeEtudiant,
    required this.ufr,
    required this.niveau,
  });
}