import 'dart:math';

import 'package:flutter/material.dart';
import 'package:unidorm/auth/auth_service.dart';

import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //get auth service
  final authService = AuthService();

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text; 


    //attempt login..
    try{
      await authService.signInWithEmailPassword(email, password);
    } catch (error){
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $error")));
        }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            const Text(
            "UniDorm",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              ),
            ),
           const Text(
            "Login to your profile",
            style: TextStyle(
              color: Colors.black,
              fontSize: 44.0,
              fontWeight: FontWeight.bold,
              ),
           ),
          const SizedBox(
            height: 44.0,
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              prefixIcon:Icon(Icons.mail,color: Colors.black,)
            ),
            controller: _emailController,
          ),
          const SizedBox(
            height: 26.0,
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.lock,color: Colors.black,)
            ),
            controller: _passwordController,
          ),
          const SizedBox(
            height: 12.0,
          ),
          const Text(
            "Forgot your Passowrd?",
            style: TextStyle(
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(
            height: 88.0,
          ),
            Center(
              child: SizedBox(
                width: 450.0,
                child: RawMaterialButton(
                  fillColor: Colors.blueAccent,
                  elevation: 0.0,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)
                  ),
                  onPressed: login,
                   child: const Text("Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                   ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage(),
                )),
              child:
                Center(
                  child: Text("Dont have an accound? Sign Up"),
                )
            ),
          ],
      ),
    ),
    );
  }
}
