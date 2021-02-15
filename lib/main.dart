import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: myTheme(),
      initialRoute: '/',
      routes: {'/': (BuildContext context) => HomePage()},
    );
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
