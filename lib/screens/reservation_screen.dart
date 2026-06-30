import 'package:flutter/material.dart';

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});

  final List<Map<String, String>> reservations = const [
    {"name": "Badru Amour", "status": "Pending"},
    {"name": "Amina Ali", "status": "Approved"},
    {"name": "Peter Kim", "status": "Rejected"},
    {"name": "John Deo", "status": "Pending"},
    {"name": "Sara Mohamed", "status": "Approved"},
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reservations")),

      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: reservations.length,
        itemBuilder: (_, i) {
          final item = reservations[i];

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xff0A66FF),
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(item["name"]!),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(item["status"]!).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item["status"]!,
                  style: TextStyle(
                    color: getStatusColor(item["status"]!),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}