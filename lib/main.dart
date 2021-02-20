import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/pages/adoption_page.dart';
import 'package:pet_auxilium/pages/create_business_page.dart';
import 'package:pet_auxilium/pages/home_page.dart';
import 'package:pet_auxilium/pages/map_page.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs= preferencesUtil();
    prefs.initPrefs();
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: myTheme(),
      initialRoute: 'AdoptionPage',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'AdoptionPage' :(BuildContext context)=>Adoptionpage(),
        //'map':(BuildContext context)=>MapPage()
        },
    );
  }

  ThemeData myTheme() {
    final accentColor = Color.fromRGBO(49, 232, 93, 1);
    final primaryColor = Colors.white;
    final altColor = Color.fromRGBO(210, 210, 210, 1);
    return ThemeData(
      iconTheme: IconThemeData(color: accentColor),
      primaryColor: primaryColor,
      accentColor: primaryColor,
    buttonTheme: ButtonThemeData(buttonColor: accentColor, textTheme: ButtonTextTheme.accent)
    );
  }
}
