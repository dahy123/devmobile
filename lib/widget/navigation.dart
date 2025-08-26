import 'package:flutter/material.dart';

class ButtonNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const ButtonNavigation({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Accueil", 0),
            _buildNavItem(Icons.lightbulb, "Éclair", 1),
            _buildNavItem(Icons.camera_alt, "Caméra", 2),
            _buildNavItem(Icons.call, "Appel", 3),
            _buildNavItem(Icons.settings, "Paramètres", 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = index == currentIndex;
    final Color color = isActive ? Colors.blue : Colors.grey;

    return InkWell(
      splashColor: const Color.fromARGB(57, 33, 149, 243),
      onTap: () => onItemSelected(index),
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 4)),
          ],
        ),
      ),
    );
  }
}
