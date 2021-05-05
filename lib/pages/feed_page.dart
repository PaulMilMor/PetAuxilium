import 'dart:core';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/widgets/feedlist_widget.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

final preferencesUtil _prefs = preferencesUtil();
final dbUtil _db = dbUtil();

class _FeedState extends State<Feed> {
  List<String> location;
  String tempLocation;
  List<String> orderBy = [
    'Más recientes',
    //'Más antiguas',
    'Más populares',
    'Mejor valorados',
    //'Mejor tarifa'
  ];
  String selectedOrder = 'Más recientes';
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Destacados',
                    style: TextStyle(fontSize: 25),
                  ),
                  DropdownButton(
                    //value: selectedOrder,
                    hint: Row(
                      children: [
                        Icon(Icons.sort),
                        Text(
                          'Ordenar por: $selectedOrder',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    items:
                        orderBy.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        selectedOrder = value;
                      });
                    },
                  )
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
                  orderBy: selectedOrder);
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
      height: 300,
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
