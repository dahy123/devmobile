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

  void _callNumber(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Gérer l'erreur si nécessaire
    }
  }

  void _onItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Accueil()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Eclairage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Camera()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Appel()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Parametre()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appel d'urgence"),
        centerTitle: true,
        backgroundColor: Colors.red.shade700,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _callNumber("+261327654678"),
              icon: const Icon(Icons.call, size: 28),
              label: const Text(
                "Appel Rapide Maison",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Contacts personnels"),
            _buildContactTile("Maison", "+261327654678"),
            _buildContactTile("Bureau", "+261327654678"),
            const SizedBox(height: 24),
            _buildSectionTitle("Services d'urgence"),
            _buildContactTile(
              "Police",
              "+261327654678",
              icon: Icons.local_police,
            ),
            _buildContactTile(
              "Pompier",
              "+261327654678",
              icon: Icons.fire_extinguisher,
            ),
            _buildContactTile(
              "SAMU",
              "+261327654678",
              icon: Icons.medical_services,
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

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildContactTile(
    String label,
    String number, {
    IconData icon = Icons.call,
  }) {
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
