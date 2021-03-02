import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pet_auxilium/pages/feed_page.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:geocoding/geocoding.dart';

//lista
List<String> _lista = new List<String>();
String _address = "";

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
    final value3 = values[2];
    final latitude2 = latitude.replaceAll(RegExp(','), '');
    var lat = num.tryParse(latitude2)?.toDouble();
    var long = num.tryParse(longitude)?.toDouble();

    print(latitude2);

    getAddress(lat, long);

    return Container(
        child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(30),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  Positioned(
                    right: 0.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
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
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  FutureBuilder(
                    future: getImages(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
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
                                      child: Image.network(
                                    element,
                                    fit: BoxFit.cover,
                                    width: 1000,
                                    height: 900,
                                  )),
                                ))
                            .toList(),
                      );
                    },
                  ),
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
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    _address,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        detailDocument['description'],
                        //maxLines: 3,
                        style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  Future<List<String>> getImages() async {
// detailDocument['imgRef'].toString().split(',').forEach((element) {
// final newValue =element.replaceAll('[http', 'http').replaceAll(']', '');

//  _lista.add(newValue);
//  });
    print(detailDocument.id);
    return _lista = await db.getAllImages(detailDocument.id);
    //     ad.imgRef.forEach((element) {
    //       // if (detailDocument['imgRef'].contains(element)) {
    //       _lista.add(element);
    //       // } else {
    //       // _lista = [];
    //       // }

    //   // setState(() {});
  }

  void getAddress(
    lat,
    long,
  ) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(lat, long);
    Placemark placeMark = newPlace[0];
    String name = placeMark.name;
    String subLocality = placeMark.subLocality;
    String locality = placeMark.locality;
    String administrativeArea = placeMark.administrativeArea;
    String postalCode = placeMark.postalCode;
    String country = placeMark.country;
    String address =
        "$name, $subLocality, $locality, $administrativeArea, $postalCode";

    print(address);

    //setState(() {
    _address = address; // update _address
    //});
  }
}
