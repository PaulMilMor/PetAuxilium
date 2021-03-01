import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pet_auxilium/pages/feed_page.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];
//lista
List<String> _lista = new List<String>();

class DetailPage extends StatefulWidget {
  //DetailPageState createState() => DetailPageState();
  DocumentSnapshot detailDocument;
  DetailPage(this.detailDocument);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<PublicationModel> ad = List<PublicationModel>();

  final db = dbUtil();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    getImages();
   
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
      
       builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        return CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      initialPage: 2,
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
     ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.detailDocument['name'],
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
                    widget.detailDocument['category'],
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
                    widget.detailDocument['pricing'],
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    widget.detailDocument['location'].toString(),
                    style: TextStyle(
                      fontSize: 15,
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
                        widget.detailDocument['description'],
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
print(widget.detailDocument.id);
return _lista=await db.getAllImages(widget.detailDocument.id);
  //     ad.imgRef.forEach((element) {
  //       // if (detailDocument['imgRef'].contains(element)) {
  //       _lista.add(element);
  //       // } else {
  //       // _lista = [];
  //       // }

  //   // setState(() {});
   }
   Widget getCarousel(){
     FutureBuilder(
       future: getImages(),
      
       builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        return CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      initialPage: 2,
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
