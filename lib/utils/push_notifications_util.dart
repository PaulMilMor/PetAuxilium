import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:pet_auxilium/pages/chatscreen_page.dart';

import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';

GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> get navigationKey => _navigationKey;

//dCx573Y6RwuIlReLQAdbNl:APA91bG0yei9kNqG5QNCRV7LxqMSrLpZqsOrulWzyWn3wvMafWNzNXVtrwEqJtVPIKmT99NlhjE2p5Dvcg4-d8XPdFY122nUu9lm_SZxXqQHH65NBZss6BrgSnEofV7M5ftDwwVl0-QO
class PushNotificationUtil {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final _prefs = preferencesUtil();
  final _db = dbUtil();

  var _dataStream = StreamController<String>();
  Stream<String> get msgsStream => _dataStream.stream;
  Future initialise() async {
    await _fcm.requestNotificationPermissions();
    final token = await _fcm.getToken();
    final List<String> listNotifications=await _db.getNotificationsFuture()??[];
    await _db.updateToken(_prefs.userID, token);
//    sendFcmMessage('espero que yes', 'ojala que si');
    //sendCloseNotif('id', 'rayos en', 'xd', 'UGbWiTbD6tiPhVnQjO0g');
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
        print('message: $message');
     
       _dataStream.sink.add(message['notification']['title'] +
          ': ' +
          message['notification']['body']);
          print(_dataStream.stream.length);
    
    }, onLaunch: (Map<String, dynamic> message) async {
      var notificationData = message['data'];
      var type = notificationData['type'];
     
     
      var id = notificationData['id'];
      var name = notificationData['name'];

      _navigationKey.currentState.push(
          MaterialPageRoute(builder: (context) => ChatScreenPage(id, name)));
    }, onResume: (Map<String, dynamic> message) async {
      _dataStream.sink.add(message['notification']['title'] +
          ': ' +
          message['notification']['body']);
    });
  }

//PARA RECIBIR
  void pop() {
    return _navigationKey.currentState.pop();
  }

  dispose() {
    _dataStream?.close();
  }

  /// PARA ENVIAR
  Future<bool> sendFcmMessage(
      String title, String message, String token, data) async {
    print('entro aqui');
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAj87I27w:APA91bGCzV1p-zm4UsqgivqItNvxcVWbUdmFmAMV1hJC7s1uKicoHrH5emW0iKQtW_C9xPWonUSJFlAsr3bAAlm7evVIbhX4XrJQD6_mY6shVH1srM_R9LZO_HfC7Iqc57RpBqqZtp8C",
      };
      var request = {
        'notification': {'title': title, 'body': message},
        'data': data,
        "priority": "high",
        "to": token,
        // 'to': 'f9x3Z6QFSqKVqWfHjBdnNd:APA91bHzsHYY2RH7iBxr0vj_2Q3wBzJpK5NdYqFPpKz-W5KA-YDleXjYxmnu3M64UhUX-8fl1mHDvt4Xg1aPHvhpn80mTZlXdE8bPUc9BrjQL4ll-cBNy7SKRvuk_OENE2XwhwO3F2iy'
      };
           
      //_db.updateNotifications(title+' '+message);
      http.post(url, headers: header, body: json.encode(request));
      return true;
    } catch (e, s) {
      print(e);
      return false;
    }
  }

  Future<bool> topicMessage(
      String title, String message, String topic01, data) async {
    print('entro aqui cc');
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAj87I27w:APA91bGCzV1p-zm4UsqgivqItNvxcVWbUdmFmAMV1hJC7s1uKicoHrH5emW0iKQtW_C9xPWonUSJFlAsr3bAAlm7evVIbhX4XrJQD6_mY6shVH1srM_R9LZO_HfC7Iqc57RpBqqZtp8C",
      };
      var request = {
        'notification': {'title': 'Publicaciones que sigues', 'body': message},
        'data': data,
        //"priority": "high",
        "to": '/topics/$topic01',
        // 'to': 'f9x3Z6QFSqKVqWfHjBdnNd:APA91bHzsHYY2RH7iBxr0vj_2Q3wBzJpK5NdYqFPpKz-W5KA-YDleXjYxmnu3M64UhUX-8fl1mHDvt4Xg1aPHvhpn80mTZlXdE8bPUc9BrjQL4ll-cBNy7SKRvuk_OENE2XwhwO3F2iy'
      };
      _db.updateNotifications(message);
      http.post(url, headers: header, body: json.encode(request));
      return true;
    } catch (e, s) {
      print(e);
      return false;
    }
  }

  sendChatMensagge(id, userName, message, token) {
    var data = {

      'type': 'CHATMSG',
      'id': id,
      'name': userName
    };
    sendFcmMessage(userName, message, token, data);
  }

  sendNewOpinionNotif(id, userName, message, token) {
    var data = {
  
      'type': 'CHATMSG',
      'id': id,
      'name': userName
    };
    _db.updateNotifications(message);
    sendFcmMessage(userName, message, token, data);
    print('ALFA01' + token);
  }

  sendNewCommentNotif(id, userName, message, token) {
    var data = {
     
      'type': 'CHATMSG',
      'id': id,
      'name': userName
    };
    _db.updateNotifications(message);
    sendFcmMessage(userName, message, token, data);
  }

  sendCloseNotif(id, userName, message, topic01) {
    var data = {
 
      'type': 'FCM Message',
      'id': id,
      'name': userName
    };
    topicMessage(userName, message, topic01, data);
    print('WWWWWWWWWWWWWWWW' + topic01);
  }
}
