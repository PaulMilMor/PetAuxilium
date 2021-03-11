import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pet_auxilium/pages/detail_page.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/widgets/feedlist_widget.dart';

class FollowingPage extends StatefulWidget {
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  List<String>
      _follows/*= [
    '830Yobc6R1CxsoGsrrrG',
    'zpEfIbbNFKgWMivsrVjw',
    'BrXlsBwvWj3STMK53j4u',
    'CmJMGPBeGjOtM3c9DrvE',
    'MGgmkfvtdx92tl15onP4'
  ]*/
      ;
  ListFeed _listFeed;
  @override
  void initState() {
    super.initState();
    getFollows();
    //print('INIT STATE');
    //print(_follows[1]);
    _listFeed = ListFeed(callback: this.callback);
  }

  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LISTA DE SEGUIMIENTO'),
        //elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(49, 232, 93, 1),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _followedList(),
    );
  }

  /*Widget _title() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
      child: Text(
        'PUBLICAR NEGOCIO',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }*/

  Widget _followedList() {
    return _follows == null
        ? Center(
            child: CircularProgressIndicator(
            backgroundColor: Color.fromRGBO(49, 232, 93, 1),
          ))
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('publications')
                .where(FieldPath.documentId, whereIn: _follows)
                .snapshots(),
            builder: (context, snapshot) {
              //_listFeed.snapshot = snapshot;
              // _listFeed.follows = _follows;
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(child: CircularProgressIndicator())
                  : //_listFeed;
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, index) {
                        DocumentSnapshot _publications =
                            snapshot.data.docs[index];
                        List<dynamic> _fotos = _publications['imgRef'];
                        String _foto = _fotos.first;
                        List<dynamic> _locations = _publications['location'];
                        String _location = _locations.first;
                        String _tagName = _location;
                        List<String> _split = _tagName.split(',');
                        Map<int, String> _values = {
                          for (int i = 0; i < _split.length; i++) i: _split[i]
                        };
                        String _latitude = _values[0];
                        String _longtitude = _values[1];
                        String _latitude2 =
                            _latitude.replaceAll(RegExp(','), '');
                        var _lat = num.tryParse(_latitude2)?.toDouble();
                        var _long = num.tryParse(_longtitude)?.toDouble();
                        getAddress(_lat, _long);
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DetailPage(_publications)),
                            );
                          },
                          child: Card(
                            child: Stack(
                              children: [
                                Row(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _publications['name'],
                                            style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            _publications['category'],
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
                                              _publications['pricing'],
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
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    PopupMenuButton<String>(
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Color.fromRGBO(210, 210, 210, 1),
                                      ),
                                      //color: Color.fromRGBO(210, 210, 210, 1),
                                      //onSelected: (value) {},
                                      itemBuilder: (BuildContext context) {
                                        return {'No seguir'}
                                            .map((String choice) {
                                          return PopupMenuItem<String>(
                                            value: choice,
                                            child:
                                                /*Row(
                                  children: [
                                    Icon(Icons.remove_circle),
                                    Text(choice),
                                  ],
                                ),*/
                                                _isFollowed(_publications.id),
                                          );
                                        }).toList();
                                      },
                                      onSelected: (value) {
                                        _addFollow(_publications.id);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
            },
          );
  }

  getFollows() async {
    _follows = await dbUtil().getFollows();
    setState(() {});
  }

  Widget _isFollowed(String id) {
    if (_follows.contains(id)) {
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
    if (_follows.contains(id)) {
      _follows.remove(id);
    } else {
      _follows.add(id);
    }
    dbUtil().updateFollows(_follows);
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
