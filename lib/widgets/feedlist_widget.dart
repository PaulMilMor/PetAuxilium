import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ListFeed extends StatefulWidget {
  ListFeed({
    //this.itemCount,
    this.snapshot,
    this.follows,
    this.callback,
  });
  Function callback;
  //ListFeed(this.callback);
  //int itemCount;
  AsyncSnapshot<QuerySnapshot> snapshot;
  List<String> follows;

  @override
  _ListFeedState createState() => _ListFeedState();
}

class _ListFeedState extends State<ListFeed> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: this.widget.snapshot.data.docs.length,
        itemBuilder: (BuildContext context, index) {
          DocumentSnapshot _data = this.widget.snapshot.data.docs[index];
          List<dynamic> _fotos = _data['imgRef'];
          String _foto = _fotos.first;
          List<dynamic> _locations = _data['location'];
          String _location = _locations.first;
          String _tagName = _location;
          List<String> _split = _tagName.split(',');
          Map<int, String> _values = {
            for (int i = 0; i < _split.length; i++) i: _split[i]
          };
          String _latitude = _values[0];
          String _longtitude = _values[1];
          String _value3 = _values[2];
          String _latitude2 = _latitude.replaceAll(RegExp(','), '');
          var _lat = num.tryParse(_latitude2)?.toDouble();
          var _long = num.tryParse(_longtitude)?.toDouble();
          getAddress(_lat, _long);

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => DetailPage(_data)),
              );
            },
            child: Card(
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.network(
                      _foto,
                      width: 145,
                      height: 150,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _data['name'],
                            style: TextStyle(
                              fontSize: 21,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _data['category'],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: 150,
                            child: Text(
                              _data['pricing'],
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          _getLocationText(_lat, _long),
                          SizedBox(
                            height: 34,
                          ),
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PopupMenuButton<String>(
                        //onSelected: (value) {},
                        itemBuilder: (BuildContext context) {
                          return {'No seguir'}.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child:
                                  /*Row(
                                  children: [
                                    Icon(Icons.remove_circle),
                                    Text(choice),
                                  ],
                                ),*/
                                  _isFollowed(_data.id),
                            );
                          }).toList();
                        },
                        onSelected: (value) {
                          _addFollow(_data.id);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _isFollowed(String id) {
    if (widget.follows.contains(id)) {
      return Row(
        children: [
          Icon(Icons.remove_circle),
          Text(
            'Dejar de seguir ',
            style: TextStyle(fontSize: 11),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(Icons.add_box),
          Text('Seguir', style: TextStyle(fontSize: 11)),
        ],
      );
    }
  }

  _addFollow(String id) async {
    if (widget.follows.contains(id)) {
      widget.follows.remove(id);
    } else {
      widget.follows.add(id);
    }
    dbUtil().updateFollows(widget.follows);
    setState(() {});
  }

  Future<List<Placemark>> getAddress(lat, long) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(lat, long);

    return newPlace;
  }

  Widget _getLocationText(double lat, double long) {
    if (lat == 29.115967 && long == -111.025490) {
      return Container(
        width: 150,
        child: Text(
          ' ',
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey,
          ),
        ),
      );
    } else {
      return FutureBuilder(
          future: getAddress(lat, long),
          builder:
              (BuildContext context, AsyncSnapshot<List<Placemark>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                width: 150,
                child: Text(
                  snapshot.data.first.street +
                      " " +
                      snapshot.data.first.locality,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                ),
              );
            } else {
              return Container(
                width: 150,
                child: Text(
                  ' ',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                ),
              );
            }
          });
    }
  }
}
