import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/pages/edit_account_page.dart';
import 'package:pet_auxilium/pages/keeper_page.dart';
import 'package:pet_auxilium/pages/publication_page.dart';
import 'package:pet_auxilium/pages/create_business_page.dart';
import 'package:pet_auxilium/pages/home_page.dart';
import 'package:pet_auxilium/pages/login_page.dart';
import 'package:pet_auxilium/pages/map_publication_page.dart';
import 'package:pet_auxilium/pages/service_page.dart';
import 'package:pet_auxilium/pages/services_menu_page.dart';
import 'package:pet_auxilium/pages/signup_page.dart';
import 'package:pet_auxilium/pages/startup_page.dart';
import 'package:pet_auxilium/pages/navigation_page.dart';
import 'package:pet_auxilium/pages/map_page.dart';
import 'package:pet_auxilium/pages/user_map_page.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/pages/feed_page.dart';
import 'package:pet_auxilium/pages/detail_page.dart';
import 'package:pet_auxilium/pages/edit_account_page.dart';

Future<void> main() async {
//import 'package:flutter/cloud_firestore/cloud_firestore.dart';

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = preferencesUtil();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _prefs = preferencesUtil();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode _currentFocus = FocusScope.of(context);
        _unfocus(_currentFocus);
      },
      child: MaterialApp(
        title: 'Pet Auxilium',
        debugShowCheckedModeBanner: false,
        theme: myTheme(),
        //      initialRoute: '/',
        initialRoute: _prefs.userID != ' ' && _prefs.userID != null
            ? 'home'
            : 'navigation',
        routes: {
          'home': (BuildContext context) => HomePage(),
          'login': (BuildContext context) => LoginPage(),
          'signup': (BuildContext context) => SignupPage(),
          'navigation': (BuildContext context) => NavigationPage(),
          'Feed': (BuildContext context) => Feed(),
          'CreateBusiness': (BuildContext context) => CreateBusinessPage(),
          'map': (BuildContext context) => MapPage(),
          'userMap': (BuildContext context) => UserMapPage(),
          //'AdoptionPage': (BuildContext context) => Adoptionpage(),
          // 'Feed': (BuildContext context) => Feed(),
          'PublicationPage': (BuildContext context) => PublicationPage(),
          'mapPublication': (BuildContext context) => MapPagePublication(),
          'startupPage': (BuildContext context) => StartupPage(),
          'caretakerPage': (BuildContext context) => KeeperPage(),
          'service': (BuildContext context) => ServicePage(),
          'edit_account_page': (BuildContext context) => Edit_account_page(),
        },
      ),
    );
  }

//Esta función es para perder el focus en un elemento al tocar cualquier parte vacía de la app
  void _unfocus(FocusScopeNode _currentFocus) {
    if (!_currentFocus.hasPrimaryFocus && _currentFocus.focusedChild != null) {
      _currentFocus.focusedChild.unfocus();
    }
  }

  ThemeData myTheme() {
    //green
    final accentColor = Color.fromRGBO(49, 232, 93, 1);
    final primaryColor = Colors.white;
    //gray
    final altColor = Color.fromRGBO(210, 210, 210, 1);
    return ThemeData(
        iconTheme: IconThemeData(color: accentColor),
        primaryColor: primaryColor,
        accentColor: primaryColor,
        buttonTheme: ButtonThemeData(
            buttonColor: accentColor, textTheme: ButtonTextTheme.accent));
  }
}
