import 'package:flutter/material.dart';

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});

  final List<Map<String, String>> reservations = const [
    {
      "medicine": "Paracetamol",
      "pharmacy": "City Pharmacy",
      "time": "30 Jun 2026 - 10:30 AM",
      "status": "Approved",
      "reservationNo": "RES001",
    },
    {
      "medicine": "Amoxicillin",
      "pharmacy": "Health Care Pharmacy",
      "time": "01 Jul 2026 - 09:15 AM",
      "status": "Pending",
      "reservationNo": "RES002",
    },
    {
      "medicine": "Metformin",
      "pharmacy": "Afya Pharmacy",
      "time": "02 Jul 2026 - 02:00 PM",
      "status": "Ready",
      "reservationNo": "RES003",
    },
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Ready":
        return Colors.blue;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case "Approved":
        return Icons.check_circle;
      case "Pending":
        return Icons.schedule;
      case "Ready":
        return Icons.inventory;
      case "Rejected":
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Reservations"),
        centerTitle: true,
      ),

      body: reservations.isEmpty
          ? const Center(
              child: Text(
                "No reservations found.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: reservations.length,
              itemBuilder: (_, index) {
                final item = reservations[index];
                final color = getStatusColor(item["status"]!);

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xff0A66FF),
                              child: Icon(
                                Icons.medication,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                item["medicine"]!,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 30),

                        Row(
                          children: [
                            const Icon(Icons.local_pharmacy,
                                color: Color(0xff0A66FF)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item["pharmacy"]!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: Color(0xff0A66FF)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(item["time"]!),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            const Icon(Icons.confirmation_number,
                                color: Color(0xff0A66FF)),
                            const SizedBox(width: 10),
                            Text(item["reservationNo"]!),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  getStatusIcon(item["status"]!),
                                  color: color,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  item["status"]!,
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}