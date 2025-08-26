import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widget/navigation.dart';
import 'accueil.dart';
import 'appel.dart';
import 'camera.dart';
import 'eclairage.dart';

class Parametre extends StatefulWidget {
  const Parametre({super.key});

  @override
  State<Parametre> createState() => _ParametreState();
}

class _ParametreState extends State<Parametre> {
  int _currentIndex = 4;

  bool isDarkMode = false;
  bool isNotificationEnabled = true;
  bool isBiometricEnabled = false;
  bool isAutoConnectESP = true;

  String espIp = "192.168.4.1";
  String espPort = "80";
  String espName = "SMART-MG-ESP";

  Future<void> sendCommandToESP32(String command) async {
    final uri = Uri.parse("http://$espIp:$espPort/$command");
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        print("Commande envoyée : ${response.body}");
      } else {
        print("Erreur ESP32 : ${response.statusCode}");
      }
    } catch (e) {
      print("Échec de connexion ESP32 : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Paramètres",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 12),
          _buildSectionTitle("Compte"),
          _buildTile("Nom", "Oldon", Icons.person),
          _buildTile("Email", "oldon@smart-mg.org", Icons.email),
          _buildTile("Mot de passe", "••••••••", Icons.lock),

          const SizedBox(height: 24),
          _buildSectionTitle("Connexion"),
          _buildSwitchTile("WiFi", true, Icons.wifi, (val) {}),
          _buildSwitchTile("Bluetooth", false, Icons.bluetooth, (val) {}),

          const SizedBox(height: 24),
          _buildSectionTitle("Notifications"),
          _buildSwitchTile(
            "Activer les notifications",
            isNotificationEnabled,
            Icons.notifications,
            (val) {
              setState(() => isNotificationEnabled = val);
            },
          ),

          const SizedBox(height: 24),
          _buildSectionTitle("Apparence"),
          _buildSwitchTile("Mode sombre", isDarkMode, Icons.dark_mode, (val) {
            setState(() => isDarkMode = val);
          }),

          const SizedBox(height: 24),
          _buildSectionTitle("Sécurité"),
          _buildSwitchTile(
            "Verrouillage biométrique",
            isBiometricEnabled,
            Icons.fingerprint,
            (val) {
              setState(() => isBiometricEnabled = val);
            },
          ),

          const SizedBox(height: 24),
          _buildSectionTitle("ESP32"),
          _buildTile("Adresse IP", espIp, Icons.router),
          _buildTile("Port", espPort, Icons.settings_ethernet),
          _buildTile("Nom du module", espName, Icons.memory),
          _buildSwitchTile(
            "Connexion automatique",
            isAutoConnectESP,
            Icons.autorenew,
            (val) {
              setState(() => isAutoConnectESP = val);
            },
          ),
          ElevatedButton.icon(
            onPressed: () => sendCommandToESP32("test"),
            icon: const Icon(Icons.send),
            label: const Text("Tester la connexion ESP32"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Action de déconnexion ou sauvegarde
            },
            icon: const Icon(Icons.exit_to_app),
            label: const Text("Déconnexion"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ButtonNavigation(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Accueil()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Eclairage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Camera()),
              );
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Appel()),
              );
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Parametre()),
              );
            default:
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
    );
  }

  Widget _buildTile(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label),
      subtitle: Text(value),
      trailing: const Icon(Icons.edit, color: Colors.grey),
      onTap: () {
        // Naviguer vers une page de modification
      },
    );
  }

  Widget _buildSwitchTile(
    String label,
    bool value,
    IconData icon,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.teal),
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }
}
