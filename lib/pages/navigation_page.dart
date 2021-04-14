import 'package:flutter/material.dart';
import 'package:pet_auxilium/pages/account_page.dart';
import 'package:pet_auxilium/pages/chatsrooms_page.dart';
import 'package:pet_auxilium/pages/create_business_page.dart';
import 'package:pet_auxilium/pages/report_page.dart';
import 'package:pet_auxilium/pages/startup_page.dart';

import 'package:pet_auxilium/pages/publication_page.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/pages/feed_page.dart';
import 'package:pet_auxilium/utils/push_notifications_util.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final _prefs = new preferencesUtil();
  final _push = PushNotificationUtil();
  final _db =dbUtil();
  void _onItemTapped(int index) {
    if ( index != 3) {
      setState(() {
        _prefs.selectedIndex = index;
      });
    }
  }

  void _onItemTappedAdmin(int index) {
   
    setState(() {
      _prefs.selectedIndex = index;
    });
  }

  initState() {
  _push.initialise();
    super.initState();
    // _prefs.selectedIndex =0;
  }

  initToken()async{
    

  }

  final List<String> _titles = [
    'INICIO',
    'CHAT',
    'CREAR PUBLICACIÓN',
    'NOTIFICACIONES',
    'PERFIL'
  ];
  final List<String> _titlesAdmin = ['INICIO', 'REPORTES', 'PERFIL'];
  final List<Widget> _tabs = [
    // Feed(),
    StartupPage(),
    ChatRooms(),
    //Adoptionpage(),
    PublicationPage(),
    null,
    AccountPage()
  ];
  final List<Widget> _adminTabs = [StartupPage(), ReportPage(), AccountPage()];
  @override
  Widget build(BuildContext context) {
     print('este es el token ${_prefs.token}');
    return Scaffold(
      backgroundColor: Colors.white,
      //appBar: getAppbar(),
      body: _getTabs()[_prefs.selectedIndex],
      bottomNavigationBar: _getBottomBar(),
    );
  }

  List<Widget> _getTabs() {
    if (isAdmin()) {
      return _adminTabs;
    } else {
      return _tabs;
    }
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      title: _prefs.selectedIndex == 4
          ? Center(
              child: Text(
                _titles[_prefs.selectedIndex],
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _titles[_prefs.selectedIndex],
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
    );
  }

  Widget _getBottomBar() {
    print('ISADMIN');
    print(isAdmin());
    if (isAdmin()) {
      return _bottomBarAdmin();
    } else {
      return _bottomBar();
    }
  }

  bool isAdmin() {
    if (_prefs.userID == 'gmMu6mxOb1RN9D596ToO2nuFMKQ2') {
      return true;
    } else {
      return false;
    }
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
      currentIndex: _prefs.selectedIndex,
      backgroundColor: Colors.white,
      unselectedItemColor: Color.fromRGBO(210, 210, 210, 1),
      selectedItemColor: Color.fromRGBO(49, 232, 93, 1),
      onTap: _onItemTapped,
    );
  }

  Widget _bottomBarAdmin() {
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
          icon: Icon(Icons.assignment),
          label: 'Reportes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Cuenta',
        ),
      ],
      currentIndex: _prefs.selectedIndex,
      backgroundColor: Colors.white,
      unselectedItemColor: Color.fromRGBO(210, 210, 210, 1),
      selectedItemColor: Color.fromRGBO(49, 232, 93, 1),
      onTap: _onItemTappedAdmin,
    );
  }

  Widget getAppbar() {
    if (_prefs.selectedIndex == 0) {
      return PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: AppBar(
          elevation: 0,
        ),
      );
    } else {
      var titles = _getTitles();
      return AppBar(
        elevation: 0,
        title: _prefs.selectedIndex == 4
            ? Center(
                child: Text(
                  titles[_prefs.selectedIndex],
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  titles[_prefs.selectedIndex],
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      );
    }
  }

  List<String> _getTitles() {
    if (isAdmin()) {
      return _titlesAdmin;
    } else {
      return _titles;
    }
  }
}
