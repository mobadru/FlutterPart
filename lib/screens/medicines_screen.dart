import 'package:flutter/material.dart';

class MedicinesScreen extends StatefulWidget {
  const MedicinesScreen({super.key});

  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> medicines = [
    {"name": "Paracetamol", "stock": 120},
    {"name": "Amoxicillin", "stock": 45},
    {"name": "Ibuprofen", "stock": 78},
    {"name": "Metformin", "stock": 30},
  ];

  List<Map<String, dynamic>> filtered = [];

  @override
  void initState() {
    super.initState();
    filtered = medicines;
  }

  void searchMedicine(String value) {
    setState(() {
      filtered = medicines
          .where((m) =>
              m["name"].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medicines")),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            // 🔍 SEARCH BAR
            TextField(
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

            const SizedBox(height: 15),

            // 🧾 MEDICINE LIST
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final item = filtered[i];

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.medication),
                      title: Text(item["name"]),
                      subtitle: const Text("Available medicine"),
                      trailing: Text(
                        "Stock: ${item["stock"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // 📦 STOCK SUMMARY CARD
            Card(
              color: const Color(0xff0A66FF).withOpacity(0.1),
              child: const ListTile(
                leading: Icon(Icons.inventory, color: Color(0xff0A66FF)),
                title: Text("Total Stock Overview"),
                subtitle: Text("All medicine stock is updated"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}