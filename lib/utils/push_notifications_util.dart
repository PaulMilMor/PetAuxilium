import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:pet_auxilium/pages/chatscreen_page.dart';
import 'package:pet_auxilium/widgets/opinions_widget.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';

GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> get navigationKey => _navigationKey;

//dCx573Y6RwuIlReLQAdbNl:APA91bG0yei9kNqG5QNCRV7LxqMSrLpZqsOrulWzyWn3wvMafWNzNXVtrwEqJtVPIKmT99NlhjE2p5Dvcg4-d8XPdFY122nUu9lm_SZxXqQHH65NBZss6BrgSnEofV7M5ftDwwVl0-QO
class PushNotificationUtil {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final _prefs = preferencesUtil();
  final _db = dbUtil();

  final _dataStream = StreamController<String>.broadcast();
  Stream<String> get msgsStream => _dataStream.stream;
  Future initialise() async {
    await _fcm.requestNotificationPermissions();
    final token = await _fcm.getToken();

    await _db.updateToken(_prefs.userID, token);
//    sendFcmMessage('espero que yes', 'ojala que si');

    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print('onMessage: $message');
    }, onLaunch: (Map<String, dynamic> message) async {
      var notificationData = message['data'];
      var type = notificationData['type'];

      print(notificationData);
      var id = notificationData['id'];
      var name = notificationData['name'];
      print('tiene que ir aqui con $id y $name');
      _navigationKey.currentState.push(
          MaterialPageRoute(builder: (context) => ChatScreenPage(id, name)));
    }, onResume: (Map<String, dynamic> message) async {
      print('onMessage: $message');
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
      http.post(url, headers: header, body: json.encode(request));
      return true;
    } catch (e, s) {
      print(e);
      return false;
    }
  }

  sendChatMensagge(id, userName, message, token) {
    var data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'type': 'CHATMSG',
      'id': id,
      'name': userName
    };
    sendFcmMessage(userName, message, token, data);
    print('ALFA' + token);
  }

  sendNewOpinionNotif(id, userName, message, token) {
    var data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'type': 'CHATMSG',
      'id': id,
      'name': userName
    };
    sendFcmMessage(userName, message, token, data);
    print('ALFA01' + token);
  }

  sendNewCommentNotif(id, userName, message, token) {
    var data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'type': 'CHATMSG',
      'id': id,
      'name': userName
    };
    sendFcmMessage(userName, message, token, data);
  }
}
