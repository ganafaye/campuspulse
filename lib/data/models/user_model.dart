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

  factory UserModel.fromMap(Map<dynamic, dynamic> map, {String? id}) {
    // Supporte différentes conventions de clés venant de Firebase
    final m = Map<String, dynamic>.from(map);
    return UserModel(
      uid: id ?? m['uid'] ?? m['id'] ?? '',
      name: m['name'] ?? m['fullName'] ?? m['nom'] ?? '',
      email: m['email'] ?? m['mail'] ?? '',
      codeEtudiant: m['codeEtudiant'] ?? m['code_etudiant'] ?? m['code'] ?? '',
      ufr: m['ufr'] ?? m['department'] ?? m['faculte'] ?? '',
      niveau: m['niveau'] ?? m['level'] ?? m['classe'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'codeEtudiant': codeEtudiant,
      'ufr': ufr,
      'niveau': niveau,
    };
  }
}
