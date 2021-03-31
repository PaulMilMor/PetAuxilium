import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/models/report_model.dart';
import 'package:pet_auxilium/pages/following_page.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';

import 'button_widget.dart';

class ListFeed extends StatefulWidget {
  ListFeed(
      {
      //this.itemCount,
      @required this.snapshot,
      this.follows,
      this.voidCallback,
      this.category,
      this.physics});

  final VoidCallback voidCallback;
  AsyncSnapshot<QuerySnapshot> snapshot;
  List<String> follows;
  String category;
  ScrollPhysics physics;
  @override
  _ListFeedState createState() => _ListFeedState();
}

class _ListFeedState extends State<ListFeed> {
  MapsUtil mapsUtil = MapsUtil();
  dbUtil _db = dbUtil();
  final _firestoreInstance = FirebaseFirestore.instance;
  final preferencesUtil _prefs = preferencesUtil();
  String nose;
  List listItems = [
    'Spam',
    'Informacion fraudulenta',
    'Suplantacion de identidad',
    'Fotos Inapropiadas'
  ];
  String _selectedReason;
  String _id;
  @override
  Widget build(BuildContext context) {
    print('POOL PREFS');
    print(_prefs.userID.toString().length);
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: this.widget.physics,
        itemCount: this.widget.snapshot.data.docs.length,
        itemBuilder: (BuildContext context, index) {
          DocumentSnapshot _data = this.widget.snapshot.data.docs[index];

          List<dynamic> _fotos = _data['imgRef'];
          String _foto = _fotos.first;
          _selectedReason = null;
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => DetailPage(_data)),
              );
            },
            child: Card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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

                          mapsUtil.getLocationText(_data['location'].first),
                          SizedBox(
                            height: 20,
                          ),
                          //Aquí está el promedio we
                          // if (_data['category'] == 'CUIDADOR')
                          //  _rating(_data['nevaluations'], _data['score']),
                          _rating(_data),
                        ],
                      )),
                  Spacer(),
                  _prefs.userID == ' '
                      ? Text('')
                      : _optionsPopup(_data.id, _data.data()),
                ],
              ),
            ),
          );
        });
  }

  _addFollow(
    String id,
  ) async {
    if (this.widget.follows.contains(id)) {
      this.widget.follows.remove(id);
    } else {
      this.widget.follows.add(id);
    }
    _db.updateFollows(this.widget.follows);
    setState(() {});
    if (this.widget.voidCallback != null) {
      this.widget.voidCallback();
    }
  }

  Widget _optionsPopup(id, publications) {
    return PopupMenuButton<int>(
        icon: Icon(
          Icons.more_vert,
          color: Color.fromRGBO(210, 210, 210, 1),
        ),
        itemBuilder: (BuildContext context) => [
              _prefs.userID == 'gmMu6mxOb1RN9D596ToO2nuFMKQ2'
                  ? null
                  : PopupMenuItem(
                      child: Column(
                        children: [
                          _isFollowedOption(id, this.widget.follows),
                        ],
                      ),
                      value: 1,
                    ),
              _prefs.userID != 'gmMu6mxOb1RN9D596ToO2nuFMKQ2'
                  ? null
                  : PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            size: 11,
                            color: Colors.grey,
                          ),
                          Text(
                            'Eliminar',
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      value: 2,
                    ),
              _prefs.userID != 'gmMu6mxOb1RN9D596ToO2nuFMKQ2'
                  ? null
                  : PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_remove_alt_1_sharp,
                            size: 11,
                            color: Colors.grey,
                          ),
                          Text(
                            'Suspender Cuenta',
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      value: 3,
                    ),
              PopupMenuItem(
                child: Column(
                  children: [_ReportOption()],
                ),
                value: 4,
              ),
            ],
        onSelected: (value) {
          switch (value) {
            case 1:
              _addFollow(id);
              break;
            case 2:
              PublicationModel selectedPublication =
                  PublicationModel.fromJsonMap(publications);

              print(publications);
              selectedPublication.id = id;
              print(selectedPublication);
              _deletePublication(id, "publications", selectedPublication);
              break;
            case 3:
              PublicationModel selectedPublication =
                  PublicationModel.fromJsonMap(publications);
              _banUser(selectedPublication.userID);
              break;
            case 4:
              _selectedReason = null;
              _id = null;
              PublicationModel selectedPublication =
                  PublicationModel.fromJsonMap(publications);
              _ReportMenu(/*publications*/);
              selectedPublication.id = id;
              _id = id;
              print(selectedPublication.id);
          }
        });
  }

  _deletePublication(id, collection, selectedPublication) {
    _db.deleteDocument(id, collection);
    if (this.widget.voidCallback != null) {
      this.widget.voidCallback();
    }
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Se eliminó la publicación'),
          action: SnackBarAction(
            label: "DESHACER",
            textColor: Color.fromRGBO(49, 232, 93, 1),
            onPressed: () {
              _db.addPublication(selectedPublication);
              this.widget.voidCallback();
            },
          ),
        ),
      );
  }

  _banUser(id) {
    Widget confirmButton = TextButton(
      child: Text("Confirmar"),
      onPressed: () async {
        print('entro adadadadad');
        await _db.banUser(id);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text("My title"),
      content: Text("¿Seguro que quiere eliminar el usuario?"),
      actions: [
        confirmButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    //_db.banUser(id);
  }

  Widget _isFollowed(String id, List<String> follow) {
    if (follow.contains(id)) {
      return Row(
        children: [
          Icon(
            Icons.remove_circle,
            size: 11,
            color: Colors.grey,
          ),
          Text(
            'Dejar de seguir ',
            style: TextStyle(fontSize: 14),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(
            Icons.add_box,
            size: 11,
            color: Colors.grey,
          ),
          Text(
            'Seguir ',
            style: TextStyle(fontSize: 14),
          ),
        ],
      );
    }
  }

  Widget _isFollowedOption(String id, List<String> follow) {
    if (follow.contains(id)) {
      return Row(
        children: [
          Icon(
            Icons.remove_circle,
            size: 11,
            color: Colors.grey,
          ),
          Text(
            'Dejar de seguir ',
            style: TextStyle(fontSize: 14),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(
            Icons.add_box,
            size: 18,
            color: Colors.grey,
          ),
          Text(
            'Seguir ',
            style: TextStyle(fontSize: 14),
          ),
        ],
      );
    }
  }

  Widget _ReportOption() {
    return Row(
      children: [
        Icon(
          Icons.flag,
          size: 18,
          color: Colors.red,
        ),
        Text(
          'Reportar',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  void _ReportMenu(/*reports*/) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: 350,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Padding(
                      //padding: const EdgeInsets.only(bottom: 42),
                      Center(
                        child: Text("Reportar",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ), //),
                      const Divider(
                        color: Colors.black45,
                        height: 5,
                        thickness: 1,
                        indent: 50,
                        endIndent: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        child: Center(
                          child: Text(
                              "¿Por qué estás reportando esta publicación?",
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 52),
                        child: Center(
                          child: GrayDropdownButton(
                            hint: Text("Selecciona el motivo"),
                            value: _selectedReason,
                            onChanged: (newValue) {
                              //prefs.adoptionCategory = newValue;
                              setState(() {
                                _selectedReason = newValue;
                              });
                            },
                            items: listItems.map((valueItem) {
                              return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: Text('Cancelar',
                                  style: TextStyle(color: Colors.black)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  List users = [];
                                  var found = false;
                                  if (_selectedReason == null) {
                                    ScaffoldMessenger.of(context)
                                      ..removeCurrentSnackBar()
                                      ..showSnackBar(SnackBar(
                                          content: Text(
                                              'Debe seleccionar un motivo')));
                                  } else {
                                    await _firestoreInstance
                                        .collection('reports')
                                        .get()
                                        .then((value) {
                                      value.docs.forEach((element) {
                                        print(element.id);
                                        if (element.id == _id) {
                                          found = true;
                                          users = element.get('userid');
                                          if (users.contains(_prefs.userID)) {
                                            ScaffoldMessenger.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Usted ya reporto esta publicación')));
                                            //print("Ya existe el usuario");
                                          } else {
                                            users.add(_prefs.userID);
                                            print(users);
                                            ReportModel update = ReportModel(
                                              publicationid: _id,
                                              userid: users,
                                            );
                                            _db.updatereport(
                                                update, _selectedReason);
                                            ScaffoldMessenger.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Se reporto esta publicación')));
                                          }
                                        }
                                      });
                                    });

                                    if (found == false) {
                                      print(users);
                                      users.add(_prefs.userID);
                                      ReportModel addreport = ReportModel(
                                        publicationid: _id,
                                        userid: users,
                                      );
                                      _db.addReport(addreport);
                                      _db.updatereport(
                                          addreport, _selectedReason);
                                      ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(SnackBar(
                                            content: Text(
                                                'Se reporto esta publicación')));
                                    }

                                    print("faros en vinagre");
                                    //Navigator.of(context).pop();
                                  }
                                  Navigator.of(context).pop();

                                },
                                child: Text('Reportar')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }


  Widget _rating(publication) {
    bool isCuidador = publication['category'] == 'CUIDADOR';
    double mean = 0;
    if (isCuidador) mean = publication['score'] / publication['nevaluations'];
    return Row(
      children: [
        if (isCuidador)
          Row(
            children: [
              Icon(
                Icons.star_rate_rounded,
                color: Color.fromRGBO(210, 210, 210, 1),
                size: 25,
              ),
              Text(
                publication['nevaluations'] == 0
                    ? 'N/A'
                    : mean.toStringAsFixed(1),
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        Icon(
          Icons.comment,
          color: Color.fromRGBO(210, 210, 210, 1),
          size: 20,
        ),
        Text(
          " ${publication["nevaluations"]}",
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
