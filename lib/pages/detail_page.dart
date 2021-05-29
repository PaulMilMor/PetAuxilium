import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:pet_auxilium/models/business_model.dart';
import 'package:pet_auxilium/models/complaint_model.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/models/report_model.dart';
import 'package:pet_auxilium/pages/chatscreen_page.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/push_notifications_util.dart';
import 'package:pet_auxilium/widgets/button_widget.dart';

import 'package:pet_auxilium/widgets/opinions_widget.dart';
import 'package:pet_auxilium/widgets/comments_widget.dart';
import 'package:pet_auxilium/widgets/optionspopup_widget.dart';

class DetailPage extends StatefulWidget {
  PublicationModel detailDocument;
  DetailPage(this.detailDocument, this.follows, this.voidCallback);
  List<String> follows;
  final VoidCallback voidCallback;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<PublicationModel> ad = [];
  final preferencesUtil _prefs = preferencesUtil();
  final MapsUtil _mapsUtil = MapsUtil();
  double avgscore;

  @override
  void initState() {
    super.initState();
    setState(() {
      avgscore =
          widget.detailDocument.score / widget.detailDocument.nevaluations;
    });
  }

  @override
  Widget build(BuildContext contex) {
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
                  child: CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [
                      _appBar(widget.detailDocument.name),
                      SliverToBoxAdapter(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.detailDocument.category,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.green,
                                  ),
                                ),
                                if (widget.detailDocument.category
                                        .toString()
                                        .contains('CUIDADOR') &&
                                    widget.detailDocument.userID !=
                                        _prefs.userID &&
                                    _prefs.userName != 'anonimo')
                                  _buttonChat()
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Divider(
                              color: Colors.black26,
                              height: 7,
                              thickness: 0.5,
                              indent: 50,
                              endIndent: 50,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            //  _serviceNumbers(),
                            Align(
                              alignment: Alignment.center,
                              child: _mapsUtil.getLocationText(
                                  widget.detailDocument.location.first),
                            ),

                            _bottomSection(),
                          ],
                        ),
                      ),
                    ],
                  ))),
        ));
  }

  Widget _appBar(String name) {
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      elevation: 5,
      expandedHeight: 330,
      actions: [
        _prefs.userID == ' '
            ? Container()
            : OptionPopup(
                publication: widget.detailDocument,
                follows: widget.follows,
                voidCallback: widget.voidCallback,
              )
      ],
      leading: IconButton(
        icon: new Icon(
          Icons.arrow_back_ios,
          color: Color.fromRGBO(30, 215, 96, 1),
        ),
        onPressed: () => Navigator.of(context).pop(),
        iconSize: 24,
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(name,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        background: _setCarousel(),
        centerTitle: true,
      ),
    );
  }

  _bottomSection() {
    if (widget.detailDocument.category.toString().contains('CUIDADOR') ||
        widget.detailDocument.category.toString().contains('NEGOCIO')) {
      return Opinions(
          id: widget.detailDocument.id,
          services: widget.detailDocument.services,
          category: widget.detailDocument.category,
          sumscore: widget.detailDocument.score,
          nevaluations: widget.detailDocument.nevaluations,
          pricing: widget.detailDocument.pricing,
          userID: widget.detailDocument.userID,
          description: widget.detailDocument.description,
          date: widget.detailDocument.date);
    } else {
      return Comments(
        id: widget.detailDocument.id,
        category: widget.detailDocument.category,
        description: widget.detailDocument.description,
        date: widget.detailDocument.date,
        userid: widget.detailDocument.userID,
      );
    }
  }

  Widget _setCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        initialPage: 0,
        autoPlay: false,
      ),
      items: widget.detailDocument.imgRef
          .map((element) => Container(
                child: Center(
                    child:
                        Image.network(element, fit: BoxFit.cover, width: 300)),
              ))
          .toList(),
    );
  }

  _chats() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //var myId = _prefs.userID;
      //    var chatRoomId = _getChatRoomIdByIds(myId, widget.detailDocument.userID);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreenPage(
                    widget.detailDocument.userID,
                    widget.detailDocument.name,
                  )));
    });
  }

  Widget _buttonChat() {
    return TextButton(
      child: Icon(
        Icons.chat,
        color: Colors.grey,
        size: 21,
      ),
      onPressed: () {
        _chats();
      },
    );
  }
}
