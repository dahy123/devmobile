import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widget/navigation.dart';
import 'accueil.dart';
import 'camera.dart';
import 'eclairage.dart';
import 'parametre.dart';

class Appel extends StatefulWidget {
  const Appel({super.key});

  @override
  State<Appel> createState() => _AppelState();
}

class _AppelState extends State<Appel> {
  int _currentIndex = 3;

  final List<Map<String, dynamic>> personalContacts = [
    {"label": "Maison", "number": "+261327654678"},
    {"label": "Bureau", "number": "+261327654678"},
  ];

  final List<Map<String, dynamic>> emergencyContacts = [
    {"label": "Police", "number": "605", "icon": Icons.local_police},
    {
      "label": "Pompier",
      "number": "+261327654678",
      "icon": Icons.fire_extinguisher
    },
    {
      "label": "SAMU",
      "number": "+261327654678",
      "icon": Icons.medical_services
    },
  ];

  void _callNumber(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'appeler ce numéro")),
      );
    }
  }

  void _onItemSelected(int index) {
    setState(() => _currentIndex = index);

    final pages = [
      const Accueil(),
      const Eclairage(),
      const Camera(),
      const Appel(),
      const Parametre(),
    ];

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // En-tête fixe
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Appel d'urgence",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 24,
                              ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Contactez rapide vos proches ou service d'urgence",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Bouton fixe
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _callNumber("+261327654678"),
                icon: const Icon(Icons.call, size: 24, color: Colors.white),
                label: const Text(
                  "Appel Rapide Maison",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Liste scrollable
            Expanded(
              child: ListView(
                children: [
                  _buildSection("Contacts personnels", personalContacts,
                      defaultIcon: Icons.home),
                  const SizedBox(height: 24),
                  _buildSection("Services d'urgence", emergencyContacts,
                      defaultIcon: Icons.local_hospital),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ButtonNavigation(
        currentIndex: _currentIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> contacts,
      {required IconData defaultIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        ...contacts.map((c) => _buildContactTile(
              c['label'],
              c['number'],
              icon: c.containsKey('icon') ? c['icon'] : defaultIcon,
            )),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.blue, size: 20),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(String label, String number,
      {required IconData icon}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label),
        subtitle: Text(number),
        trailing: IconButton(
          icon: const Icon(Icons.phone, color: Colors.green),
          onPressed: () => _callNumber(number),
        ),
      ),
    );
  }
}
