import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Method to fetch IP address and user agent
  
  Future<String> getIpAddress() async {
  final response = await http.get(Uri.parse('https://api.ipify.org?format=json'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['ip'];
  } else {
    throw Exception('Failed to load IP address');
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

  //Sign in with email and password
  Future<void> signInWithEmailPassword(String emailOrUsername, String password) async {
  // Fetch user by email or username
  final user = await _supabase
      .from('users')
      .select()
      .or('email.eq.$emailOrUsername,username.eq.$emailOrUsername')
      .maybeSingle();

  if (user == null) {
    throw Exception('User not found.');
  }

  // Validate the password
  final isPasswordValid = BCrypt.checkpw(password, user['password_hash']);
  if (!isPasswordValid) {
    throw Exception('Invalid credentials.');
  }

  final ipAddress = await getIpAddress();

  // Generate session token (UUID or custom logic)
  final sessionToken = DateTime.now().millisecondsSinceEpoch.toString();
    await _supabase.from('user_sessions').insert({
      'user_id': user['id'],
      'session_token': sessionToken,
      'ip_address': ipAddress,
      'expires_at': DateTime.now().add(Duration(days: 7)).toIso8601String(),
    });
}
  
  
  //Sign up with email and password
  Future<void> signUpWithEmailPassword(String username, String email, String password) async {
  // Hash the password using bcrypt
  final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

  // Check if email or username already exists
  final existingUser = await _supabase
      .from('users')
      .select()
      .or('email.eq.$email,username.eq.$username')
      .maybeSingle();

  if (existingUser != null) {
    throw Exception('Email or Username already exists.');
  }

  // Insert the user into the 'users' table
  await _supabase.from('users').insert({
    'username': username,
    'email': email,
    'password_hash': hashedPassword,
    'created_at': DateTime.now().toIso8601String(),
  });
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