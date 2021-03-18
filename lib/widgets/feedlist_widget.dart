import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/pages/following_page.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';

class ListFeed extends StatefulWidget {
  ListFeed(
      {
      //this.itemCount,
      @required this.snapshot,
      this.follows,
      this.voidCallback});

  final VoidCallback voidCallback;
  AsyncSnapshot<QuerySnapshot> snapshot;
  List<String> follows;

  @override
  _ListFeedState createState() => _ListFeedState();
}

class _ListFeedState extends State<ListFeed> {
  MapsUtil mapsUtil = MapsUtil();
  final preferencesUtil _prefs = preferencesUtil();
  @override
  Widget build(BuildContext context) {
    print('POOL PREFS');
    print(_prefs.userID.toString().length);
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: this.widget.snapshot.data.docs.length,
        itemBuilder: (BuildContext context, index) {
          DocumentSnapshot _data = this.widget.snapshot.data.docs[index];
          List<dynamic> _fotos = _data['imgRef'];
          String _foto = _fotos.first;
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
                            height: 34,
                          ),
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
    dbUtil().updateFollows(this.widget.follows);
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
                      child: _isFollowedOption(id, this.widget.follows),
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
              PopupMenuItem(
                child: Text('a'),
                value: 3,
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
              _deletePublication(id, "publications", selectedPublication);
              break;
            case 3:
              PublicationModel selectedPublication =
                  PublicationModel.fromJsonMap(publications);

              print(publications);
          }
        });
  }

  _deletePublication(id, collection, selectedPublication) {
    //FIXME: No se elimina la publicación de la vista
    dbUtil().deleteDocument(id, collection);
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
              dbUtil().addPublication(selectedPublication);
              this.widget.voidCallback();
            },
          ),
        ),
      );
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
            style: TextStyle(fontSize: 9),
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
            style: TextStyle(fontSize: 9),
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
            style: TextStyle(fontSize: 9),
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
            style: TextStyle(fontSize: 9),
          ),
        ],
      );
    }
  }
}
