import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/pages/adoption_page.dart';
import 'package:pet_auxilium/pages/create_business_page.dart';
import 'package:pet_auxilium/pages/home_page.dart';
import 'package:pet_auxilium/pages/login_page.dart';
import 'package:pet_auxilium/pages/signup_page.dart';
import 'package:pet_auxilium/pages/navigation_page.dart';
import 'package:pet_auxilium/pages/map_page.dart';
import 'package:pet_auxilium/pages/user_map_page.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/pages/feed_page.dart';
import 'package:pet_auxilium/pages/detail_page.dart';

Future<void> main() async {
//import 'package:flutter/cloud_firestore/cloud_firestore.dart';

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = preferencesUtil();
    prefs.initPrefs();
    return GestureDetector(
      onTap: () {
        FocusScopeNode _currentFocus = FocusScope.of(context);
        _unfocus(_currentFocus);
      },
      child: MaterialApp(
        title: 'Pet Auxilium',
        debugShowCheckedModeBanner: false,
        theme: myTheme(),
        initialRoute: 'Feed',
        routes: {
          '/': (BuildContext context) => HomePage(),
          'login': (BuildContext context) => LoginPage(),
          'signup': (BuildContext context) => SignupPage(),
          'navigation': (BuildContext context) => NavigationPage(),
          'Feed': (BuildContext context) => Feed(),
          'DetailPage': (BuildContext context) => DetailPage(),
          'CreateBusiness': (BuildContext context) => CreateBusinessPage(),
          'map': (BuildContext context) => MapPage(),
          'userMap': (BuildContext context) => UserMapPage(),
          'AdoptionPage': (BuildContext context) => Adoptionpage(),
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
