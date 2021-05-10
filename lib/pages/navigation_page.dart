import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/business_model.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/pages/account_page.dart';
import 'package:pet_auxilium/pages/chatsrooms_page.dart';
import 'package:pet_auxilium/pages/create_business_page.dart';
import 'package:pet_auxilium/pages/edit_business_page.dart';
import 'package:pet_auxilium/pages/edit_keeper_page.dart';
import 'package:pet_auxilium/pages/notifications_page.dart';
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

  final _db = dbUtil();
  BusinessModel myBusiness;
  PublicationModel myKeeperProfile;
  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        index = _prefs.selectedIndex;
      }
      _prefs.selectedIndex = index;
    });
  }

  void _onItemTappedAdmin(int index) {
    setState(() {
      _prefs.selectedIndex = index;
    });
  }

  initState() {
    initBusinessAndKeeper();
    _push.initialise();
    super.initState();
    // _prefs.selectedIndex =0;
  }

  initBusinessAndKeeper() async {
    myBusiness = await _db.getBusinessByUserID();
    myKeeperProfile = await _db.getKeeperByUserID();
  }

  final List<String> _titles = [
    'INICIO',
    'CHAT',
    //'CREAR PUBLICACIÓN',
    'NOTIFICACIONES',
    'PERFIL'
  ];
  final List<String> _titlesAdmin = ['INICIO', 'REPORTES', 'PERFIL'];
  final List<Widget> _tabs = [
    // Feed(),
    StartupPage(),
    ChatRooms(),

    ChatRooms(),
    //Adoptionpage(),
    //CreatePage(),
    NotificationsPage(),
    AccountPage()
  ];
  final List<Widget> _adminTabs = [StartupPage(), ReportPage(), AccountPage()];
  @override
  Widget build(BuildContext context) {
    print('este es el token ${_prefs.token}');
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        //appBar: getAppbar(),
        body: _getTabs()[_prefs.selectedIndex],
        bottomNavigationBar: _getBottomBar(),
        floatingActionButton: _addFab(),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }

  List<Widget> _getTabs() {
    if (isAdmin()) {
      return _adminTabs;
    } else {
      return _tabs;
    }
  }

  _addFab() {
    if (_prefs.userID != 'gmMu6mxOb1RN9D596ToO2nuFMKQ2') {
      return Padding(
        padding: const EdgeInsets.only(top: 55.0),
        child: FloatingActionButton(
          onPressed: () {
            _CreateMenu();
          },
          child: Icon(
            Icons.add,
          ),
          backgroundColor: Colors.white,
          foregroundColor: Color.fromRGBO(30, 215, 96, 1),
          elevation: 5.0,
          mini: true,
          shape: StadiumBorder(
            side: BorderSide(color: Color.fromRGBO(30, 215, 96, 1), width: 2),
          ),
        ),
      );
    } else {
      Container();
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
          icon: Icon(Icons.add),
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
      selectedItemColor: Color.fromRGBO(30, 215, 96, 1),
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

  void _CreateMenu() async {
    await initBusinessAndKeeper();
    String txtKeeper, txtBusiness;
    if (myKeeperProfile == null) {
      txtKeeper = "   Registrarme como cuidador";
    } else {
      txtKeeper = "   Editar perfil de cuidador";
    }
    if (myBusiness == null) {
      txtBusiness = "   Publicar mi negocio";
    } else {
      txtBusiness = "   Editar mi negocio";
    }
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
                height: 350,
                child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // PublicationPage();
                            Navigator.pushNamed(context, 'PublicationPage');
                          },
                          child: Row(children: [
                            Icon(
                              Icons.navigate_next,
                              color: Color.fromRGBO(210, 210, 210, 1),
                              size: 27,
                            ),
                            Text("   Crear una publicación",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal)),
                          ]),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            // PublicationPage();
                            if (myBusiness == null) {
                              print('POOOOOOOOOOOOOOOOOL MYBUSINESS');
                              Navigator.pushNamed(context, 'CreateBusiness');
                            } else {
                              print('POOOOOOOOOOOOOOOOOL NOTMYBUSINESS');
                              print('POOOOOOOOOOOOOL WHAT');
                              print(myBusiness.imgRef);
                              print('POOOOOOOOOOOOOL WHAT');
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EditBusinessPage(
                                            PublicationModel.fromBusiness(
                                                myBusiness))),
                              );
                            }
                          },
                          child: Row(children: [
                            Icon(
                              Icons.navigate_next,
                              color: Color.fromRGBO(210, 210, 210, 1),
                              size: 25,
                            ),
                            Text(txtBusiness,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal)),
                          ]),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            // PublicationPage();
                            if (myKeeperProfile == null) {
                              Navigator.pushNamed(context, 'caretakerPage');
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EditKeeperPage(myKeeperProfile)),
                              );
                            }
                          },
                          child: Row(children: [
                            Icon(
                              Icons.navigate_next,
                              color: Color.fromRGBO(210, 210, 210, 1),
                              size: 25,
                            ),
                            Text(txtKeeper,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal)),
                          ]),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            // PublicationPage();
                            Navigator.pushNamed(context, 'complaintPage');
                          },
                          child: Row(children: [
                            Icon(
                              Icons.navigate_next,
                              color: Color.fromRGBO(210, 210, 210, 1),
                              size: 25,
                            ),
                            Text("   Hacer una denuncia",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal)),
                          ]),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            // PublicationPage();
                            Navigator.pushNamed(context, 'donationsPage');
                          },
                          child: Row(children: [
                            Icon(
                              Icons.navigate_next,
                              color: Color.fromRGBO(210, 210, 210, 1),
                              size: 25,
                            ),
                            Text("   Apoyar asociación animalista",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal)),
                          ]),
                        ),
                      ],
                    )));
          });
        });
  }

  List<String> _getTitles() {
    if (isAdmin()) {
      return _titlesAdmin;
    } else {
      return _titles;
    }
  }
}
