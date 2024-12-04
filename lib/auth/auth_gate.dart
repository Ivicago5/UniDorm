/*

AUTH GATE - Constantly listen for auth state changes


--------------------------------------------------------------


unauthenticated -> LoginPage
authenticated -> Profile Page


*/


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../pages/login_page.dart';
import '../pages/profile_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkActiveSession(),
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

  Future<bool> checkActiveSession() async {
  final supabase = Supabase.instance.client;

  // Check session based on session_token (store it in secure storage on login)
  final sessionToken = await getSessionToken(); // Retrieve from secure storage

  if (sessionToken == null) return false;

  try {
    final response = await supabase
        .from('user_sessions')
        .select()
        .eq('session_token', sessionToken)
        .maybeSingle(); // Returns `null` if no record is found

    if (response == null || DateTime.parse(response['expires_at']).isBefore(DateTime.now())) {
      return false;
    }

    return true;
  } catch (e) {
    
    return false;
  }
}

  Future<String?> getSessionToken() async {
    // Implement secure storage to persist session tokens
    // Example: Using flutter_secure_storage
    return null; // Placeholder
  }
}
