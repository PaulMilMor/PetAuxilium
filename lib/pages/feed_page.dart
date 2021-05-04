import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/widgets/feedlist_widget.dart';
import 'package:rxdart/rxdart.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

final preferencesUtil _prefs = preferencesUtil();
final dbUtil _db = dbUtil();

class _FeedState extends State<Feed> {
  List<String> location;
  String tempLocation;
  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context).settings.name);
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(top: 7),
      child: StreamBuilder(
        //FIXME: corregir follows para anonimos
        stream: _db.getFollows(_prefs.userID),
        builder: (BuildContext context, AsyncSnapshot<List<String>> follow) {
          print(follow.data);
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Destacados',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
              _listPatreon(follow),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Divider(
                  color: Colors.black12,
                  height: 5,
                  thickness: 2,
                  indent: 30,
                  endIndent: 30,
                ),
              ),
              _listElements(follow)
            ],
          );
        },
      ),
    ));
  }

  _listElements(follow) {
    return Expanded(
      child: StreamBuilder(
          stream: _db.allFeedElements,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListFeed(
                snapshot: snapshot,
                follows: follow.data,
                voidCallback: callback,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  _listPatreon(follow) {
    return SizedBox(
      height: 150,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: StreamBuilder(
            stream: _db.PatreonFeedElements,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListFeed(
                  snapshot: snapshot,
                  follows: follow.data,
                  voidCallback: callback,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
