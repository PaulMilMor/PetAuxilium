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

enum ClosePub { option1, eliminar }

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
  var snapshot;
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
  List listItems2 = [
    'La mascota ha sido dada en adopción',
    'El animal callejero ha sido atendido',
    'La mascota ya fue localizada',
    'La denuncia ya fue atendida',
    'Deseo eliminar esta publicación',
  ];
  String _selectedReason;
  String _id;
  ClosePub _option = ClosePub.option1;

  @override
  Widget build(BuildContext context) {
    //  this.widget.snapshot.data.sort(
    //      (PublicationModel a, PublicationModel b) => b.date.compareTo(a.date));
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: this.widget.physics,
        itemCount: this.widget.snapshot.data.length,
        itemBuilder: (BuildContext context, index) {
          PublicationModel _data = this.widget.snapshot.data[index];
          print('id p ${_data.id}');
          List<dynamic> _fotos = _data.imgRef;
          String _foto = _fotos.first;
          _selectedReason = null;
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => DetailPage(
                        _data, this.widget.follows, this.widget.voidCallback)),
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
                          Text(_data.name,
                              style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis),
                          Text(
                            _data.category,
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
                              _data.pricing,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),

                          Container(
                              alignment: Alignment.centerLeft,
                              width: 171,
                              child: mapsUtil
                                  .getLocationText(_data.location.first)),
                          SizedBox(
                            height: 20,
                          ),
                          //Aquí está el promedio we
                          // if (_data['category'] == 'CUIDADOR')
                          //   _rating(_data['nevaluations'], _data['score']),
                          _rating(_data),
                        ],
                      )),
                  Spacer(),
                  _prefs.userID == ' '
                      ? Text('')
                      : _optionsPopup(_data.id, _data),
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
              PopupMenuItem(
                child: Column(
                  children: [_CloseOption()],
                ),
                value: 5,
              ),
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
        onSelected: (value) async {
          switch (value) {
            case 1:
              _addFollow(id);
              break;
            case 2:
              PublicationModel selectedPublication =
                  PublicationModel.fromJsonMap(publications, id);

              selectedPublication.id = id;
              print(selectedPublication);
              _deletePublication(id, "publications", selectedPublication);
              break;
            case 3:
              PublicationModel selectedPublication =
                  PublicationModel.fromJsonMap(publications, id);
              _banUser(selectedPublication.userID);
              break;
            case 4:
              List users = [];
              _selectedReason = null;
              _id = null;
              
              /*PublicationModel selectedPublication =
                  PublicationModel.fromJsonMap(publications, id);*/
                print(publications);
              //selectedPublication.id = id;
              _id = id;
              var found = false;

               //_ReportMenu(/*publications*/);
              await _firestoreInstance
                  .collection('reports')
                  .get()
                  .then((value) {
                value.docs.forEach((element) {
                  print(element.id);
                  if (element.id == id) {
                    found = true;

                    users = element.get('userid');
                    if (users.contains(_prefs.userID)) {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                            content:
                                Text('Usted ya reporto esta publicación')));
                      //print("Ya existe el usuario");
                    } else {
                      _ReportMenu(/*publications*/);
                    }
                  }
                });
              });
              if (found == false) {
                _ReportMenu(/*publications*/);
              }
              print(id);
              break;
            case 5:
              _ClosePubMenu(publications);
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
            '  Dejar de seguir ',
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
            '  Seguir ',
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
          color: Colors.grey,
        ),
        Text(
          '  Reportar',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _CloseOption() {
    return Row(
      children: [
        Icon(
          Icons.check,
          size: 18,
          color: Colors.grey,
        ),
        Text(
          '  Cerrar publicación',
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
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      const Divider(
                        color: Colors.black38,
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
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(49, 232, 93, 1),
                                ),
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
                                        if (element.id == _id) {
                                          found = true;
                                          users = element.get('userid');
                                          /*if (users.contains(_prefs.userID)) {
                                            ScaffoldMessenger.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Usted ya reporto esta publicación')));
                                            //print("Ya existe el usuario");
                                          } else {*/
                                          users.add(_prefs.userID);

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
                                          //}
                                          );
                                    });

                                    if (found == false) {
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
                                    //Navigator.of(context).pop();
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('Reportar'),
                                )),
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

  void _ClosePubMenu(publications) {
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
                        child: Text("Cerrar publicación",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 15,
                      ), //),
                      const Divider(
                        color: Colors.grey,
                        height: 5,
                        thickness: 1,
                        indent: 50,
                        endIndent: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        child: Center(
                          child: Text(
                              "¿Por qué quieres cerrar esta publicación?",
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          ListTile(
                            title: _optionSection(publications),
                            leading: Radio<ClosePub>(
                              value: ClosePub.option1,
                              groupValue: _option,
                              onChanged: (ClosePub value) {
                                setState(() {
                                  _option = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title:
                                const Text('Deseo eliminar esta publicación'),
                            leading: Radio<ClosePub>(
                              value: ClosePub.eliminar,
                              groupValue: _option,
                              onChanged: (ClosePub value) {
                                setState(() {
                                  _option = value;
                                });
                              },
                            ),
                          ),
                        ],
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
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(49, 232, 93, 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('Continuar'),
                                )),
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
}

_optionSection(publications) {
  String categoria = publications.category;
  switch (categoria) {
    case "ANIMAL PERDIDO":
      {
        return const Text('La mascota perdida ya ha sido localizada');
      }
      break;

    case "ADOPCIÓN":
      {
        return const Text('La mascota ya fue dada en adopción');
      }
      break;

    case "CUIDADOR":
      {
        return const Text('Al chile ya me harté de andar cuidando animales');
      }
      break;

    case "NEGOCIO":
      {
        return const Text('Ya no me interesa publicitar este negocio');
      }
      break;
    case "SITUACIÓN DE CALLE":
      {
        return const Text('El animal callejero ya ha sido atendido');
      }
      break;
    case "DENUNCIA":
      {
        return const Text('La denuncia ya ha sido atendida');
      }
      break;
  }
}

Widget _rating(publication) {
  bool isCuidador = publication.category == 'CUIDADOR';
  double mean = 0;
  if (isCuidador) mean = publication.score / publication.nevaluations;
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
              publication.nevaluations == 0 ? 'N/A' : mean.toStringAsFixed(1),
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
        " ${publication.nevaluations}",
        style: TextStyle(fontSize: 12),
      ),
    ],
  );
}
