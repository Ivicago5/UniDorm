import 'package:flutter/material.dart';
import 'package:unidorm/pages/chat_page.dart';
import 'package:unidorm/pages/home_page.dart';
import 'package:unidorm/pages/newsletter_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {


  final List<Widget> pages = [
    const NewsletterPage(),
    const HomePage(),
    const ChatPage(),
  ];
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      appBar: AppBar(
        title: const Text("Uni Dorm"),
        backgroundColor: Colors.blueAccent,

      ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blueAccent,
          currentIndex: currentPage,
          onTap: (value){
            setState(() {
              currentPage = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.newspaper
              ),
              label: 'Newsletter'
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home
              ),
              label: 'Accomodation'
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_bubble
              ),
              label: 'Chat'
            ),
          ],
        ),
    );
  }
}