import 'package:flutter/material.dart';
import 'package:unidorm/auth/auth_service.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final authService = AuthService();

  void logout() async {
    try {
      await authService.signOut();

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
    catch (error) {
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Failed to log out: ${error.toString()}')),
         );
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Profile Page"),
        centerTitle: true,
        actions: [
          //logout button
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout), 
          )
        ],
      ),
    );
  }
}