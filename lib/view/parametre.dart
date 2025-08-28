import 'package:devmobile/view/accueil.dart';
import 'package:devmobile/view/appel.dart';
import 'package:devmobile/view/camera.dart';
import 'package:devmobile/view/eclairage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widget/navigation.dart';

class Parametre extends StatefulWidget {
  const Parametre({super.key});

  @override
  State<Parametre> createState() => _ParametreState();
}

class _ParametreState extends State<Parametre> {
  int _currentIndex = 4;

  // Connectivité
  bool isWifiEnabled = true;
  bool isBluetoothEnabled = true;

  // Notifications
  bool isPushAlert = true;
  bool isSmsAlert = true;

  // Réseau
  final TextEditingController ssidController =
      TextEditingController(text: "MONWIFI");
  final TextEditingController passwordController =
      TextEditingController(text: "********");
  final TextEditingController deviceController =
      TextEditingController(text: "ESP32_Domotique");

  // Compte utilisateur
  final TextEditingController emailController =
      TextEditingController(text: "user@example.com");
  final TextEditingController passController =
      TextEditingController(text: "******");
  final TextEditingController confPassController =
      TextEditingController(text: "******");

  // ESP32 Config
  String espIp = "192.168.4.1";
  String espPort = "80";

  Future<void> sendCommandToESP32(String command) async {
    final uri = Uri.parse("http://$espIp:$espPort/$command");
    try {
      final response = await http.get(uri);
      final message = response.statusCode == 200
          ? "Commande envoyée avec succès"
          : "Erreur ESP32 : ${response.statusCode}";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Échec de connexion ESP32 : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Configuration",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Paramètres de système et préférences",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 24),

            // Connectivité
            const Text(
              "Connectivité",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
                child: Column(
              children: [
                _buildCardSwitch(
                  icon: Icons.wifi,
                  iconColor: Color(0xFF2571E7),
                  title: "WiFi",
                  subtitle: "Connexion réseau sans fil",
                  value: isWifiEnabled,
                  onChanged: (val) => setState(() => isWifiEnabled = val),
                  espCommand: "wifi",
                ),
                _buildCardSwitch(
                  icon: Icons.bluetooth,
                  iconColor: Color(0xFF0ED584),
                  title: "Bluetooth",
                  subtitle: "Connexion locale ESP32",
                  value: isBluetoothEnabled,
                  onChanged: (val) => setState(() => isBluetoothEnabled = val),
                  espCommand: "bluetooth",
                ),
              ],
            )),
            const SizedBox(height: 24),
            // Configuration du réseau
            const Text(
              "Configuration du réseau",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextField("Nom du réseau WiFi (SSID)", ssidController),
            _buildTextField("Mot de passe WiFi", passwordController,
                obscureText: true),
            _buildTextField("Nom du dispositif", deviceController),

            const SizedBox(height: 24),
            // Notifications
            const Text(
              "Notifications",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  _buildCardSwitch(
                    icon: Icons.notifications,
                    iconColor: Color(0xFFFF7245),
                    title: "Alert",
                    subtitle: "Notification de push",
                    value: isPushAlert,
                    onChanged: (val) => setState(() => isPushAlert = val),
                  ),
                  _buildCardSwitch(
                    icon: Icons.sms,
                    iconColor: Color(0xFF0B1B41),
                    title: "SMS",
                    subtitle: "Alerte via une notification SMS",
                    value: isSmsAlert,
                    onChanged: (val) => setState(() => isSmsAlert = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Compte utilisateur
            const Text(
              "Compte d’utilisateur",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextField("Email", emailController),
            _buildTextField("Mot de passe", passController),
            _buildTextField("Confirmer votre mot de passe", confPassController),

            const SizedBox(
              height: 4,
            ),

            const SizedBox(height: 16),
            // Sauvegarder
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2571E7),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                // Sauvegarde des paramètres
              },
              child: const Text(
                "Sauvegarder les paramètres",
                style: TextStyle(color: Colors.white, fontSize: 16),
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

  Widget _buildCardSwitch({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    String? espCommand,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            activeColor: Color(0xFF2571E7),
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}
