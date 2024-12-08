import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdDetailsPage extends StatelessWidget {
  final String adId;

  const AdDetailsPage({Key? key, required this.adId}) : super(key: key);

  Future<Map<String, dynamic>?> _fetchAdDetails(String id) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('ads')
          .select()
          .eq('id', id)
          .single();

      return response;
    } catch (error) {
      print('Error fetching ad details: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Detalji oglasa",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchAdDetails(adId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Greška pri učitavanju oglasa.'));
          }

          final ad = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  ad['image_url'] ?? '',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  ad['title'] ?? '',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${ad['price']} EUR',
                  style: const TextStyle(fontSize: 20, color: Colors.green),
                ),
                const SizedBox(height: 8),
                Text(
                  ad['location'] ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Opis:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  ad['description'] ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Detalji:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('Broj soba: ${ad['bedrooms'] ?? 'N/A'}'),
                Text('Broj kupatila: ${ad['bathrooms'] ?? 'N/A'}'),
                Text('Kvadratura: ${ad['size'] ?? 'N/A'} m²'),
                Text('Internet: ${ad['has_internet'] == true ? 'Da' : 'Ne'}'),
                Text('Veš mašina: ${ad['has_washer'] == true ? 'Da' : 'Ne'}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
