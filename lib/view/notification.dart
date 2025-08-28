import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String selectedFilter = "Tout";

  final List<Map<String, dynamic>> notifications = [
    {
      "type": "Mouvement",
      "title": "Détection de mouvement",
      "subtitle": "Salon - 14:32",
      "time": "il y a 12 min",
      "icon": Icons.motion_photos_on,
    },
    {
      "type": "Gaz",
      "title": "Fuite de gaz",
      "subtitle": "Cuisine - 13:54",
      "time": "il y a 19 min",
      "icon": Icons.local_fire_department,
    },
    // {
    //   "type": "Porte",
    //   "title": "Porte d’entrée ouverte",
    //   "subtitle": "Entrée - 14:32",
    //   "time": "il y a 12 min",
    //   "icon": Icons.door_front_door,
    // },
  ];

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == "Tout") return notifications;
    return notifications.where((n) => n["type"] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildFilterBar(),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotifications.length,
              itemBuilder: (context, index) {
                final notif = filteredNotifications[index];
                return ListTile(
                  leading: Icon(notif["icon"], color: Colors.blue),
                  title: Text(notif["title"]),
                  subtitle: Text(notif["subtitle"]),
                  trailing: Text(
                    notif["time"],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    // Action : ouvrir détail ou marquer comme lu
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    final filters = [
      "Tout",
      "Non lue",
      "Mouvement",
      "Gaz",
    ];
    return SingleChildScrollView(
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
              selectedColor: Colors.blue,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
