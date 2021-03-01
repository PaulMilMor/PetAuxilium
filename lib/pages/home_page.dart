import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/utils/auth_util.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/models/publication_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = dbUtil();

  final auth = AuthUtil();
  final preferencesUtil _prefs = preferencesUtil();
  UserModel user = UserModel(
      name: "fafafa",
      birthday: "16/02/99",
      pass: "adadadadad",
      email: "fafaf@hotmail.com",
      imgRef: "Fgafaf");
  @override
  void initState() {
    // TODO: implement session management
    super.initState();
    //print('USER ID');
    //print(_prefs.userID);
    /*if (_prefs.userID != ' ' && _prefs.userID != null) {
      Navigator.pushNamed(context, 'navigation');
    }*/
  }

  @override
  Widget build(BuildContext context) {
        print(ModalRoute.of(context).settings.name);
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(49, 232, 93, 1),
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _image(),
              _title(),
              _summary(),
              _buttons(),
              _anonymousLog(),
            ],
          ),
        ),
      ),
      //  body: Container(child: Icon(Icons.access_alarm_sharp))
      /*
      appBar: AppBar(
        title: Text('Home'),
      ),
    //body: Container(child:FlatButton(child: Text('prueba'),onPressed: () async => await auth.registerWithEmailAndPassword(user),))
     body: Container(child:FlatButton(child: Text('prueba'),onPressed: () async => await auth.signInWithEmailAndPassword(user.email,user.pass ),))
    //  body: Container(child:FlatButton(child: Text('prueba'),onPressed: () async => await auth.signInWithGoogle(),))
    */
    );
  }

  Widget _image() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Image.asset(
        'assets/whitelogo_asset.png',
        width: 120,
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        'PetAuxilium',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _summary() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        'La comunidad de asistencia animalista por excelencia; hazlo a tu manera, hazlo PetAuxilium®. ',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buttons() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _signUpButton(),
          _loginButton(),
        ],
      ),
    );
  }

  Widget _signUpButton() {
    return ElevatedButton(
      child: Text(
        'Registrarse',
        style: TextStyle(
          color: Color.fromRGBO(49, 232, 93, 1),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
      ),
      onPressed: () {
        Navigator.pushNamed(context, 'signup');
      },
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      child: Text('Iniciar Sesión', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(49, 232, 93, 1),
        elevation: 0,
      ),
      onPressed: () {
        Navigator.pushNamed(context, 'login');
      },
    );
  }

  Widget _anonymousLog() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, 'Feed');
        },
        child: new Text(
          'Registrarme en otro momento',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
