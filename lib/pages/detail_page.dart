import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/widgets/opinions_widget.dart';
import 'package:pet_auxilium/widgets/comments_widget.dart';

List<String> _lista = [];

class DetailPage extends StatefulWidget {
  DocumentSnapshot detailDocument;
  DetailPage(this.detailDocument);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<PublicationModel> ad = [];

  final _db = dbUtil();

  final MapsUtil _mapsUtil = MapsUtil();
  double avgscore;

  @override
  void initState() {
    super.initState();
    setState(() {
      avgscore = widget.detailDocument['score'] /
          widget.detailDocument['nevaluations'];
    });
  }
 
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
                  padding: EdgeInsets.all(1),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 45,
                      ),
                      _setBackIcon(context),
                      SizedBox(
                        height: 24,
                      ),
                      _setCarousel(),
                      SizedBox(
                        height: 17,
                      ),
                      Text(
                        widget.detailDocument['name'],
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.detailDocument['category'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      const Divider(
                        color: Colors.black45,
                        height: 5,
                        thickness: 1,
                        indent: 50,
                        endIndent: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                   //  _serviceNumbers(),
                      _mapsUtil.getLocationText(
                          widget.detailDocument['location'].first),
                   
                      
                      _bottomSection(),
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
    print(widget.detailDocument.id);
    return _lista = await _db.getAllImages(widget.detailDocument.id);
  }
 
  Widget _setBackIcon(context2) {
    return Positioned(
        right: 0.0,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context2).pop();
          },
          child: Align(
            alignment: Alignment(-0.9, -0.5),
            child: CircleAvatar(
              radius: 14.0,
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back, color: Colors.green),
            ),
          ),
        ));
  }

  _bottomSection() {
   
    if (widget.detailDocument['category'].toString().contains('CUIDADOR')) {
      return Opinions(
          id: widget.detailDocument.id,
          category: widget.detailDocument['category'],
          sumscore: widget.detailDocument['score'],
          nevaluations:widget.detailDocument['nevaluations'],
          pricing: widget.detailDocument['pricing'],
          description: widget.detailDocument['description']
          );
    } else {
      return Comments(
          id: widget.detailDocument.id,
          category: widget.detailDocument['category'],
          description: widget.detailDocument['description'],
          );
    }
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
                            fit: BoxFit.cover, width: 300)),
                  ))
              .toList(),
        );
      },
    );
  }
}
