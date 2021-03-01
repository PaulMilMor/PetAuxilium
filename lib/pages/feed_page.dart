import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/pages/detail_page.dart';
import 'package:geocoding/geocoding.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String _address = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('publications').get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              //Retrieve `List<DocumentSnapshot>` from snapshot
              final List<DocumentSnapshot> documents = snapshot.data.docs;

              //Obtencion de la primera imagen de la lista para el feed.
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, index) {
                    DocumentSnapshot publications = documents[index];
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

                    getAddress(lat, long, _address);

                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DetailPage(publications)));
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
                                    Container(
                                      width: 150,
                                      child: Text(
                                        _address,
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
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

  void getAddress(
    lat,
    long,
    _address,
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
