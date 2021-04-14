import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
//dCx573Y6RwuIlReLQAdbNl:APA91bG0yei9kNqG5QNCRV7LxqMSrLpZqsOrulWzyWn3wvMafWNzNXVtrwEqJtVPIKmT99NlhjE2p5Dvcg4-d8XPdFY122nUu9lm_SZxXqQHH65NBZss6BrgSnEofV7M5ftDwwVl0-QO
class PushNotificationUtil {
  final FirebaseMessaging _fcm = FirebaseMessaging();
    final _prefs=preferencesUtil();
final _dataStream =StreamController<String>.broadcast();
Stream <String> get msgsStream=>_dataStream.stream;
  Future initialise() async {
 await _fcm.requestNotificationPermissions();
 final token= await _fcm.getToken();

  var msg= await sendFcmMessage('diganme que les llego', 'ojala que si');

 _prefs.token=token;
 

    _fcm.configure(

      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },

      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _serialiseAndNavigate(message);
      },

      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _serialiseAndNavigate(message);
      },
    );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {

    var notificationData = message['data'];
    var view = notificationData['view'];

    //Creo que deberia sustituir el mensaje
    _dataStream.add(view);
  print(view);
    if (view != null) {

  
    }
  }

  
  dispose(){
    _dataStream?.close();
  }
  static Future<bool> sendFcmMessage(String title, String message) async {
    print('entro aqui');
try {

  var url = 'https://fcm.googleapis.com/fcm/send';
  var header = {
    "Content-Type": "application/json",
    "Authorization":
        "key=AIzaSyDVB1UncyljyN7AbV8JPfbgLeHgk2RS-Z0",
  };
 var request = {
    "notification": {
      "title": title,
      "text": message,
      "sound": "default",
      "color": "#990000",
    },
    "priority": "high",
    "to": "/topics/all",
  };
  var client = new Client();
  var response =
      await client.post(url, headers: header, body: json.encode(request));
  return true;
} catch (e, s) {
  print(e);
  return false;
}
}}