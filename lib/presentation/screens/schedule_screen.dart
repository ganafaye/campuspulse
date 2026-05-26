// lib/presentation/screens/schedule_screen.dart

import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Gestion du jour actif (par défaut Lundi)
  String _selectedDay = 'Lundi';

  final List<String> days = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi'
  ];

  // Configuration des couleurs extraite de ta charte graphique
  static const Color primaryColor = Color(0xFF00113A);
  static const Color primaryContainer = Color(0xFF002366);
  static const Color onPrimaryContainer = Color(0xFF758DD5);
  static const Color secondaryColor = Color(0xFF115CB9);
  static const Color secondaryContainer = Color(0xFF659DFE);
  static const Color onSecondaryContainer = Color(0xFF003370);
  static const Color backgroundColor = Color(0xFFF8F9FB);
  static const Color outlineVariant = Color(0xFFC5C6D2);
  static const Color onSurfaceVariant = Color(0xFF444650);
  static const Color onSurface = Color(0xFF191C1E);
  static const Color offlineBannerBg = Color(0xFF222932);
  static const Color offlineBannerText = Color(0xFFDCE3EF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // 1. Top AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape:
            const Border(bottom: BorderSide(color: outlineVariant, width: 1)),
        title: const Row(
          children: [
            Icon(Icons.school, color: primaryColor, size: 28),
            SizedBox(width: 12),
            Text(
              'CampusPulse',
              style: TextStyle(
                fontFamily: 'Public Sans',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: onSurfaceVariant),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Actualisation des cours...'),
                    duration: Duration(seconds: 1)),
              );
            },
            tooltip: 'Actualiser',
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: onSurfaceVariant),
            onPressed: () {},
            tooltip: 'Paramètres',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 2. Offline Banner
            Container(
              width: double.infinity,
              color: offlineBannerBg,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, color: offlineBannerText, size: 14),
                  SizedBox(width: 8),
                  Text(
                    'Mode hors ligne',
                    style: TextStyle(
                      fontFamily: 'Public Sans',
                      fontSize: 12,
                      color: offlineBannerText,
                    ),
                  ),
                ],
              ),
            ),

            // 3. Main Scrollable Canvas
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sélecteur horizontal de jours Rendu Dynamique
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border:
                            Border(bottom: BorderSide(color: outlineVariant)),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: days.map((day) {
                            // Vérification dynamique du jour actif
                            final bool isActive = day == _selectedDay;
                            return Container(
                              margin: const EdgeInsets.only(right: 12),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Met à jour l'état lors du clic sur un jour
                                  setState(() {
                                    _selectedDay = day;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isActive
                                      ? primaryContainer
                                      : Colors.white,
                                  foregroundColor: isActive
                                      ? Colors.white
                                      : onSurfaceVariant,
                                  elevation: isActive ? 2 : 0,
                                  shadowColor: isActive
                                      ? Colors.black38
                                      : Colors.transparent,
                                  side: isActive
                                      ? null
                                      : const BorderSide(color: outlineVariant),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                                child: Text(
                                  day,
                                  style: const TextStyle(
                                    fontFamily: 'Public Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // Contenu principal (Cartes de cours adaptées selon le jour sélectionné)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // On n'affiche le cours "En cours" que si l'on est sur le jour courant (Simulé ici sur le Lundi)
                          if (_selectedDay == 'Lundi') ...[
                            Row(
                              children: [
                                Icon(Icons.access_time_filled,
                                    color: secondaryColor, size: 24),
                                const SizedBox(width: 8),
                                const Text(
                                  'En cours',
                                  style: TextStyle(
                                      fontFamily: 'Public Sans',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Carte : Cours En Cours
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: outlineVariant),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2))
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    width: 4,
                                    child: Container(color: secondaryColor),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: secondaryContainer
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: const Text(
                                                      '08:00 - 10:00',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Public Sans',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              onSecondaryContainer),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  const Text(
                                                    '• En direct',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Public Sans',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: secondaryColor),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              const Text(
                                                'Développement Mobile',
                                                style: TextStyle(
                                                    fontFamily: 'Public Sans',
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryColor),
                                              ),
                                              const SizedBox(height: 16),
                                              const Row(
                                                children: [
                                                  Icon(Icons.person,
                                                      size: 18,
                                                      color: onSurfaceVariant),
                                                  SizedBox(width: 6),
                                                  Text('M. Gaye',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Public Sans',
                                                          fontSize: 14,
                                                          color:
                                                              onSurfaceVariant)),
                                                  SizedBox(width: 20),
                                                  Icon(Icons.room,
                                                      size: 18,
                                                      color: onSurfaceVariant),
                                                  SizedBox(width: 6),
                                                  Text('Salle B1',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Public Sans',
                                                          fontSize: 14,
                                                          color:
                                                              onSurfaceVariant)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCfUrvXtfbLlX72s4WFThc3omDw3i8mgwjGYiQszn-BgacDdqT_O1fCaiR_Fq0KJhJ8B0fjhIIOKfoVlnOSWHu_p8BfYfSPA_ZvB1RZMvIkBMKhE8bGhxZGVj0wGcrK9A9iOKptN8IO2czzFIqfOoOmwY_UHcH7j82I_qJQ9QGmXdndqxzjadYbIQnxfv2FK3tPnPvSEXgrnMO3NQrDbtDiFgBQgooAqo1fb77egcGMz-Po-lZIYmJmBrysHwzmjokBjvWAOcVHXss',
                                            width: 72,
                                            height: 72,
                                            fit: BoxFit.cover,
                                            color: Colors.grey,
                                            colorBlendMode:
                                                BlendMode.saturation,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                              width: 72,
                                              height: 72,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.person,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                          ],

                          // SECTION : À venir (Adaptable ou vide selon le jour choisi)
                          Row(
                            children: [
                              Icon(Icons.upcoming,
                                  color: secondaryColor, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                _selectedDay == 'Lundi'
                                    ? 'À venir'
                                    : 'Cours du $_selectedDay',
                                style: const TextStyle(
                                    fontFamily: 'Public Sans',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Exemple de gestion des données par jour
                          if (_selectedDay == 'Lundi') ...[
                            _buildUpcomingCourseCard(
                                time: '10:15 - 12:15',
                                title: 'Intelligence Artificielle',
                                professor: 'Mme Diop',
                                room: 'Lab 3'),
                            const SizedBox(height: 16),
                            _buildAfternoonSeparator(),
                            const SizedBox(height: 16),
                            _buildUpcomingCourseCard(
                                time: '14:00 - 16:00',
                                title: 'Génie Logiciel',
                                professor: 'M. Traoré',
                                room: 'Amphi A'),
                          ] else if (_selectedDay == 'Mercredi') ...[
                            _buildUpcomingCourseCard(
                                time: '08:00 - 12:00',
                                title: 'Architectures Cloud & DevOps',
                                professor: 'Dr. Babou',
                                room: 'Salle SATIC'),
                          ] else ...[
                            // Rendu par défaut pour les autres jours pour simuler du contenu
                            _buildUpcomingCourseCard(
                                time: '09:00 - 12:00',
                                title: 'Systèmes d\'Information',
                                professor: 'M. Faye',
                                room: 'Salle B2'),
                          ],

                          const SizedBox(height: 24),

                          // Aperçu du Jour (Bento Style Sidebar)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 3))
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'APERÇU DU JOUR',
                                  style: TextStyle(
                                      fontFamily: 'Public Sans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70),
                                ),
                                const SizedBox(height: 16),
                                _buildBentoRow('Cours total',
                                    _selectedDay == 'Lundi' ? '4' : '2'),
                                const Divider(
                                    color: onPrimaryContainer, height: 20),
                                _buildBentoRow('Heures',
                                    _selectedDay == 'Lundi' ? '8h' : '4h'),
                                const SizedBox(height: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: _selectedDay == 'Lundi' ? 0.25 : 0.0,
                                    backgroundColor: onPrimaryContainer,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            secondaryContainer),
                                    minHeight: 8,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _selectedDay == 'Lundi'
                                      ? '1/4 cours terminé'
                                      : '0 cours terminé',
                                  style: const TextStyle(
                                      fontFamily: 'Public Sans',
                                      fontSize: 12,
                                      color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Documents récents Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: outlineVariant),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'DOCUMENTS RÉCENTS',
                                  style: TextStyle(
                                      fontFamily: 'Public Sans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                                const SizedBox(height: 16),
                                _buildDocumentRow(
                                    Icons.description, 'Syllabus_Mobile.pdf'),
                                const SizedBox(height: 12),
                                _buildDocumentRow(
                                    Icons.picture_as_pdf, 'Intro_IA_v2.pdf'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Bannière d'actualité Campus
                          Container(
                            width: double.infinity,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 4)
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  Image.network(
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAcibP4bzuqVIeV5crcnq00spBlhimaxTgL_bLHdcbLhWAjN-zkBG-KXreKsmBsVtgYu-lslRdmeKMyMMbjuqyKs4BCdHl6x31P0fah8QxCUOgCpv7Vj62Bpm7SLp1ohpbdce12kLrZqLp9zmCB70BOdr7uK-qOsPa91PqXAqD9ZvJVdQTT_nD3HALhtIQYIzwnVM3W2ew7-HzgpTo-za83DSAIze_jC6YFI_zn14mga0wBMF7Dtr1LIu2wng6eQBo3-GJ59XG7rgY',
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(color: Colors.grey[300]),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          primaryColor.withOpacity(0.8),
                                          Colors.transparent
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    bottom: 16,
                                    left: 16,
                                    right: 16,
                                    child: Text(
                                      'Expositions de projets fin d\'année - Inscriptions ouvertes',
                                      style: TextStyle(
                                          fontFamily: 'Public Sans',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Raccourci d'implémentation pour le séparateur "Après-midi"
  Widget _buildAfternoonSeparator() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE6E8EA),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Text(
            'APRÈS-MIDI',
            style: TextStyle(
                fontFamily: 'Public Sans',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Container(height: 1, color: outlineVariant)),
      ],
    );
  }

  // Helper épuré pour construire les cartes de cours à venir
  Widget _buildUpcomingCourseCard({
    required String time,
    required String title,
    required String professor,
    required String room,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time,
                    style: const TextStyle(
                        fontFamily: 'Public Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: onSurfaceVariant)),
                const SizedBox(height: 4),
                Text(title,
                    style: const TextStyle(
                        fontFamily: 'Public Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(professor,
                        style: const TextStyle(
                            fontFamily: 'Public Sans',
                            fontSize: 14,
                            color: onSurfaceVariant)),
                    const SizedBox(width: 20),
                    const Icon(Icons.meeting_room,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(room,
                        style: const TextStyle(
                            fontFamily: 'Public Sans',
                            fontSize: 14,
                            color: onSurfaceVariant)),
                  ],
                )
              ],
            ),
          ),
          IconButton(
            icon:
                const Icon(Icons.notifications_none, color: Color(0xFF115CB9)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Helper pour l'aperçu Bento
  Widget _buildBentoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontFamily: 'Public Sans', fontSize: 16, color: Colors.white)),
        Text(value,
            style: const TextStyle(
                fontFamily: 'Public Sans',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  // Helper pour les documents récents
  Widget _buildDocumentRow(IconData icon, String fileName) {
    return Row(
      children: [
        Icon(icon, color: secondaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            fileName,
            style: const TextStyle(
                fontFamily: 'Public Sans',
                fontSize: 16,
                color: onSurface,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
