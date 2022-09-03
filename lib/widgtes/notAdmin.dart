import 'package:flutter/material.dart';
import 'package:ta_pago/widgtes/list_widgtes/profile_configuration.dart';
import 'package:ta_pago/widgtes/viewVideos.dart';
import 'Ranking.dart';

import 'alunos.dart';
import 'chat.dart';
import 'list_widgtes/addVideos.dart';

class NotAdmin extends StatefulWidget {
  const NotAdmin({Key? key}) : super(key: key);

  @override
  State<NotAdmin> createState() => _NotAdminState();
}

class _NotAdminState extends State<NotAdmin> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    ViewVideos(),
    Chat(),
    Ranking(),
    ProfileConfigurations(),
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
            label: 'Videos',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Bate Papo',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart),
            label: 'Ranking',
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
