import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp() );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uni Dorm',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
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
          const TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Your Email Address",
              prefixIcon: Align(heightFactor: 5.0 , widthFactor: 100.0,), icon: Icon(Icons.mail,color: Colors.black,)
            ),
          ),
          const SizedBox(
            height: 26.0,
          ),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Your Password",
              prefixIcon: Align(heightFactor: 5.0 ,widthFactor: 1.0,), icon: Icon(Icons.lock,color: Colors.black,)
            ),
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
            child: Container(
            width: 600.0,
            child: RawMaterialButton(
              fillColor: Colors.blueAccent,
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)
              ),
              onPressed: () {},
               child: const Text("Login"),
            ),
          ) ,
          )
          
          
        ],
      ),
    ); 
  }
}
