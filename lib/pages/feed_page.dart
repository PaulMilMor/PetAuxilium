import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
import 'package:pet_auxilium/pages/detail_page.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PetAuxulium'),
          centerTitle: true,
        ),
        body: Container(
          child: FutureBuilder(
              future:
                  FirebaseFirestore.instance.collection('publications').get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot != null) {
                  //Retrieve `List<DocumentSnapshot>` from snapshot
                  final List<DocumentSnapshot> documents = snapshot.data.docs;

                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, index) {
                        DocumentSnapshot publications = documents[index];
                        return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DetailPage(publications)));
                              //print('hola');
                            },
                            child: Card(
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.network(
                                      publications.data()['imgRef'],
                                      width: 145,
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
                                            // "\$${(publications['description'] == null) ? "no" : publications['description']}",

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
                                            publications['location'].toString(),
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        /* Container(
                                          width: 185,
                                          child: Text(
                                            collection['descripcion'],
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[500]),
                                          ),
                                        ),*/
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
}
