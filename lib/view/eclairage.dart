import 'package:flutter/material.dart';
import '../widget/navigation.dart';
import 'accueil.dart';
import 'appel.dart';
import 'camera.dart';
import 'parametre.dart';

class Eclairage extends StatefulWidget {
  const Eclairage({super.key});

  @override
  State<Eclairage> createState() => _EclairageState();
}

class _EclairageState extends State<Eclairage> {
  int _currentIndex = 1;

  // Exemple de données
  final List<Map<String, dynamic>> rooms = [
    {
      "name": "Salon",
      "lights": [
        {"label": "Plafonnier", "on": true, "brightness": 80},
        {"label": "Lampe d’appoint", "on": false, "brightness": 0},
      ],
    },
    {
      "name": "Couloir",
      "lights": [
        {"label": "Applique", "on": true, "brightness": 80},
      ],
    },
    {
      "name": "Cuisine",
      "lights": [
        {"label": "Éclairage principal", "on": false, "brightness": 0},
      ],
    },
  ];

  void toggleAll(bool turnOn) {
    setState(() {
      for (var room in rooms) {
        for (var light in room["lights"]) {
          light["on"] = turnOn;
          if (turnOn && light["brightness"] == 0) {
            light["brightness"] = 80;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    num totalLights = rooms.fold(0, (sum, room) => sum + room["lights"].length);
    num lightsOn = rooms.fold(
      0,
      (sum, room) =>
          sum + room["lights"].where((light) => light["on"] == true).length,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Contrôle d'éclairage",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 24,
                            letterSpacing: 0.002,
                            // fontFamily: 'Times New Roman',
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$lightsOn / $totalLights lumières allumées",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Boutons d'action rapide
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Button allumer tout
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () => toggleAll(true),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lightbulb, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            "Tout allumer",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // Button allumer tout
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () => toggleAll(false),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.power_settings_new, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            "Tout éteindre",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Liste des pièces et lumières
            Expanded(
              child: ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, roomIndex) {
                  final room = rooms[roomIndex];
                  int lightsOn = room["lights"]
                      .where((light) => light["on"] == true)
                      .length;

                  int totalLights = room["lights"].length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  En-tête de la pièce
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.catching_pokemon,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              room["name"],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            // Indicateur du nombre de lumières allumées
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "$lightsOn/$totalLights",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Carte des lumières
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              ...room["lights"].map<Widget>((light) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: Text(
                                            light["label"],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Switch(
                                          activeColor: Colors.blue,
                                          value: light["on"],
                                          onChanged: (value) {
                                            setState(() {
                                              light["on"] = value;
                                              if (!value) {
                                                light["brightness"] = 0;
                                              } else if (light["brightness"] ==
                                                  0) {
                                                light["brightness"] = 80;
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    if (light["on"])
                                      Slider(
                                        value: light["brightness"].toDouble(),
                                        min: 0,
                                        max: 100,
                                        divisions: 10,
                                        label:
                                            "${light["brightness"].round()}%",
                                        onChanged: (value) {
                                          setState(() {
                                            light["brightness"] = value.round();
                                          });
                                        },
                                        activeColor: Colors.blue,
                                      ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
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
}
