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
  dbUtil _db=dbUtil();           
   @override
  void initState() {
    super.initState();
getDir();
  }

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
             location=List<String>();
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, index) {
                   
                    DocumentSnapshot publications = documents[index];
                    //Obtencion de la primera imagen de la lista para el feed
                   // getDir(publications['location']);
                   print(publications['location']);
                    List<dynamic> fotos = publications['imgRef'];
                    String foto = fotos.first;
                    
                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DetailPage(publications)),);
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
                                        publications['location'].toString(),
                                        //location[index+1]??'',
                                        style: TextStyle(
                                          fontSize: 15,
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
   
  
   
   
     Future<void> getDir() async {
     String place = "";
   FirebaseFirestore.instance.collection('publications').get().then((value) {
      
      value.docs.forEach((element) { 

         PublicationModel publication=PublicationModel.fromJsonMap(element.data());
        
         publication.location.forEach((element) async { 

              // ESTO LO probe tambien con publications['location']
        double latitude=double.parse(element.substring(0,element.indexOf(',')).trim());
        double longitude=double.parse(element.substring(element.indexOf(',')+1).trim());
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
            place=place+placemarks.first.street+" "+placemarks.first.locality+"\n";
       print(place);
         });
          location.add(place);
          print(location);
      });
       
    });
  }
}

