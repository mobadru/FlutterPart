import 'package:flutter/material.dart';

class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({super.key});

  final List<Map<String, String>> pharmacies = const [
    {
      "name": "City Pharmacy",
      "location": "Zanzibar Town",
    },
    {
      "name": "Health Care Pharmacy",
      "location": "Mwanakwerekwe",
    },
    {
      "name": "Ocean Medical Store",
      "location": "Kikwajuni",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pharmacy")),

      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: pharmacies.length,
        itemBuilder: (_, i) {
          final item = pharmacies[i];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(
                Icons.local_pharmacy,
                color: Color(0xff0A66FF),
              ),
              title: Text(item["name"]!),
              subtitle: Text("📍 ${item["location"]}"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          );
        },
      ),
    );
  }
}