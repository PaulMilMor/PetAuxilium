import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/models/report_model.dart';

import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/pages/detail_page.dart';
import 'package:flutter/material.dart';

import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/push_notifications_util.dart';
import 'package:pet_auxilium/widgets/optionspopup_widget.dart';
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

  final preferencesUtil _prefs = preferencesUtil();
  final FirebaseMessaging fcm = FirebaseMessaging();
  String nose;
  List listItems = [
    'Spam',
    'Informacion fraudulenta',
    'Suplantacion de identidad',
    'Fotos Inapropiadas'
  ];

  @override
  Widget build(BuildContext context) {
    this.widget.snapshot.data.sort(
        (PublicationModel a, PublicationModel b) => b.date.compareTo(a.date));
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: this.widget.physics,
        itemCount: this.widget.snapshot.data.length,
        itemBuilder: (BuildContext context, index) {
          PublicationModel _data = this.widget.snapshot.data[index];

          List<dynamic> _fotos = _data.imgRef;
          String _foto = _fotos.first;
         
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
                      width: 100,
                      height: 100,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: Padding(
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
                  ),
                  Spacer(),
                  _prefs.userID == ' '
                      ? Text('')
                      : OptionPopup(
                          publication: _data,
                          follows: widget.follows,
                          voidCallback: widget.voidCallback,
                        )
                ],
              ),
            ),
          );
        });
  }

Widget _rating(publication) {
  bool isCuidador =
      publication.category == 'CUIDADOR' || publication.category == 'NEGOCIO';
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
}