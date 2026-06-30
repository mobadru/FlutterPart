import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({super.key});

  final List<Map<String, dynamic>> pharmacies = const [
    {
      "name": "City Pharmacy",
      "location": "Zanzibar Town",
      "lat": -6.1659,
      "lng": 39.2026,
      "phone": "+255 777 111111",
    },
    {
      "name": "Health Care Pharmacy",
      "location": "Mwanakwerekwe",
      "lat": -6.1700,
      "lng": 39.2200,
      "phone": "+255 777 222222",
    },
    {
      "name": "Ocean Medical Store",
      "location": "Kikwajuni",
      "lat": -6.1800,
      "lng": 39.2100,
      "phone": "+255 777 333333",
    },
    {
      "name": "Afya Pharmacy",
      "location": "Mpendae",
      "lat": -6.1725,
      "lng": 39.2148,
      "phone": "+255 777 444444",
    },
  ];

  Future<void> openMap(double lat, double lng) async {
    final Uri mapUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );

    final bool launched = await launchUrl(
      mapUrl,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: "_blank",
    );

    if (!launched) {
      debugPrint("Failed to open Google Maps");
    }
  }

  Future<void> callPharmacy(String phone) async {
    final Uri phoneUrl = Uri.parse("tel:$phone");

    await launchUrl(
      phoneUrl,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: "_self",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Pharmacies"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: pharmacies.length,
        itemBuilder: (context, index) {
          final pharmacy = pharmacies[index];

          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () async {
                await openMap(
                  pharmacy["lat"] as double,
                  pharmacy["lng"] as double,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xff0A66FF).withOpacity(.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_pharmacy,
                        color: Color(0xff0A66FF),
                        size: 32,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pharmacy["name"],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "📍 ${pharmacy["location"]}",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "☎ ${pharmacy["phone"]}",
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      children: [
                        IconButton(
                          tooltip: "Open Map",
                          icon: const Icon(
                            Icons.map,
                            color: Colors.green,
                            size: 30,
                          ),
                          onPressed: () async {
                            await openMap(
                              pharmacy["lat"] as double,
                              pharmacy["lng"] as double,
                            );
                          },
                        ),
                        IconButton(
                          tooltip: "Call",
                          icon: const Icon(
                            Icons.call,
                            color: Colors.blue,
                          ),
                          onPressed: () async {
                            await callPharmacy(pharmacy["phone"]);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}