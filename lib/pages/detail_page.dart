import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path/path.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:geocoding/geocoding.dart';

//lista
List<String> _lista = new List<String>();

class DetailPage extends StatelessWidget {
  List<PublicationModel> ad = List<PublicationModel>();
  DocumentSnapshot detailDocument;
  DetailPage(this.detailDocument);
  final db = dbUtil();

  @override
  Widget build(BuildContext context) {
    //getImages();
    List<dynamic> locations = detailDocument['location'];
    String location = locations.first;
    final tagName = location;
    final split = tagName.split(',');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++) i: split[i]
    };
    print(values);
    final latitude = values[0];
    final longitude = values[1];

    final latitude2 = latitude.replaceAll(RegExp(','), '');
    var lat = num.tryParse(latitude2)?.toDouble();
    var long = num.tryParse(longitude)?.toDouble();

    print(latitude2);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            child: Material(
                type: MaterialType.transparency,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(30),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 25,
                        ),
                        _setBackIcon(context),
                        SizedBox(
                          height: 25,
                        ),
                        _setCarousel(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          detailDocument['name'],
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          detailDocument['category'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        const Divider(
                          color: Colors.grey,
                          height: 5,
                          thickness: 1,
                          indent: 1,
                          endIndent: 1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          detailDocument['pricing'],
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[600],
                          ),
                        ),
                        _setLocationText(lat, long),
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                          // width: 200,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              detailDocument['description'],
                              //maxLines: 3,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[500]),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 44,
                        ),
                        _opinion(),
                      ],
                    ))))));
  }

  Future<List<String>> getImages() async {
    print(detailDocument.id);
    return _lista = await db.getAllImages(detailDocument.id);
  }

  Future<List<Placemark>> getAddress(lat, long) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(lat, long);

    return newPlace;
  }

  Widget _setBackIcon(context2) {
    return Positioned(
      right: 0.0,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context2).pop();
        },
        child: Align(
          alignment: Alignment.topLeft,
          child: CircleAvatar(
            radius: 14.0,
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.green),
          ),
        ),
      ),
    );
  }

  Widget _setCarousel() {
    return FutureBuilder(
      future: getImages(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        return CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            initialPage: 0,
            autoPlay: false,
          ),
          items: snapshot.data
              .map((element) => Container(
                    child: Center(
                        child: Image.network(element,
                            fit: BoxFit.cover, width: 1000)),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _setLocationText(lat, long) {
    return FutureBuilder(
        future: getAddress(lat, long),
        builder:
            (BuildContext context, AsyncSnapshot<List<Placemark>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: 150,
              child: Text(
                snapshot.data.first.street + " " + snapshot.data.first.locality,
                style: TextStyle(
                  fontSize: 15,
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
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            );
          }
        });
  }

  Widget _opinion() {
    if (detailDocument['category'].toString().contains('CUIDADOR')) {
      // return ListView.builder(
      //itemCount: detailDocument.length,
      // itemBuilder: (BuildContext context, index) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _makeOpinion(),

            //_opinionList(),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //_makeOpinion(),

            //_opinionList(),
          ],
        ),
      );
    }
  }

  Widget _makeOpinion() {
    return Container(
        child: Material(
            type: MaterialType.transparency,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(30),
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '0 ' + 'Opiniones',
                        //maxLines: 3,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    // cursorColor: Theme.of(context).cursorColor,
                    maxLength: 140,
                    maxLines: 1,
                    decoration: InputDecoration(
                      icon: Icon(Icons.favorite),
                      labelText: 'Label text',
                      labelStyle: TextStyle(
                        color: Color(0xFF6200EE),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6200EE)),
                      ),
                      hintText: "Escribe una opinión...",
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment(-0.7, -1.0),
                      child: RatingBar.builder(
                        initialRating: 2.5,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 24,
                        itemPadding: EdgeInsets.symmetric(horizontal: .1),
                        itemBuilder: (context, _) => Icon(Icons.star_rounded,
                            color: Colors.greenAccent[400]),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        print('PUBLICAR');
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'PUBLICAR',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    child: ListTile(
                      title: Text('Usuario'),
                      subtitle: Text('comentario'),
                    ),
                  ),
                  Container(
                    child: ListTile(
                      title: Text('Usuario'),
                      subtitle: Text('comentario'),
                    ),
                  ),
                  Container(
                    child: ListTile(
                      title: Text('Usuario'),
                      subtitle: Text('comentario'),
                    ),
                  ),
                  Container(
                    child: ListTile(
                      title: Text('Usuario'),
                      subtitle: Text('comentario'),
                    ),
                  ),
                  Container(
                    child: ListTile(
                      title: Text('Usuario'),
                      subtitle: Text('comentario'),
                    ),
                  )
                ])))));
  }
}
