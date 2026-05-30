// lib/presentation/screens/guest_home_screen.dart

import 'package:campuspulse/presentation/widgets/connectivity_status_banner.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  // L'index de l'onglet actif (0 par défaut pour 'Accueil')
  int _currentIndex = 0;

  // Palette de couleur extraite de la configuration Figma/Tailwind
  static const Color primaryColor = Color(0xFF00113A); // Bleu Sombre Principal
  static const Color primaryContainer = Color(0xFF002366); // Bleu Royal dégradé
  static const Color secondaryColor = Color(0xFF115CB9); // Bleu Éclatant
  static const Color secondaryContainer =
      Color(0xFF659DFE); // Bleu Clair boutons/badges
  static const Color onSecondaryContainer = Color(0xFF003370);
  static const Color backgroundColor = Color(0xFFF8F9FB); // Fond clair
  static const Color outlineVariant = Color(0xFFC5C6D2); // Bordures légères

  // Données stables pour la Vie du Campus
  final List<Map<String, String>> campusLife = [
    {
      'category': 'ÉVÉNEMENT',
      'title': 'Conférence Cybersécurité & OSINT',
      'subtitle': 'Demain à 14h30 • Amphi 2',
      'imageUrl':
          'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?q=80&w=600&auto=format&fit=crop',
    },
    {
      'category': 'SPORT',
      'title': 'Tournoi de Football Inter-UFR',
      'subtitle': 'Samedi 25 Mai • Complexe Sportif',
      'imageUrl':
          'https://images.unsplash.com/photo-1544698310-74ea9d1c8258?q=80&w=600&auto=format&fit=crop',
    },
    {
      'category': 'ADMINISTRATION',
      'title': 'Inscriptions Candidature Master',
      'subtitle': 'Clôture le 30 Mai • Portails SATIC',
      'imageUrl':
          'https://images.unsplash.com/photo-1531403009284-440f080d1e12?q=80&w=600&auto=format&fit=crop',
    },
  ];

  // Fonction pour intercepter la navigation de la BottomNavigationBar
  void _onTabTapped(int index) {
    if (index == 0) {
      setState(() {
        _currentIndex = index;
      });
    } else {
      // Si le visiteur clique sur Emploi (1), Alertes (2) ou Profil (3)
      _showLoginRequiredDialog();
    }
  }

  // Boîte de dialogue incitant à la connexion
  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.lock_outline, color: primaryColor),
              SizedBox(width: 10),
              Text(
                'Connexion requise',
                style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
            ],
          ),
          content: const Text(
            'Cette fonctionnalité est réservée aux étudiants inscrits à l\'UADB. Veuillez vous connecter pour y accéder.',
            style: TextStyle(fontFamily: 'Public Sans', fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler',
                  style: TextStyle(
                      fontFamily: 'Public Sans',
                      color: Colors.grey,
                      fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Se connecter',
                  style: TextStyle(
                      fontFamily: 'Public Sans', fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // 1. TopAppBar (Header)
      appBar: AppBar(
        backgroundColor: primaryContainer,
        elevation: 1,
        title: const Row(
          children: [
            Icon(Icons.school, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'CampusPulse',
              style: TextStyle(
                fontFamily: 'Public Sans',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ConnectivityStatusBanner(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Mobile Section
                    const Text(
                      'Bienvenue à l\'UADB',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const Text(
                      'Portail Visiteur',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 2. Widget Hero: Connexion incitative
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [primaryColor, primaryContainer],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Connectez-vous pour voir votre emploi du temps',
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Accédez à vos cours, vos notes et vos services administratifs en un clic.',
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: secondaryContainer,
                                foregroundColor: onSecondaryContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Se connecter',
                                style: TextStyle(
                                  fontFamily: 'Public Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Shortcuts Grid avec détection d'appui sur les éléments verrouillés
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 12,
                      children: [
                        GestureDetector(
                          onTap: _showLoginRequiredDialog,
                          child: _buildShortcutItem(
                              Icons.calendar_month, 'Mon Agenda',
                              isLocked: true),
                        ),
                        InkWell(
                          onTap: () {
                            // Action pour ouvrir le site web extérieur si désiré
                          },
                          child: _buildShortcutItem(
                            Icons.language,
                            'Site Web',
                            isLocked: false,
                            secondaryContainer: secondaryContainer,
                            onSecondaryContainer: onSecondaryContainer,
                          ),
                        ),
                        GestureDetector(
                          onTap: _showLoginRequiredDialog,
                          child: _buildShortcutItem(Icons.grade, 'Notes',
                              isLocked: true),
                        ),
                        GestureDetector(
                          onTap: _showLoginRequiredDialog,
                          child: _buildShortcutItem(
                              Icons.contact_phone, 'Contacts UFR',
                              isLocked: true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // 4. Section Vie du Campus
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Vie du Campus',
                          style: TextStyle(
                            fontFamily: 'Public Sans',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Tout voir',
                            style: TextStyle(
                              fontFamily: 'Public Sans',
                              fontWeight: FontWeight.bold,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: campusLife.length,
                      itemBuilder: (context, index) {
                        final item = campusLife[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: outlineVariant),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 160,
                                  width: double.infinity,
                                  child: Image.network(
                                    item['imageUrl']!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: const Color(0xFFE0E3E5),
                                        child: const Icon(Icons.broken_image,
                                            color: Colors.grey, size: 40),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['category']!,
                                        style: TextStyle(
                                          fontFamily: 'Public Sans',
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: item['category'] ==
                                                  'ADMINISTRATION'
                                              ? const Color(0xFFBA1A1A)
                                              : secondaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item['title']!,
                                        style: const TextStyle(
                                          fontFamily: 'Public Sans',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['subtitle']!,
                                        style: const TextStyle(
                                          fontFamily: 'Public Sans',
                                          fontSize: 13,
                                          color: Color(0xFF444650),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // 5. Section Ressources Utiles
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Ressources Utiles',
                              style: TextStyle(
                                fontFamily: 'Public Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          const Divider(height: 1, color: outlineVariant),
                          _buildResourceRow(
                              Icons.description, 'Règlement Intérieur'),
                          const Divider(height: 1, color: outlineVariant),
                          _buildResourceRow(
                              Icons.calendar_today, 'Calendrier Académique'),
                          const Divider(height: 1, color: outlineVariant),
                          _buildResourceRow(
                              Icons.menu_book, 'Guide de l\'Étudiant'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped, // Déclenche la vérification au clic
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: secondaryColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
            fontFamily: 'Public Sans',
            fontSize: 11,
            fontWeight: FontWeight.bold),
        unselectedLabelStyle:
            const TextStyle(fontFamily: 'Public Sans', fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Emploi'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Alertes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  // Helper pour générer un bouton de raccourci avec ou sans cadenas
  Widget _buildShortcutItem(IconData icon, String label,
      {required bool isLocked,
      Color? secondaryContainer,
      Color? onSecondaryContainer}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: isLocked ? Colors.white : secondaryContainer,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC5C6D2)),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1))
                ],
              ),
              child: Icon(icon,
                  color:
                      isLocked ? const Color(0xFF00113A) : onSecondaryContainer,
                  size: 26),
            ),
            if (isLocked)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.lock, color: Colors.red, size: 14),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontFamily: 'Public Sans',
              fontSize: 11,
              fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  // Helper pour fabriquer les lignes de ressources
  Widget _buildResourceRow(IconData icon, String title) {
    return InkWell(
      onTap: () {
        // Logique d'ouverture de fichier ou téléchargement
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF002366).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.description,
                  color: Color(0xFF00113A), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
