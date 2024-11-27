import 'package:flutter/material.dart';

class AccommodationPage extends StatelessWidget {
  AccommodationPage({super.key});
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Search for Accommodation',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Location',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _checkInController,
            decoration: const InputDecoration(
              labelText: 'Check-in Date (YYYY-MM-DD)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _checkOutController,
            decoration: const InputDecoration(
              labelText: 'Check-out Date (YYYY-MM-DD)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Simulate searching for accommodation
              final location = _locationController.text;
              final checkIn = _checkInController.text;
              final checkOut = _checkOutController.text;
              if (location.isNotEmpty && checkIn.isNotEmpty && checkOut.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Searching for accommodation in $location')),
                );
                _locationController.clear();
                _checkInController.clear();
                _checkOutController.clear();
              }
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}