import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ---------- Écran de connexion ----------
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(user: _userCtrl.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Icon(Icons.home, size: 96, color: Theme.of(context).primaryColor),
              SizedBox(height: 16),
              Text(
                'Maison Connectée',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _userCtrl,
                      decoration: InputDecoration(
                        labelText: 'Nom d\'utilisateur',
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Saisir le nom d\'utilisateur'
                          : null,
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Mot de passe'),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Saisir le mot de passe'
                          : null,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        child: Text('Se connecter'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Mot de passe oublié ?'),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Dashboard principal ----------
class DashboardScreen extends StatefulWidget {
  final String user;
  DashboardScreen({required this.user});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool espConnected = false; // état fictif de connexion Bluetooth/Wi-Fi
  String wifiName = 'Box_Maison';

  List<String> notifications = [
    '12:45 - Lumière Salon allumée',
    '12:40 - Mouvement détecté Jardin',
    '12:38 - Connexion Wi-Fi changée',
  ];

  Map<String, bool> lights = {
    'Salon': true,
    'Cuisine': false,
    'Chambre': false,
    'Jardin': true,
  };

  void _toggleEspConnection() {
    setState(() => espConnected = !espConnected);
    _addNotification('ESP32 ${espConnected ? 'connecté' : 'déconnecté'}');
  }

  void _changeWifi() async {
    final controller = TextEditingController(text: wifiName);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Changer le réseau Wi-Fi'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Nom Wi‑Fi'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text('Valider'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() => wifiName = result);
      _addNotification('Wi‑Fi changé: $wifiName');
    }
  }

  void _addNotification(String text) {
    final time = TimeOfDay.now();
    final stamp =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    setState(() => notifications.insert(0, '$stamp - $text'));
  }

  Future<void> _quickCall() async {
    const phone = 'tel:+261XXXXXXXXX'; // remplacer par le numéro réel
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Impossible de lancer l\'appel')));
    }
  }

  void _openLights() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LightsControlScreen(
          lights: lights,
          onChanged: (m) => setState(() => lights = m),
        ),
      ),
    );
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationsScreen(notifications: notifications),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de Bord'),
        actions: [
          IconButton(
            icon: Icon(
              espConnected ? Icons.bluetooth_connected : Icons.bluetooth,
            ),
            onPressed: _toggleEspConnection,
          ),
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.user),
              accountEmail: Text('utilisateur@example.com'),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Tableau de Bord')),
            ListTile(
              leading: Icon(Icons.lightbulb),
              title: Text('Contrôle Lumières'),
              onTap: _openLights,
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Logs & Notifications'),
              onTap: _openNotifications,
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Déconnexion'),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statut ESP',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(espConnected ? 'Connecté' : 'Déconnecté'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Wi‑Fi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Text(wifiName),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: _changeWifi,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _openLights,
              icon: Icon(Icons.lightbulb),
              label: Text('Contrôle Lumières'),
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _openNotifications,
              icon: Icon(Icons.notifications),
              label: Text('Voir Notifications'),
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _quickCall,
              icon: Icon(Icons.call),
              label: Text('Appel Rapide Maison'),
            ),
            SizedBox(height: 20),
            Text(
              'Derniers événements',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (_, i) => ListTile(title: Text(notifications[i])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Contrôle des lumières ----------
class LightsControlScreen extends StatefulWidget {
  final Map<String, bool> lights;
  final ValueChanged<Map<String, bool>> onChanged;
  LightsControlScreen({required this.lights, required this.onChanged});

  @override
  _LightsControlScreenState createState() => _LightsControlScreenState();
}

class _LightsControlScreenState extends State<LightsControlScreen> {
  late Map<String, bool> localLights;

  @override
  void initState() {
    super.initState();
    localLights = Map.from(widget.lights);
  }

  void _toggleAll(bool value) {
    setState(() => localLights.updateAll((key, val) => value));
    widget.onChanged(localLights);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contrôle Lumières')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: localLights.keys
                    .map(
                      (k) => SwitchListTile(
                        title: Text(k),
                        value: localLights[k]!,
                        onChanged: (v) {
                          setState(() => localLights[k] = v);
                          widget.onChanged(localLights);
                        },
                        secondary: Icon(Icons.lightbulb),
                      ),
                    )
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _toggleAll(false),
                  child: Text('Tout Éteindre'),
                ),
                ElevatedButton(
                  onPressed: () => _toggleAll(true),
                  child: Text('Tout Allumer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Notifications & Rapports ----------
class NotificationsScreen extends StatelessWidget {
  final List<String> notifications;
  NotificationsScreen({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: notifications.length,
        itemBuilder: (_, i) => Card(
          child: ListTile(
            leading: Icon(Icons.notification_important),
            title: Text(notifications[i]),
            subtitle: Text('Voir plus'),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}



// Notifcaiton version 2
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String selectedFilter = "Tout";

  List<Map<String, dynamic>> notifications = [
    {
      "type": "Mouvement",
      "title": "Détection de mouvement",
      "subtitle": "Salon - 14:32",
      "time": "il y a 12 min",
      "icon": Icons.motion_photos_on,
      "isRead": false,
    },
    {
      "type": "Gaz",
      "title": "Fuite de gaz",
      "subtitle": "Cuisine - 13:54",
      "time": "il y a 19 min",
      "icon": Icons.local_fire_department,
      "isRead": true,
    },
    {
      "type": "Porte",
      "title": "Porte ouverte",
      "subtitle": "Entrée - 14:32",
      "time": "il y a 12 min",
      "icon": Icons.door_front_door,
      "isRead": false,
    },
  ];

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == "Tout") return notifications;
    if (selectedFilter == "Non lue") {
      return notifications.where((n) => !n["isRead"]).toList();
    }
    return notifications.where((n) => n["type"] == selectedFilter).toList();
  }

  Future<void> exportNotifications() async {
    final now = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = "notifications_$now.txt";
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$fileName");

    final content = notifications.map((n) {
      return "${n["time"]} - ${n["type"]}: ${n["title"]} (${n["subtitle"]}) [${n["isRead"] ? "Lu" : "Non lu"}]";
    }).join("\n");

    await file.writeAsString(content);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Exporté : $fileName")),
    );
  }

  void simulateAlert() {
    setState(() {
      notifications.insert(0, {
        "type": "Gaz",
        "title": "Simulation : fuite de gaz",
        "subtitle": "Test - ${DateFormat.Hm().format(DateTime.now())}",
        "time": "Maintenant",
        "icon": Icons.warning,
        "isRead": false,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final filters = ["Tout", "Non lue", "Mouvement", "Gaz", "Porte"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: exportNotifications,
            tooltip: "Exporter",
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: simulateAlert,
            tooltip: "Simuler une alerte",
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: filters.map((filter) {
                final isSelected = selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) => setState(() => selectedFilter = filter),
                    selectedColor: Colors.deepPurple,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotifications.length,
              itemBuilder: (context, index) {
                final notif = filteredNotifications[index];
                return ListTile(
                  leading: Icon(notif["icon"], color: notif["isRead"] ? Colors.grey : Colors.orange),
                  title: Text(notif["title"]),
                  subtitle: Text(notif["subtitle"]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(notif["time"], style: const TextStyle(color: Colors.grey)),
                      IconButton(
                        icon: Icon(
                          notif["isRead"] ? Icons.mark_email_read : Icons.mark_email_unread,
                          color: notif["isRead"] ? Colors.green : Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            notif["isRead"] = !notif["isRead"];
                          });
                        },
                        tooltip: notif["isRead"] ? "Marquer comme non lu" : "Marquer comme lu",
                      ),
                    ],
                  ),
                  onTap: () {
                    // Détail ou action future
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
