


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/push_notifications_util.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

final dbUtil _db = dbUtil();

class _NotificationsState extends State<NotificationsPage> {
  final preferencesUtil _prefs = preferencesUtil();
final PushNotificationUtil _pushUtil=PushNotificationUtil();
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
      appBar: AppBar(title: Text('Notificaciones'),),
        body: SingleChildScrollView(
             child: StreamBuilder(
          stream: _db.getNotifications(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot msg = snapshot.data.docs[index];
                      print(msg.data());
                      
                             return GestureDetector(

                               child: Card(
                                 child: Row(
                                   children:[
                                   
                                            Flexible(
                    flex: 5,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(msg.data()['notification'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                              
                                ),
                                overflow: TextOverflow.clip),
                          

                            SizedBox(
                              height: 5,
                            ),
                        
                          ],
                        )),
                  ),
                                   ]
                                 ),
                               ),
                             );
                   
                  
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
            ));
  }
}
