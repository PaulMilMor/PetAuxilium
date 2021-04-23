import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/pages/chatscreen_page.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/models/notification_model.dart';

import 'package:pet_auxilium/models/publication_model.dart';

import 'package:pet_auxilium/pages/detail_page.dart';
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
  void callback() {
    setState(() {});
  }

  final preferencesUtil _prefs = preferencesUtil();
  final PushNotificationUtil _pushUtil = PushNotificationUtil();
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
      //  _getUserInfo();
      //FIXME: WHY IS THIS A THING?
    } else {
      _user = UserModel(
        name: 'Usuario Anónimo',
        email: '',
        imgRef: ' ',
        //imgRef:
      );
    }
  }

/*_getUserInfo() async {
    DocumentSnapshot document = await _db.getUserById(widget.userid);
    token = document.data()["token"];
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notificaciones'),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: _db.getNotifications(),
            builder: (context, snapshot) {
              print('POOOOOOOOOOOOOOOL HASDATA');
              print(snapshot);
              if (snapshot.hasData) {
                print('POOOOOOOOOOOOOOOL HASDATA');
                print(snapshot.data.length);
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      NotificationModel msg = snapshot.data[index];
                      //print(msg.id);
                      print('POOOOOOOOOOL IDK');
                      print(snapshot.data);
                      return GestureDetector(
                        onTap: () async {
                          print('POOOOOOOOOOOOOOOOOOL CHAT');
                          print(msg.senderID);
                          print(msg.senderName);

                          print('dafaqw');
                          if (msg.publicationID == null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreenPage(
                                        msg.senderID, msg.senderName)));
                          } else {
                            PublicationModel _data =
                                await _db.getPublication(msg.publicationID);
                            List<String> follows =
                                await _db.getFollowsFuture(_prefs.userID);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DetailPage(_data, follows, callback)),
                            );
                          }
                        },
                        child: Card(
                          child: Row(children: [
                            Flexible(
                              flex: 5,
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          msg.notification == null
                                              ? 'what'
                                              : msg.notification,
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
                            GestureDetector(
                              child: Icon(Icons.close),
                              onTap: () {
                                _db.deleteDocument(msg.id, 'notifications');
                              },
                            )
                          ]),
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
