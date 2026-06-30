import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 👤 AVATAR SECTION
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xff0A66FF),
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Patient Profile",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // 📄 INFO CARDS
            Card(
              child: ListTile(
                leading: const Icon(Icons.badge, color: Color(0xff0A66FF)),
                title: const Text("Patient ID"),
                subtitle: const Text("001"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.person, color: Color(0xff0A66FF)),
                title: const Text("Name"),
                subtitle: const Text("Badru Amour"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.phone, color: Color(0xff0A66FF)),
                title: const Text("Phone"),
                subtitle: const Text("+255 700 000 000"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on,
                    color: Color(0xff0A66FF)),
                title: const Text("Location"),
                subtitle: const Text("Zanzibar, Tanzania"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}