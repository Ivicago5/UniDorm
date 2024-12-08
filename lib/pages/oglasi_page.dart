import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ad_details_page.dart'; // Dodaj ovaj import za detaljnu stranicu

class Oglasi extends StatefulWidget {
  const Oglasi({Key? key}) : super(key: key);

  @override
  State<Oglasi> createState() => _OglasiState();
}

class _OglasiState extends State<Oglasi> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> _fetchAds() async {
  final response = await supabase.from('ads').select();

  if (response == null || response.isEmpty) {
    throw Exception('Greška prilikom učitavanja oglasa: Nema podataka.');
  }

  // Osiguranje da su podaci u formatu List<Map<String, dynamic>>
  return List<Map<String, dynamic>>.from(response as List);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Oglasi za stanove",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Greška: ${snapshot.error}'),
            );
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nema dostupnih oglasa.'),
            );
          }

          final ads = snapshot.data!;

          return ListView.builder(
            itemCount: ads.length,
            itemBuilder: (context, index) {
              final ad = ads[index];

              return GestureDetector(
                onTap: () {
                  // Navigacija na detalje oglasa
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdDetailsPage(adId: ad['id']),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Slika oglasa
                        Image.network(
                          ad['image_url'] ?? '',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8),
                        // Naslov oglasa
                        Text(
                          ad['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Cena oglasa
                        Text(
                          '${ad['price']} EUR',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Lokacija oglasa
                        Text(
                          ad['location'] ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
