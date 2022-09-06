import 'package:flutter/material.dart';
import 'package:ta_pago/widgtes/chatPage.dart';
import 'package:ta_pago/widgtes/viewVideos.dart';
import 'RankingPage.dart';
import 'alunos.dart';
import 'list_widgtes/addVideos.dart';

class IsAdmin extends StatefulWidget {
  const IsAdmin({Key? key}) : super(key: key);

  @override
  State<IsAdmin> createState() => _IsAdminState();
}

class _IsAdminState extends State<IsAdmin> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    ViewVideos(),
    AddVideos(),
    Alunos(),
    ChatPage(),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
    RankingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.purpleAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: 'Videos',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: 'Alunos',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Bate-Papo',
            backgroundColor: Colors.purple,
          ), BottomNavigationBarItem(
            icon: Icon(Icons.add_chart),
            label: 'Ranking',
            backgroundColor: Colors.purple,
          ), BottomNavigationBarItem(
            icon: Icon(Icons.lunch_dining),
            label: 'Dieta',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
