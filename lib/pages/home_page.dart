import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/utils/auth_util.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/models/publication_model.dart';

class HomePage extends StatelessWidget {
  final db = dbUtil();
  final auth = AuthUtil();
  UserModel user = UserModel(
      name: "fafafa",
      birthday: "16/02/99",
      pass: "adadadadad",
      email: "fafaf@hotmail.com",
      imgRef: "Fgafaf");
  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  'assets/whitelogo_asset.png',
                  width: 120,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'PetAuxilium',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'La comunidad de asistencia animalista por excelencia; hazlo a tu manera, hazlo PetAuxilium®. ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
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
                    ),
                    ElevatedButton(
                      child: Text('Iniciar Sesión',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(49, 232, 93, 1),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, 'login');
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'navigation', (Route<dynamic> route) => false);
                  },
                  child: new Text(
                    'Registrarme en otro momento',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
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
}
