import 'package:flutter/material.dart';
// import 'package:mjpeg_view/mjpeg_view.dart';
import '../widget/navigation.dart';
import '../widget/video_player.dart';
import 'accueil.dart';
import 'appel.dart';
import 'eclairage.dart';
import 'parametre.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  int _currentIndex = 2;
  bool isRecording = false;
  bool isMicOn = false;

  //  Lampes dans la pièce
  List<bool> lampStates = [false, false];

  //  Caméras disponibles
  List<String> cameraNames = ["Caméra #1", "Caméra #2", "Caméra #3"];
  int selectedCameraIndex = 0;

  void toggleRecording() => setState(() => isRecording = !isRecording);
  void toggleMic() => setState(() => isMicOn = !isMicOn);
  void toggleLamp(int index) =>
      setState(() => lampStates[index] = !lampStates[index]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //  Fond principal blanc
      appBar: AppBar(
        title: const Text(
          "Caméra ",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          textAlign: TextAlign.start,
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 📺 Section 1 – Flux caméra (fond noir)
          Stack(
            children: [
              Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: const VideoWidget(
                          url:
                              "https://cdn.pixabay.com/video/2025/01/10/251873_tiny.mp4"),
                    ),
                  )),
              // 🔘 Contrôles en haut à gauche
              Positioned(
                top: 4,
                left: 4,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isRecording
                            ? Icons.stop_circle
                            : Icons.fiber_manual_record,
                        color: isRecording ? Colors.redAccent : Colors.white,
                        size: 16,
                      ),
                      onPressed: toggleRecording,
                    ),
                    IconButton(
                      icon: Icon(
                        isMicOn ? Icons.mic : Icons.mic_off,
                        color: isMicOn ? Colors.green : Colors.grey,
                        size: 22,
                      ),
                      onPressed: toggleMic,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.history,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () {
                        // Historique
                      },
                    ),
                  ],
                ),
              ),

              // 💡 Lampes en haut à droite
              Positioned(
                top: 60,
                right: 8,
                child: Column(
                  children: List.generate(lampStates.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => toggleLamp(index),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: lampStates[index]
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade600,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                lampStates[index]
                                    ? Icons.lightbulb
                                    : Icons.lightbulb_outline,
                                color: lampStates[index]
                                    ? Colors.yellowAccent
                                    : Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cameraNames[selectedCameraIndex],
                style: const TextStyle(color: Colors.black),
              ),
              const Row(
                children: [
                  Icon(Icons.circle, color: Colors.red, size: 12),
                  SizedBox(width: 6),
                  Text("En direct", style: TextStyle(color: Colors.black54)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          //  Section 2 – Captures récentes
          const Text(
            "Captures récentes",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (index) {
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      backgroundColor: Colors.black.withOpacity(0.8),
                      insetPadding: const EdgeInsets.all(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 60,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 24),

          // 🎥 Section 3 – Carrousel des caméras
          const Text(
            "Caméras disponibles",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          cameraNames.length > 1
              ? SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cameraNames.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == selectedCameraIndex;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => selectedCameraIndex = index);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? Colors.blueAccent
                                : Colors.grey.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(cameraNames[index]),
                        ),
                      );
                    },
                  ),
                )
              : Text(
                  cameraNames.first,
                  style: const TextStyle(color: Colors.black),
                ),

          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: ButtonNavigation(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
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
        },
      ),
    );
  }
}
