import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Validate the session token
  Future<bool> isSessionTokenValid(String? sessionToken) async {
    if (sessionToken == null) return false;

    try {
      final session = await _supabase
          .from('user_sessions')
          .select()
          .eq('session_token', sessionToken)
          .maybeSingle();

      if (session == null) return false;

      final expiryDate = DateTime.parse(session['expires_at']);
      return expiryDate.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  // Save session token to secure storage
  Future<void> saveSessionToken(String token) async {
    await _secureStorage.write(key: 'session_token', value: token);
  }

  // Get session token from secure storage
  Future<String?> getSessionToken() async {
    return await _secureStorage.read(key: 'session_token');
  }

  // Delete session token from secure storage
  Future<void> deleteSessionToken() async {
    await _secureStorage.delete(key: 'session_token');
  }

  // Method to fetch IP address

  Future<String> getIpAddress() async {
    final response = await http.get(Uri.parse('https://api.ipify.org?format=json'));

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);
      return data['ip'];

    } else {

      throw Exception('Failed to load IP address');
    }
  }
  //Sign in with email and password
  Future<void> signInWithEmailPassword(String email, String password) async {
  // Fetch user by email or username
  final user = await _supabase
      .from('users')
      .select()
      .eq('email', email)
      .maybeSingle();

  if (user == null) {
    throw Exception('User not found.');
  }

  // Validate the password
  final isPasswordValid = BCrypt.checkpw(password, user['password_hash']);
  if (!isPasswordValid) {
    throw Exception('Invalid credentials.');
  }


  final existingSession = await _supabase
        .from('user_sessions')
        .select()
        .eq('user_id', user['id'])
        .maybeSingle();

  String sessionToken;

   if (existingSession != null && await isSessionTokenValid(existingSession['session_token'])) {
      // Reuse existing valid session token
      sessionToken = existingSession['session_token'];
    } else {
      // Generate a new session token
      sessionToken = DateTime.now().millisecondsSinceEpoch.toString();
      await _supabase.from('user_sessions').insert({
        'user_id': user['id'],
        'session_token': sessionToken,
        'ip_address': await getIpAddress(),
        'expires_at': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      });
    }

    await saveSessionToken(sessionToken);
}
  
  
  //Sign up with email and password
  Future<void> signUpWithEmailPassword( String email, String password) async {
  // Hash the password using bcrypt
  final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

  // Check if email or username already exists
  final existingUser = await _supabase
      .from('users')
      .select()
      .eq('email', email)
      .maybeSingle();

  if (existingUser != null) {
    throw Exception('Email or Username already exists.');
  }

  // Insert the user into the 'users' table
  final user = await _supabase.from('users').insert({
    'email': email,
    'password_hash': hashedPassword,
    'created_at': DateTime.now().toIso8601String(),
    'is_email_confirmed': false, // Default is false
  }).select().maybeSingle();

  if (user == null) {
    throw Exception('Failed to create user.');
  }

  // Generate a confirmation token 
  final confirmationToken = DateTime.now().millisecondsSinceEpoch.toString();


  await _supabase.from('email_confirmations').insert({
    'user_id': user['id'],
    'token': confirmationToken,
    'created_at': DateTime.now().toIso8601String(),
  });

  //TODO: Send confirmation email

}

  //Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  //Get user email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

}