import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/widgets/feedlist_widget.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}
final preferencesUtil _prefs = preferencesUtil();
final dbUtil _db =dbUtil();
class _FeedState extends State<Feed> {
  List<String> location;
  String tempLocation;
  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context).settings.name);
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(top: 7),
      child: FutureBuilder(
        //FIXME: corregir follows para anonimos
        future: _db.getFollows(_prefs.userID),
        builder: (BuildContext context, AsyncSnapshot<List<String>> follow) {
          print(follow.data);
          return FutureBuilder(
              future: _db.getAllPublications(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListFeed(snapshot: snapshot, follows:follow.data);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        },
      ),
    ));
  }

  
  
}
