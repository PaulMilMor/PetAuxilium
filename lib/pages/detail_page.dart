import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/widgets/opinions_widget.dart';

List<String> _lista = [];

class DetailPage extends StatelessWidget {
  List<PublicationModel> ad = [];
  DocumentSnapshot detailDocument;
  DetailPage(this.detailDocument);
  final _db = dbUtil();

  final MapsUtil _mapsUtil = MapsUtil();

  @override
  Widget build(BuildContext context) {
    //getImages();
    
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
                      
                      _mapsUtil
                          .getLocationText(detailDocument['location'].first),
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

                      //FIXME: Da error en las publicaciones sin comentarios
                      Opinions(
                          id: detailDocument.id,
                          category: detailDocument['category'])
                    ],
                  )))),
        ) /*;}
            });*/
        //}
        );
    /*)
        );*/
  }

  Future<List<String>> getImages() async {
    print(detailDocument.id);
    return _lista = await _db.getAllImages(detailDocument.id);
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
}
