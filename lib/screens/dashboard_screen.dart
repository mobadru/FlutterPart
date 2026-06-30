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

  final List<Widget> pages = const [
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: "Medicines",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy),
            label: "Pharmacy",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "Reservation",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

/* ================= HOME ================= */

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Logged in user's reservations only
    final myReservations = [
      {
        "medicine": "Paracetamol",
        "hospital": "Mnazi Mmoja Hospital",
        "status": "Pending",
        "time": "Today 10:30 AM",
      },
      {
        "medicine": "Amoxicillin",
        "hospital": "City Pharmacy",
        "status": "Approved",
        "time": "Yesterday 3:15 PM",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TOP CARDS
            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: "Reservations",
                    icon: Icons.event,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReservationScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: DashboardCard(
                    title: "Pharmacy",
                    icon: Icons.local_pharmacy,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PharmacyScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "My Recent Reservations",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: myReservations.length,
                itemBuilder: (_, index) {
                  final item = myReservations[index];

                  Color statusColor = Colors.orange;

                  if (item["status"] == "Approved") {
                    statusColor = Colors.green;
                  }

                  if (item["status"] == "Rejected") {
                    statusColor = Colors.red;
                  }

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xff0A66FF),
                        child: Icon(
                          Icons.medication,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        item["medicine"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item["hospital"]!),
                          Text(
                            item["time"]!,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: Chip(
                        backgroundColor: statusColor,
                        label: Text(
                          item["status"]!,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
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

/* ================= CARD ================= */

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff0A66FF).withOpacity(.1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 45,
              color: const Color(0xff0A66FF),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}