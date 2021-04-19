import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String message = "";
  _onStartScroll(ScrollMetrics metrics) {
    setState(() {
      print("Scroll Start");
      message = "Scroll Start";
    });
  }

  _onUpdateScroll(ScrollMetrics metrics) {
    setState(() {
      print("Scroll Update");
      message = "Scroll Update";
    });
  }

  _onEndScroll(ScrollMetrics metrics) {
    setState(() {
      print("Scroll End");
      message = "Scroll End";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 50.0,
          color: Colors.orangeAccent,
          child: Center(
            child: Text(message),
          ),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollStartNotification) {
                _onStartScroll(scrollNotification.metrics);
              } else if (scrollNotification is ScrollUpdateNotification) {
                _onUpdateScroll(scrollNotification.metrics);
              } else if (scrollNotification is ScrollEndNotification) {
                _onEndScroll(scrollNotification.metrics);
              }
            },
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                return ListTile(title: Text("Index : $index"));
              },
            ),
          ),
        ),
      ],
    );
  }
}
