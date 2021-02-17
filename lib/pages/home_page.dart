import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/utils/auth_util.dart';
import 'package:pet_auxilium/utils/db_util.dart';

class HomePage extends StatelessWidget {
  final db=dbUtil();
  final auth=AuthUtil();
  UserModel user=UserModel(name: "fafafa",birthday: "16/02/99", pass: "adadadadad", email: "fafaf@hotmail.com", imgRef: "Fgafaf");
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      
      appBar: AppBar(
        title: Text('Home'),
      ),
    //body: Container(child:FlatButton(child: Text('prueba'),onPressed: () async => await auth.registerWithEmailAndPassword(user),))
     body: Container(child:FlatButton(child: Text('prueba'),onPressed: () async => await auth.signInWithEmailAndPassword(user.email,user.pass ),))
    //  body: Container(child:FlatButton(child: Text('prueba'),onPressed: () async => await auth.signInWithGoogle(),))k
    );
  }
}
