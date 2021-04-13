import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Application extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Application();
}

class _Application extends State<Application> {
  @override
  void initState() async {
    super.initState();

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    // if (initialMessage?.data['type'] == 'chat') {
    //   Navigator.pushNamed(context, '/chat',
    //       arguments: ChatArguments(initialMessage));
    // }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   if (message.data['type'] == 'chat') {
    //     Navigator.pushNamed(context, '/chat',
    //         arguments: ChatArguments(message));
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Text("...");
  }
}
