// lib/presentation/screens/student_home_screen.dart

import 'package:flutter/material.dart';
import 'schedule_screen.dart';
import 'alerts_screen.dart';
import 'profile_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _currentIndex = 0;

  static const Color primaryColor = Color(0xFF00113A);
  static const Color primaryContainer = Color(0xFF002366);
  static const Color secondaryColor = Color(0xFF115CB9);
  static const Color secondaryContainer = Color(0xFF659DFE);
  static const Color onSecondaryContainer = Color(0xFF003370);
  static const Color backgroundColor = Color(0xFFF8F9FB);
  static const Color outlineVariant = Color(0xFFC5C6D2);
  static const Color onSurfaceVariant = Color(0xFF444650);

  final List<Map<String, String>> campusLife = [
    {
      'category': 'ÉVÉNEMENT',
      'title': 'Conférence Cybersécurité & OSINT',
      'subtitle': 'Demain à 14h30 • Amphi 2',
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCZihzYTTUmTHP3uWXTG6CuGchqBmWrS086SV2JiPYG_kwj6FhQ6WMH4CbIFAbiD84oGf8bsuyIHq0ec3EfldpMfO3Qn8PJTgScJx6vWTLcy3elprkopdpVT79GkgvfpBnMigBLG6b7wMjWrmujdOB67h_4L5V7I-h0B-3MNGqz3qmKNQ6l5XFHPe9TjlVasVyWh19DHr4YOSW83m8FEfKcZbHljfvcNPghKMdjNxRFzcjUWRN1Qj_7vg18qQFezGT0EuRX3peOI8A',
    },
    {
      'category': 'SPORT',
      'title': 'Tournoi de Football Inter-UFR',
      'subtitle': 'Samedi 25 Mai • Complexe Sportif',
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAy3V8Cd5-rvk9lGGQ2cuKQseHIJVjm7ZPTY5XS3KZbSfB9OTtYJtUlrVhX9yXPoWAaD-UNZFHnxAc4CyA9Ete5UuDIiMNS9ggQrnM0_qF8bZixezCQTVAydTv6_JiBdexIetzB5lwUjDh5Dd1TR6MOpcDmqufzL1NaT9sABGHOWylk8L048mE4dEwo5mDhMQenDzv3CuksH5t6gEel5A7BwEO7M1rvHs0RWmHwyF2Oz9YmdKNCHVmE_MJ7HPVgs7R_6RL5-lhSFcQ',
    },
    {
      'category': 'ADMINISTRATION',
      'title': 'Inscriptions Candidature Master',
      'subtitle': 'Clôture le 30 Mai • Portails SATIC',
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAN_0xxhixC9zOwghPV8t3NOhhqDqXlgSS-_j2dT1D92oVDcg4ansEwoVJvQyi7b4P8jeP77OqONRQW1HkbLfFFK3rnVYMKNRr1BkFZC5BnjRo7oAvoNX9p8qfvXrIvDaG-JkvNLyoUs2RU8QrqIEgSIMVuBO5TTTpNYRBRyfTlZlDcquxtLg8eU--eezyHzS_SrX96DsmdWTrX8ze2NzIM7aJNBoGYY_cWQX8uoRJJLMRckDp_sIu6p9uHSqNHzbc1EtELRrDyZxk',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Liste des écrans gérés par l'IndexedStack
    final List<Widget> _interfaces = [
      _buildHomeContent(), // Index 0 : Accueil
      const ScheduleScreen(), // Index 1 : Emploi du temps
      const AlertsScreen(),
      const ProfileScreen(), // Index 3 : TON ÉCRAN PROFIL ENTIÈREMENT INTÉGRÉ
      const Center(
        child: Text(
          'Alertes & Notifications',
          style: TextStyle(
            fontFamily: 'Public Sans',
            fontSize: 18,
            color: primaryColor,
          ),
        ),
      ), // Index 2
      const Center(
        child: Text(
          'Mon Profil',
          style: TextStyle(
            fontFamily: 'Public Sans',
            fontSize: 18,
            color: primaryColor,
          ),
        ),
      ), // Index 3
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
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
            onPressed: () {
              setState(() {
                _currentIndex = 2; // Redirige vers l'onglet Alertes
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      // CORRECTION: Remplacement de l'accès direct par un IndexedStack pour figer l'état des écrans
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _interfaces,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor:
            secondaryColor, // Rendu visuel plus harmonieux avec la charte
        unselectedItemColor: onSurfaceVariant,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Public Sans',
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Public Sans',
          fontSize: 11,
        ),
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

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bonjour, Alioune',
            style: TextStyle(
              fontFamily: 'Public Sans',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const Text(
            '20 Mai 2024 • UADB Campus',
            style: TextStyle(
              fontFamily: 'Public Sans',
              fontSize: 14,
              color: onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),

          // Widget: Prochain Cours (Bouton "Voir les détails" configuré pour rediriger vers l'emploi du temps)
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
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: secondaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text(
                    'PROCHAIN COURS',
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: onSecondaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Développement Mobile',
                  style: TextStyle(
                    fontFamily: 'Public Sans',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.white70, size: 18),
                    SizedBox(width: 6),
                    Text(
                      '08h00 - 10h00',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.location_on, color: Colors.white70, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Salle B1 - SATIC',
                      style: TextStyle(
                        fontFamily: 'Public Sans',
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex =
                          1; // Redirige vers l'onglet Emploi du temps
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Voir les détails',
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Raccourcis (Grid)
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 1; // Redirige vers l'emploi du temps
                  });
                },
                child: _buildShortcutItem(Icons.calendar_month, 'Mon Agenda'),
              ),
              _buildShortcutItem(Icons.language, 'Site Web'),
              _buildShortcutItem(Icons.grade, 'Notes'),
              _buildShortcutItem(Icons.contact_phone, 'Contacts UFR'),
            ],
          ),
          const SizedBox(height: 16),

          // Section Vie du Campus
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
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['category']!,
                              style: TextStyle(
                                fontFamily: 'Public Sans',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: item['category'] == 'ADMINISTRATION'
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
                                color: onSurfaceVariant,
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

          // Ressources Utiles
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
                _buildResourceRow(Icons.description, 'Règlement Intérieur'),
                const Divider(height: 1, color: outlineVariant),
                _buildResourceRow(
                    Icons.calendar_today, 'Calendrier Académique'),
                const Divider(height: 1, color: outlineVariant),
                _buildResourceRow(Icons.menu_book, 'Guide de l\'Étudiant'),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildShortcutItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: outlineVariant),
          ),
          child: Icon(icon, color: primaryColor, size: 26),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Public Sans',
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildResourceRow(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: primaryContainer.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Public Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
