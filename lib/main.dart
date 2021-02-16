import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/pages/home_page.dart';
import 'package:pet_auxilium/pages/login_page.dart';
import 'package:pet_auxilium/pages/signup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode _currentFocus = FocusScope.of(context);
        _unfocus(_currentFocus);
      },
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        theme: myTheme(),
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => HomePage(),
          '/login': (BuildContext context) => LoginPage(),
          '/signup': (BuildContext context) => SignupPage(),
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
    final accentColor = Color.fromRGBO(49, 232, 93, 1);
    final primaryColor = Colors.white;
    final altColor = Color.fromRGBO(210, 210, 210, 1);
    return ThemeData(
      iconTheme: IconThemeData(color: accentColor),
      primaryColor: primaryColor,
    );
  }
}
