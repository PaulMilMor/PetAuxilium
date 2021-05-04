import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/models/report_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/push_notifications_util.dart';
import 'package:pet_auxilium/widgets/button_widget.dart';
enum ClosePub { option1, eliminar }
class OptionPopup extends StatefulWidget {
 OptionPopup({@required this.publication, this.follows,this.voidCallback});
   List<String> follows;
 PublicationModel publication;
VoidCallback voidCallback;
  @override
  _OptionPopupState createState() => _OptionPopupState();
}

class _OptionPopupState extends State<OptionPopup> {
   dbUtil _db = dbUtil();
  final _firestoreInstance = FirebaseFirestore.instance;
  final _fcm = FirebaseMessaging();
  
  final preferencesUtil _prefs = preferencesUtil();
  final FirebaseMessaging fcm = FirebaseMessaging();
    String _selectedReason;
      ClosePub _option = ClosePub.option1;
  final _pushUtil = PushNotificationUtil();
  String _msg = 'La publicación que seguías ha sido cerrada';
    List listItems = [
    'Spam',
    'Informacion fraudulenta',
    'Suplantacion de identidad',
    'Fotos Inapropiadas'
  ];
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        icon: Icon(
          Icons.more_vert,
          color: Color.fromRGBO(210, 210, 210, 1),
        ),
        itemBuilder: (BuildContext context) => [
              _prefs.userID != widget.publication.userID
                  ? null
                  : PopupMenuItem(
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
                          _isFollowedOption(widget.publication.id, this.widget.follows),
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
      PublicationModel p=widget.publication;

          switch (value) {
            case 1:
              //await _fcm.subscribeToTopic(publications.userID);
              _addFollow(p);
              break;
            case 2:

              _deletePublication(p,'publications');
              break;
            case 3:
              _banUser(p);
              break;
            case 4:
              List users = [];
              _selectedReason = null;
              var found = false;

              //_ReportMenu(/*publications*/);
              await _firestoreInstance
                  .collection('reports')
                  .get()
                  .then((value) {
                value.docs.forEach((element) {
                  if (element.id == widget.publication.id) {
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
                      _ReportMenu(p);
                    }
                  }
                });
              });
              if (found == false) {
                _ReportMenu(p);
              }
              break;
            case 5:
              _ClosePubMenu(p);
          }
        });
  }
    _addFollow(p) async {
      PublicationModel p=widget.publication;
    if (p.followers == null) p.followers = [];
    if (this.widget.follows.contains(p.id)) {
      await _fcm.unsubscribeFromTopic(p.id);
      this.widget.follows.remove(p.id);
      p.followers.remove(_prefs.userID);
    } else {
      await _fcm.subscribeToTopic(p.id);
      this.widget.follows.add(p.id);
      p.followers.add(_prefs.userID);
    }
    _db.updateFollows(this.widget.follows, p);
    //setState(() {});
    if (this.widget.voidCallback != null) {
      this.widget.voidCallback();
    }
  }

  _deletePublication(PublicationModel p, String collection) {
        _db.deleteDocument(p.id, collection);
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
              _db.addPublication(p);
              this.widget.voidCallback();
            },
          ),
        ),
      );
  }

  _banUser(PublicationModel p) {
    Widget confirmButton = TextButton(
      child: Text("Confirmar"),
      onPressed: () async {
        await _db.banUser(p.userID);
        setState(() {});
      },
    );
    AlertDialog alert = AlertDialog(
      content: Text("¿Seguro que quiere eliminar el usuario?"),
      actions: [
        confirmButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    //_db.banUser(id);
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

  void _ReportMenu(/*reports*/PublicationModel p) {
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
                                        if (element.id == p.id) {
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
                                            publicationid: p.id,
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
                                        publicationid: p.id,
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

  void _ClosePubMenu(PublicationModel p) {
    String topic01 = p.userID;

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
                                fontSize: 19, fontWeight: FontWeight.bold)),
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
                              style: TextStyle(fontSize: 15)),
                        ),
                      ),

                      Column(
                        children: <Widget>[
                          ListTile(
                            title: _optionSection(p),
                            leading: Radio<ClosePub>(
                              value: ClosePub.option1,
                              groupValue: _option,
                              activeColor: Color.fromRGBO(49, 232, 93, 1),
                              onChanged: (ClosePub value) {
                                setState(() {
                                  _option = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Deseo eliminar esta publicación',
                                style: TextStyle(fontSize: 14)),
                            leading: Radio<ClosePub>(
                              value: ClosePub.eliminar,
                              groupValue: _option,
                              activeColor: Color.fromRGBO(49, 232, 93, 1),
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
                              child: Text('Cancelar    ',
                                  style: TextStyle(color: Colors.black)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(49, 232, 93, 1),
                                ),
                                onPressed: () {
                                  if (_option == ClosePub.eliminar) {
                                    _msg = 'El usuario ' +
                                        _prefs.userName +
                                        ' ha eliminado una de sus publicaciones';
                                    _pushUtil.sendCloseNotif(
                                      _prefs.userID,
                                      _prefs.userName,
                                      _msg,
                                      topic01,
                                    );
                                  } else {
                                    if (p.category == 'ADOPCIÓN') {
                                      _msg = 'El usuario ' +
                                          _prefs.userName +
                                          ' cerró la publicación porque ' +
                                          p.name +
                                          ' fue dado en adopción :)';
                                    } else if (p.category ==
                                        'ANIMAL PERDIDO') {
                                      _msg = 'El usuario ' +
                                          _prefs.userName +
                                          ' cerró la publicación porque ' +
                                          p.name +
                                          ' ha sido encontrado ;)';
                                    } else if (p.category ==
                                        'CUIDADOR') {
                                      _msg = 'El usuario ' +
                                          _prefs.userName +
                                          ' cerró la publicación porque ya no continuará siendo cuidador';
                                    } else if (p.category ==
                                        'NEGOCIO') {
                                      _msg = 'El negocio ' +
                                          p.name +
                                          ' decidió cerrar la publicación que seguías';
                                    } else if (p.category ==
                                        'SITUACIÓN DE CALLE') {
                                      _msg = 'El usuario ' +
                                          _prefs.userName +
                                          ' cerró la publicación porque el animal callejero fue atendido';
                                    } else if (p.category ==
                                        'DENUNCIA') {
                                      _msg = 'El usuario ' +
                                          _prefs.userName +
                                          ' cerró la denuncia porque esta ya ha sido atendida/resuelta';
                                    }
                                    _pushUtil.sendCloseNotif(
                                      _prefs.userID,
                                      _prefs.userName,
                                      _msg,
                                      topic01,
                                    );
                                  }
                                  Navigator.of(context).pop();
                                  if (p.category == 'DENUNCIA') {
                                    _deletePublication(
                                        p, "complaints");
                                  } else if (p.category ==
                                      'NEGOCIO') {
                                    _deletePublication(
                                        p, "business");
                                  } else {
                                    _deletePublication(
                                        p, "publications");
                                  }
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                        content: Text(
                                            'La publicación se ha cerrado exitosamente.')));
                                  _db.updateNotifications(_msg,
                                      p.followers, p.id);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('Confirmar'),
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
        return const Text('La mascota perdida ya ha sido localizada',
            style: TextStyle(fontSize: 14));
      }
      break;

    case "ADOPCIÓN":
      {
        return const Text('La mascota ya fue dada en adopción',
            style: TextStyle(fontSize: 14));
      }
      break;

    case "CUIDADOR":
      {
        return const Text('Ya no deseo mantener mi perfil de cuidador',
            style: TextStyle(fontSize: 14));
      }
      break;

    case "NEGOCIO":
      {
        return const Text('Ya no me interesa publicitar este negocio',
            style: TextStyle(fontSize: 14));
      }
      break;
    case "SITUACIÓN DE CALLE":
      {
        return const Text('El animal callejero ya ha sido atendido',
            style: TextStyle(fontSize: 14));
      }
      break;
    case "DENUNCIA":
      {
        return const Text('La denuncia ya ha sido atendida',
            style: TextStyle(fontSize: 14));
      }
      break;
  }

}