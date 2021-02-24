import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';

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
                                  //Container(
                                  //width: 200,
                                  //height: 200,
                                  //child: Image.asset(publications['imgRef']),
                                  // ),
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
                                          height: 21,
                                        ),
                                        Container(
                                          width: 150,
                                          child: Text(
                                            // "\$${(publications['description'] == null) ? "no" : publications['description']}",
                                            publications['description'],
                                            style: TextStyle(
                                              fontSize: 17,
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

//DETALLES DE LA PUBLICACION AL DAR CLICK
class DetailPage extends StatelessWidget {
  DocumentSnapshot detailDocument;
  DetailPage(this.detailDocument);

  @override
  Widget build(BuildContext context) {
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
                    height: 21,
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
                  /*ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    img,
                    width: 200,
                    height: 200,
                  ),
                ),*/
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
                    height: 20,
                  ),
                  Text(
                    detailDocument['description'],
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        detailDocument['description'],
                        maxLines: 3,
                        style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
