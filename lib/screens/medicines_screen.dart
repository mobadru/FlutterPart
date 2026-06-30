import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicinesScreen extends StatefulWidget {
  const MedicinesScreen({super.key});

  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> medicines = [
    {
      "name": "Paracetamol",
      "prescription": false,
      "pharmacies": [
        {
          "name": "City Pharmacy",
          "location": "Stone Town",
          "stock": 20,
          "lat": -6.1659,
          "lng": 39.2026
        },
        {
          "name": "Health Care Pharmacy",
          "location": "Mwanakwerekwe",
          "stock": 15,
          "lat": -6.1850,
          "lng": 39.2300
        }
      ]
    },
    {
      "name": "Amoxicillin",
      "prescription": true,
      "pharmacies": [
        {
          "name": "City Pharmacy",
          "location": "Stone Town",
          "stock": 8,
          "lat": -6.1659,
          "lng": 39.2026
        },
      ]
    },
    {
      "name": "Ibuprofen",
      "prescription": false,
      "pharmacies": [
        {
          "name": "People Pharmacy",
          "location": "Chake Chake",
          "stock": 14,
          "lat": -5.2450,
          "lng": 39.7490
        },
      ]
    },
  ];

  List<Map<String, dynamic>> filtered = [];

  @override
  void initState() {
    super.initState();
    filtered = medicines;
  }

  void searchMedicine(String value) {
    setState(() {
      filtered = medicines.where((m) {
        final name = (m["name"] ?? "").toString().toLowerCase();
        return name.contains(value.toLowerCase());
      }).toList();
    });
  }

  /// 🗺 OPEN MAP
  Future<void> openMap(double lat, double lng) async {
    final url = Uri.parse("https://www.google.com/maps?q=$lat,$lng");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  /// 💊 RESERVE
  void reserveMedicine(String medicine, String pharmacy) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Reserved $medicine at $pharmacy"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showPharmacies(Map<String, dynamic> medicine) {
    final List pharmacies = medicine["pharmacies"] ?? [];
    final bool prescription = medicine["prescription"] ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 10),

                Text(
                  medicine["name"],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Chip(
                  label: Text(
                    prescription
                        ? "Prescription Required"
                        : "No Prescription",
                  ),
                  backgroundColor:
                      prescription ? Colors.orange : Colors.green,
                  labelStyle: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: pharmacies.length,
                    itemBuilder: (_, i) {
                      final p = pharmacies[i];
                      final int stock = (p["stock"] ?? 0) as int;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: ListTile(
                          leading: const Icon(
                            Icons.local_pharmacy,
                            color: Color(0xff0A66FF),
                          ),
                          title: Text(p["name"] ?? ""),
                          subtitle: Text(p["location"] ?? ""),

                          /// 🗺 TAP PHARMACY → OPEN MAP
                          onTap: () {
                            openMap(p["lat"], p["lng"]);
                          },

                          trailing: SizedBox(
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Stock: $stock",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),

                                /// 💚 FIXED GREEN BUTTON (NO OVERFLOW)
                                SizedBox(
                                  height: 32,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                    ),
                                    onPressed: stock > 0
                                        ? () => reserveMedicine(
                                              medicine["name"],
                                              p["name"],
                                            )
                                        : null,
                                    child: const Text(
                                      "Reserve",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  int getTotalStock() {
    int total = 0;

    for (var m in medicines) {
      final pharmacies = m["pharmacies"] ?? [];

      for (var p in pharmacies) {
        total += (p["stock"] as num).toInt();
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medicines")),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: searchController,
              onChanged: searchMedicine,
              decoration: InputDecoration(
                hintText: "Search medicine...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final m = filtered[i];
                final pharmacies = m["pharmacies"] ?? [];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: const Icon(Icons.medication),
                    title: Text(m["name"]),
                    subtitle:
                        Text("${pharmacies.length} pharmacies available"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => showPharmacies(m),
                  ),
                );
              },
            ),
          ),

          Card(
            color: Colors.green.withOpacity(0.1),
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.inventory, color: Colors.green),
              title: const Text("Total Stock"),
              subtitle: Text("${getTotalStock()} items available"),
            ),
          ),
        ],
      ),
    );
  }
}