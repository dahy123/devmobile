import 'package:flutter/material.dart';
import 'package:devmobile/view/appel.dart';
import 'package:devmobile/view/camera.dart';
import 'package:devmobile/view/eclairage.dart';
import 'package:devmobile/view/parametre.dart';
import '../widget/navigation.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Message de bienvenue
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bonjour, Oldon",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontSize: 28,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Surveillez et contrôlez votre maison",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {},
                      color: Colors.blue,
                      iconSize: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bloc fonctionnalités principales
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  _buildCard(Icons.videocam, "CAMERA", "2/3", Colors.blue),
                  _buildCard(
                    Icons.directions_run,
                    "DETECTEUR ",
                    "2/2",
                    Colors.blue,
                  ),
                  _buildCard(
                    Icons.local_fire_department,
                    "GAZ",
                    "1/1",
                    Colors.blue,
                  ),
                  _buildCard(Icons.lightbulb, "LAMPE", "2/6", Colors.blue),
                ],
              ),

              const SizedBox(height: 20),

              // Accès rapide
              Text(
                "Accès rapide",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionRapide(Icons.lightbulb, "Allumer", Colors.blue),
                  const SizedBox(width: 8),
                  _buildActionRapide(
                    Icons.nightlight_round,
                    "Nuit",
                    Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildActionRapide(
                    Icons.power_settings_new,
                    "Éteindre",
                    Colors.blue,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Alertes récentes
              Text(
                "Alertes récentes",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      // fontSize: 16,
                    ),
              ),
              const SizedBox(height: 10),
              _buildAlertTile(
                Icons.videocam,
                "Caméra activée",
                "Chambre principale a un mouvement",
                "Ven, 10:45",
              ),
              _buildAlertTile(
                Icons.local_fire_department,
                "Fuite de gaz",
                "Aujourd'hui, 09:00",
                "Jeu, 22:15",
              ),
              _buildAlertTile(
                Icons.directions_run,
                "Mouvement détecté",
                "Aujourd'hui, 08:30",
                "Mar, 18:30",
              ),
            ],
          ),
        ),
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

  // Widget pour les fonctionnalités principales
  Widget _buildCard(IconData icon, String title, String status, Color color) {
    return SizedBox(
      height: 2,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: 54, color: color),
                  Text(
                    status,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 4, bottom: 8),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour les actions rapides
  Widget _buildActionRapide(IconData icon, String label, Color color) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        onPressed: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour les alertes
  Widget _buildAlertTile(
    IconData icon,
    String title,
    String message,
    String time,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              time,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                letterSpacing: 0.05,
              ),
            ),
          ],
        ),
        subtitle: Text(
          message,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        // trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
