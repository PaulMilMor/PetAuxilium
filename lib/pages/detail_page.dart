import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/models/report_model.dart';
import 'package:pet_auxilium/pages/chatscreen_page.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/widgets/button_widget.dart';

import 'package:pet_auxilium/widgets/opinions_widget.dart';
import 'package:pet_auxilium/widgets/comments_widget.dart';

class DetailPage extends StatefulWidget {
  PublicationModel detailDocument;
  DetailPage(this.detailDocument, this.follows, this.voidCallback);
  List<String> follows;
  final VoidCallback voidCallback;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<PublicationModel> ad = [];

  final _db = dbUtil();
  final preferencesUtil _prefs = preferencesUtil();
  final _firestoreInstance = FirebaseFirestore.instance;
  final MapsUtil _mapsUtil = MapsUtil();
  double avgscore;
  List listItems = [
    'Spam',
    'Informacion fraudulenta',
    'Suplantacion de identidad',
    'Fotos Inapropiadas'
  ];
  String _selectedReason;
  String _id;
  @override
  void initState() {
    super.initState();
    setState(() {
      avgscore =
          widget.detailDocument.score / widget.detailDocument.nevaluations;
    });
  }

  @override
  Widget build(BuildContext contex) {
    //getImages();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Material(
              type: MaterialType.transparency,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(1),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [
                      _appBar(widget.detailDocument.name),
                      SliverToBoxAdapter(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.detailDocument.category,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(
                                  width: 52,
                                ),
                                if (widget.detailDocument.category
                                    .toString()
                                    .contains('CUIDADOR'))
                                  _buttonChat()
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Divider(
                              color: Colors.black45,
                              height: 5,
                              thickness: 1,
                              indent: 50,
                              endIndent: 50,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            //  _serviceNumbers(),
                            Align(
                              alignment: Alignment.center,
                              child: _mapsUtil.getLocationText(
                                  widget.detailDocument.location.first),
                            ),

                            _bottomSection(),
                          ],
                        ),
                      ),
                    ],
                  ))),
        ));
  }

  /* Future<List<String>> getImages() async {
    print(widget.detailDocument.id);
    return _lista = await _db.getAllImages(widget.detailDocument.id);
  }
*/
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

  Widget _appBar(String name) {
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      elevation: 1,
      expandedHeight: 350,
      actions: [
        //TODO: Actualmente se muestran los 3 puntitos pero no hacen nada
        if (_prefs.userID != ' ')
          PopupMenuButton(
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
                                _isFollowedOption(widget.detailDocument.id,
                                    this.widget.follows),
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
                    _addFollow(widget.detailDocument.id);
                    break;
                  case 2:
                    PublicationModel selectedPublication =
                        widget.detailDocument;
                    //   PublicationModel.fromJsonMap(widget.detailDocument.data());

                    // print(widget.detailDocument.data());
                    selectedPublication.id = widget.detailDocument.id;
                    print(selectedPublication);
                    _deletePublication(widget.detailDocument.id, "publications",
                        selectedPublication);
                    break;
                  case 3:
                    PublicationModel selectedPublication =
                        widget.detailDocument;
                    /* PublicationModel.fromJsonMap(
                            widget.detailDocument.data());*/
                    _banUser(selectedPublication.userID);
                    break;
                  case 4:
                    List users = [];
                    _selectedReason = null;
                    _id = null;
                    PublicationModel selectedPublication =
                        widget.detailDocument;
                    //   PublicationModel.fromJsonMap(widget.detailDocument.data());
                    //_ReportMenu(/*publications*/);
                    selectedPublication.id = widget.detailDocument.id;
                    _id = widget.detailDocument.id;
                    var found = false;
                    print(selectedPublication.id);
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
                            _ReportMenu(/*publications*/);
                          }
                        }
                      });
                    });
                    if (found == false) {
                      _ReportMenu(/*publications*/);
                    }
                    print(selectedPublication.id);
                    break;
                }
              })
      ],
      leading: IconButton(
        icon: new Icon(
          Icons.arrow_back_ios,
          color: Color.fromRGBO(49, 232, 93, 1),
        ),
        onPressed: () => Navigator.of(context).pop(),
        iconSize: 32,
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(name,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        background: _setCarousel(),
        centerTitle: true,
      ),
    );
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

  Widget _isFollowedOption(String id, List<String> follow) {
    print(id);
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
          color: Colors.grey,
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
                                        print(element.id);
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
                                          // }
                                          );
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

  Widget _setBackIcon(context2) {
    return Positioned(
        right: 0.0,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context2).pop();
          },
          child: Align(
            alignment: Alignment(-0.9, -0.5),
            child: CircleAvatar(
              radius: 14.0,
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back, color: Colors.green),
            ),
          ),
        ));
  }

  _bottomSection() {
    if (widget.detailDocument.category.toString().contains('CUIDADOR') ||
        widget.detailDocument.category.toString().contains('NEGOCIO')) {
      return Opinions(
          id: widget.detailDocument.id,
          services: widget.detailDocument.services,
          category: widget.detailDocument.category,
          sumscore: widget.detailDocument.score,
          nevaluations: widget.detailDocument.nevaluations,
          pricing: widget.detailDocument.pricing,
          userID: widget.detailDocument.userID,
          description: widget.detailDocument.description,
          date: widget.detailDocument.date);
    } else {
      return Comments(
        id: widget.detailDocument.id,
        category: widget.detailDocument.category,
        description: widget.detailDocument.description,
        date: widget.detailDocument.date,
        userid: widget.detailDocument.userID,
      );
    }
  }

  Widget _setCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        initialPage: 0,
        autoPlay: false,
      ),
      items: widget.detailDocument.imgRef
          .map((element) => Container(
                child: Center(
                    child:
                        Image.network(element, fit: BoxFit.cover, width: 300)),
              ))
          .toList(),
    );
  }

  _chats() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var myId = _prefs.userID;
      var chatRoomId = _getChatRoomIdByIds(myId, widget.detailDocument.userID);
      Map<String, dynamic> chatRoomInfoMap = {
        "users": [myId, widget.detailDocument.userID]
      };
      _db.createChatRoom(chatRoomId, chatRoomInfoMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreenPage(
                    widget.detailDocument.userID,
                    widget.detailDocument.name,
                  )));
    });
  }

  _getChatRoomIdByIds(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget _buttonChat() {
    return TextButton(
      child: Icon(
        Icons.chat,
        color: Colors.grey,
      ),
      onPressed: () {
        _chats();
      },
    );
  }
}
