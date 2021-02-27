import 'package:flutter/material.dart';
import 'package:pet_auxilium/pages/account_page.dart';
import 'package:pet_auxilium/pages/create_business_page.dart';

import 'package:pet_auxilium/pages/publication_page.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/src/pages/feed.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;
  final _prefs = new preferencesUtil();
  void _onItemTapped(int index) {
    if (index != 1 && index != 3) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final List<String> _titles = [
    'INICIO',
    'CHAT',
    'CREAR PUBLICACIÓN',
    'NOTIFICACIONES',
    'PERFIL'
  ];
  final List<Widget> _tabs = [
    Feed(),
    null,
    //Adoptionpage(),
    PublicationPage(),
    CreateBusinessPage(),
    AccountPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: _tabs[_selectedIndex],
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      title: _selectedIndex == 4
          ? Center(
              child: Text(
                _titles[_selectedIndex],
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _titles[_selectedIndex],
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
    );
  }

  Widget _bottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 35,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box),
          label: 'Nuevo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notificaciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Cuenta',
        ),
      ],
      currentIndex: _selectedIndex,
      backgroundColor: Colors.white,
      unselectedItemColor: Color.fromRGBO(210, 210, 210, 1),
      selectedItemColor: Color.fromRGBO(49, 232, 93, 1),
      onTap: _onItemTapped,
    );
  }
}
