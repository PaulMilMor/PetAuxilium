import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/pages/detail_page.dart';
import 'package:pet_auxilium/utils/db_util.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<String> location;
  String tempLocation;
  dbUtil _db = dbUtil();
  String _address = "";

  @override
  Widget build(BuildContext context) {
        print(ModalRoute.of(context).settings.name);
    return Scaffold(
        body: Container(
      child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('publications').get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              //Retrieve `List<DocumentSnapshot>` from snapshot
              final List<DocumentSnapshot> documents = snapshot.data.docs;
              location = List<String>();
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, index) {
                    DocumentSnapshot publications = documents[index];
                    //Obtencion de la primera imagen de la lista para el feed
                    // getDir(publications['location']);
                    print(publications['location']);
                    List<dynamic> fotos = publications['imgRef'];
                    String foto = fotos.first;

                    List<dynamic> locations = publications['location'];
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

                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DetailPage(publications)),
                          );
                        },
                        child: Card(
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Image.network(
                                  foto,
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
                                      publications['name'],
                                      style: TextStyle(
                                        fontSize: 21,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      publications['category'],
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
                                        publications['pricing'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    FutureBuilder(
                                        future: getAddress(lat, long),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<Placemark>>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            return Container(
                                              width: 150,
                                              child: Text(
                                                snapshot.data.first.street +
                                                    " " +
                                                    snapshot
                                                        .data.first.locality,
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
                                                'Direccion',
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            );
                                          }
                                        }),
                                    SizedBox(
                                      height: 34,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    ));
  }

  Future<List<Placemark>> getAddress(
    lat,
    long,
  ) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(lat, long);

    return newPlace;
  }
}
