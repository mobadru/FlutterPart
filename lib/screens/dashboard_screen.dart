import 'package:flutter/material.dart';
import 'medicines_screen.dart';
import 'pharmacy_screen.dart';
import 'reservation_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int index = 0;

  final pages = const [
    HomeDashboard(),
    MedicinesScreen(),
    PharmacyScreen(),
    ReservationScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: const Color(0xff0A66FF),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: "Medicines"),
          BottomNavigationBarItem(icon: Icon(Icons.local_pharmacy), label: "Pharmacy"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Reservation"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

/* ================= HOME DASHBOARD ================= */

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final reservations = [
      {"name": "Badru Amour", "status": "Pending"},
      {"name": "Amina Ali", "status": "Approved"},
      {"name": "Peter Kim", "status": "Rejected"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // TOP CARDS
            Row(
              children: const [
                Expanded(child: DashboardCard(title: "Reservations", icon: Icons.event)),
                SizedBox(width: 10),
                Expanded(child: DashboardCard(title: "Pharmacy", icon: Icons.local_pharmacy)),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Latest Reservations",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (_, i) {
                  final item = reservations[i];

                  Color color = Colors.orange;
                  if (item["status"] == "Approved") color = Colors.green;
                  if (item["status"] == "Rejected") color = Colors.red;

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(item["name"]!),
                      trailing: Text(
                        item["status"]!,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= DASHBOARD CARD ================= */

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff0A66FF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: const Color(0xff0A66FF)),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}