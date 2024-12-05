/*

AUTH GATE - Constantly listen for auth state changes


--------------------------------------------------------------


unauthenticated -> LoginPage
authenticated -> Profile Page


*/


import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/profile_page.dart';
import 'auth_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkActiveSession(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isAuthenticated = snapshot.data == true;
        return isAuthenticated ? ProfilePage() : LoginPage();

      },
    );
  }

  Future<bool> _checkActiveSession() async {
    final authService = AuthService();
    final sessionToken = await authService.getSessionToken();
    return await authService.isSessionTokenValid(sessionToken);
  }

}
