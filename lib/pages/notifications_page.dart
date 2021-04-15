import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

final dbUtil _db = dbUtil();

class _NotificationsState extends State<NotificationsPage> {
  final preferencesUtil _prefs = preferencesUtil();

  UserModel _user;
  void initState() {
    super.initState();
    if (_prefs.userID != ' ') {
      _user = UserModel(
        name: _prefs.userName,
        //birthday: "16/02/99",
        email: _prefs.userEmail,
        imgRef: _prefs.userImg,
      );
    } else {
      _user = UserModel(
        name: 'Usuario Anónimo',
        email: '',
        imgRef: ' ',
        //imgRef:
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Center(
              child: new Text('Notificaciones', textAlign: TextAlign.center)),
        ),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              SizedBox(height: 21),
              Center(
                child: Text(
                  'NOTIFICACIONES',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
              )
            ])));
  }
}
