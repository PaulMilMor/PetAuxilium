import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/business_model.dart';

import 'package:geocoding/geocoding.dart';

import 'detail_page.dart';

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  String _service;

  TextEditingController _searchTxtController;
  String _query;

  @override
  Widget build(BuildContext context) {
    String _service = ModalRoute.of(context).settings.arguments;
    String _category = getCategory(_service);
    return Scaffold(
        appBar: AppBar(
          title: Text(_service),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 7),
          child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('publications')
                  .where('category', isEqualTo: _category)
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  //Retrieve `List<DocumentSnapshot>` from snapshot
                  final List<DocumentSnapshot> documents = snapshot.data.docs;

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
                        String tagName = location;
                        List<String> split = tagName.split(',');
                        Map<int, String> values = {
                          for (int i = 0; i < split.length; i++) i: split[i]
                        };
                        print(values);

                        String latitude = values[0];
                        String longitude = values[1];
                        String value3 = values[2];
                        String latitude2 = latitude.replaceAll(RegExp(','), '');
                        var lat = num.tryParse(latitude2)?.toDouble();
                        var long = num.tryParse(longitude)?.toDouble();

                        print(lat);

                        getAddress(lat, long);

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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        _getLocationText(lat, long),
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

  Future<List<Placemark>> getAddress(lat, long) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(lat, long);

    return newPlace;
  }

  Widget _getLocationText(double lat, double long) {
    if (lat == 29.115967 && long == -111.025490) {
      print('debio entrar aqui');
      return Container(
        width: 150,
        child: Text(
          ' ',
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey,
          ),
        ),
      );
    } else {
      print('no aqui' + lat.toString() + '  ' + long.toString());
      return FutureBuilder(
          future: getAddress(lat, long),
          builder:
              (BuildContext context, AsyncSnapshot<List<Placemark>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                width: 150,
                child: Text(
                  snapshot.data.first.street +
                      " " +
                      snapshot.data.first.locality,
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
                  ' ',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                ),
              );
            }
          });
    }
  }

  String getCategory(String service) {
    switch (service) {
      case 'Adopción':
        return 'ADOPCIÓN';
        break;
      case 'Animales\nPerdidos':
        return 'ANIMAL PERDIDO';
        break;
      case 'Animales\nCallejeros':
        return 'SITUACIÓN DE CALLE';
        break;

      default:
        return '';
    }
  }

  Widget _searchArea() {
    //_search('');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(_service),
        TextField(
          controller: _searchTxtController,
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
        _searchResults(),
        /*ListView.builder(
          itemCount: _results.length,
          itemBuilder: (BuildContext context, int index) {
            return Text(_results[index].name);
          },
        ),*/
      ],
    );
  }

  Widget _searchResults() {
    return StreamBuilder<QuerySnapshot>(
        stream: (_query != "" && _query != null)
            ? FirebaseFirestore.instance
                .collection('business')
                //estas dos condiciones son para buscar cualquier string que contenga la query
                //TODO: Hacer que la búsqueda sea insensible a Case (Mayus, minus)
                .where('name', isGreaterThanOrEqualTo: _query)
                .where('name', isLessThanOrEqualTo: '$_query\uF7FF')
                .snapshots()
            : FirebaseFirestore.instance.collection('business').snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data.docs[index];
                    return Text(data['name']);
                  });
        });
  }
}
