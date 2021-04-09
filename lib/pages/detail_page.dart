import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/pages/chatscreen_page.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/maps_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/widgets/ChatRoomListTile_widget.dart';
import 'package:pet_auxilium/widgets/opinions_widget.dart';
import 'package:pet_auxilium/widgets/comments_widget.dart';

class DetailPage extends StatefulWidget {
  PublicationModel detailDocument;
  DetailPage(this.detailDocument);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<PublicationModel> ad = [];

  final _db = dbUtil();
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
                  child: CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [
                      _appBar(widget.detailDocument.name),

                      /*SliverAppBar(
                        pinned: true,
                        snap: false,
                        floating: false,
                        elevation: 1,
                        expandedHeight: 300,
                        leading: IconButton
                      ),*/
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
                                SizedBox(
                                  width: 52,
                                ),
                                  if ( widget.detailDocument.category.toString().contains('CUIDADOR'))  GestureDetector(
                                  onTap: _chats(),
                                  child:Icon(Icons.chat))
                              ],
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
        ) /*;}
            });*/
        //}
        );
    /*)
        );*/
  }

  Widget _appBar(String name) {
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      elevation: 1,
      expandedHeight: 350,
      actions: [
        //TODO: Actualmente se muestran los 3 puntitos pero no hacen nada
        if (_prefs.userID != ' ')
          PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: Color.fromRGBO(210, 210, 210, 1),
              ),
              itemBuilder: (BuildContext context) => []),
      ],
      leading: IconButton(
        icon: new Icon(
          Icons.arrow_back_ios,
          color: Color.fromRGBO(49, 232, 93, 1),
        ),
        onPressed: () => Navigator.of(context).pop(),
        iconSize: 32,
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(name,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        background: _setCarousel(),
        centerTitle: true,
      ),
    );
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
    if (widget.detailDocument.category.toString().contains('CUIDADOR')) {
      return Opinions(
          id: widget.detailDocument.id,
          category: widget.detailDocument.category,
          sumscore: widget.detailDocument.score,
          nevaluations: widget.detailDocument.nevaluations,
          pricing: widget.detailDocument.pricing,
          description: widget.detailDocument.description);
    } else {
      return Comments(
        id: widget.detailDocument.id,
        category: widget.detailDocument.category,
        description: widget.detailDocument.description,
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
      var myId = _prefs.userID;
    var chatRoomId = _getChatRoomIdByIds(myId, widget.detailDocument.userID);
    Map<String, dynamic> chatRoomInfoMap = {
      "users": [myId,widget.detailDocument.userID]
    };
    _db.createChatRoom(chatRoomId, chatRoomInfoMap);
  //  Navigator.popUntil(context, (route) => true);
  
  //    Navigator.of(context).push(
    
  //      MaterialPageRoute(
   
  //        builder: (context) => ChatScreenPage(widget.detailDocument.userID,widget.detailDocument.name)));
  }
 _getChatRoomIdByIds(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
