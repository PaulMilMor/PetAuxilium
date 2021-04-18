import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/comment_model.dart';
import 'package:pet_auxilium/pages/chatscreen_page.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/push_notifications_util.dart';

class Comments extends StatefulWidget {
  Comments(
      {@required this.id,
      @required this.category,
      @required this.description,
      @required this.date,
      @required this.userid});
  String id;
  String category;
  String description;
  DateTime date;
  String userid;
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final dbUtil _db = dbUtil();
  final preferencesUtil _prefs = preferencesUtil();
  final _pushUtil = PushNotificationUtil();
  String _userName = '', _userImg = '';
  String _comment;
  FocusNode _focusNode;

  @override
  void initState() {
    _getUserInfo();
    super.initState();
    _focusNode = FocusNode();
    _getUser();
  }

  _getUserInfo() async {
    DocumentSnapshot document = await _db.getUserById(widget.userid);
    token = document.data()["token"];
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  final prefs = new preferencesUtil();
  List<String> comments;
  String token = '';
  String msg = 'Alguien comentó sobre una de tus publicaciones';
  var _commentController = TextEditingController();
  CommentModel _myComment;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _db.getComments(this.widget.id),
        builder:
            (BuildContext context, AsyncSnapshot<List<CommentModel>> snapshot) {
          if (snapshot.hasData) {
            _checkComments(snapshot);
            return _comments(snapshot);
          } else {
            return _makeComment('0');
          }
        });
  }

//TODO: Darle formato correcto a las evaluaciones
//FIXME: Así como está, si un comentario tiene más de una linea, el
//nombre del usuario sale en vertical
  Widget _listComments(snapshot) {
    snapshot.data
        .sort((CommentModel a, CommentModel b) => a.date.compareTo(b.date));

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, index) {
          CommentModel comment = snapshot.data.elementAt(index);

          return Container(
              child: SingleChildScrollView(

                  // alignment: Alignment.topLeft,
                  child: Column(children: <Widget>[
            Container(
                height: 17,
                width: 350,
                child: Text.rich(TextSpan(
                  style: TextStyle(
                    fontSize: 13.5,
                  ),
                  children: [
                    TextSpan(
                      text: comment.username + "  ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ))),
            Container(
              width: 350,
              alignment: Alignment.topLeft,
              child: Text(comment.comment,
                  textAlign: TextAlign.justify, style: new TextStyle()),
            ),
            SizedBox(
              height: 11,
            ),
          ])));
        });
  }

  Widget _makeComment(length) {
    return Container(
        child: Material(
            type: MaterialType.transparency,
            child: Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Align(
                    alignment: Alignment.center,
                    // alignment: Alignment.center,

                    //padding: EdgeInsets.all(1),
                    child: SingleChildScrollView(
                        reverse: true,
                        child: Column(children: <Widget>[
                          prefs.userID == ' '
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Text(
                                      'Inicia sesión para unirte a la conversación.',
                                      style: TextStyle(fontSize: 16)),
                                )
                              : Container(
                                  width: 600,
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    // cursorColor: Theme.of(context).cursorColor,
                                    maxLength: 140,
                                    focusNode: _focusNode,
                                    onTap: _requestFocus,

                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.grey[400],
                                          size: 19,
                                        ),
                                        onPressed: () {
                                          _commentController.clear();
                                        },
                                      ),
                                      /*icon: Icon(
                                  Icons.comment,
                                  color: Colors.white,
                                ),*/
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      hintText: "Hacer un comentario...",
                                      contentPadding: EdgeInsets.fromLTRB(
                                          1, 17, 10, 0), // control yo
                                    ),
                                    controller: _commentController,
                                    onEditingComplete: () =>
                                        _focusNode.unfocus(),
                                  ),
                                ),
                          SizedBox(
                            height: 10,
                          ),

                          comentar_button(),

                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context)
                                      .viewInsets
                                      .bottom)),

                          Container(
                              width: 350,
                              child: Text.rich(TextSpan(
                                style: TextStyle(
                                  fontSize: 13.5,
                                ),
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.comment,
                                      color: Colors.black45,
                                      size: 17,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '  ',
                                  ),
                                  TextSpan(
                                    text: length == '1'
                                        ? length + ' Comentario'
                                        : length + ' Comentarios',
                                    //maxLines: 3,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                ],
                              ))),
                          //_opinionList(),
                        ]))))));
  }

  _getUser() async {
    DocumentSnapshot document = await _db.getUserById(widget.userid);

    _userName = document.data()["name"];
    _userImg = document.data()["imgRef"];
    setState(() {});
  }

  comentar_button() {
    if (_commentController.text.isNotEmpty) {
      return Container(
        width: 310,
        height: 30,
        child: GestureDetector(
          onTap: () {
            _comentar();
            _commentController.clear();
            _pushUtil.sendNewCommentNotif(
                prefs.userID, prefs.userName, msg, token);
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'COMENTAR',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 310,
        height: 30,
        child: GestureDetector(
          onTap: () {},
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'COMENTAR',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
  }

  void _comentar() {
    CommentModel comentar = CommentModel(
      userID: prefs.userID,
      publicationID: this.widget.id,
      username: prefs.userName,
      comment: _commentController.text,
    );
    _db.addComments(comentar);
    setState(() {});
    _addcomment(/*detailDocument.id,*/ comments);
  }

  void _addcomment(comments) async {
    if (comments.contains(this.widget.id)) {
      comments.remove(this.widget.id);
    } else {
      comments.add(this.widget.id);
    }
    _db.updateComments(comments);
  }

  Widget _comments(snapshot) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //FIXME: Así como está no muestra el número de opiniones
          SizedBox(
            height: 25,
          ),
          Container(
            width: 340,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                this.widget.description,
                //maxLines: 3,
                style: TextStyle(fontSize: 14, color: Colors.black),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: _infoRow(),
          ),
          SizedBox(
            height: 35,
          ),
          const Divider(
            color: Colors.black12,
            height: 5,
            thickness: 2,
            indent: 1,
            endIndent: 1,
          ),
          SizedBox(
            height: 10,
          ),
          _makeComment(snapshot.data.length.toString()),
          SizedBox(
            height: 10,
          ),
          if (prefs.userID != ' ') _listComments(snapshot),
          SizedBox(
            height: 350,
          ),
        ],
      ),
    );
  }

  Widget _infoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(_userImg, height: 40, width: 40)),
              SizedBox(
                width: 10,
              ),
              Text(_userName),
              _buttonChat()
            ],
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Text("Publicado el ${this.widget.date.day} de " +
              "${_getMonth(this.widget.date.month)} de " +
              "${this.widget.date.year}"),
        ),
      ],
    );
  }

  String _getMonth(month) {
    switch (month) {
      case 1:
        return 'Enero';
        break;
      case 2:
        return 'Febrero';
        break;
      case 3:
        return 'Marzo';
        break;
      case 4:
        return 'Abril';
        break;
      case 5:
        return 'Mayo';
        break;
      case 6:
        return 'Junio';
        break;
      case 7:
        return 'Julio';
        break;
      case 8:
        return 'Agosto';
        break;
      case 9:
        return 'Septiembre';
        break;
      case 10:
        return 'Octubre';
        break;
      case 11:
        return 'Noviembre';
        break;
      case 12:
        return 'Diciembre';
        break;
    }
  }

  _getChatRoomIdByIds(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  _chats() {
    //  Navigator.popUntil(context, (route) => true);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var myId = _prefs.userID;
      var chatRoomId = _getChatRoomIdByIds(myId, widget.userid);
      Map<String, dynamic> chatRoomInfoMap = {
        "users": [myId, widget.userid]
      };
      _db.createChatRoom(chatRoomId, chatRoomInfoMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreenPage(widget.userid, _userName)));
    });
  }

  Widget _buttonChat() {
    return TextButton(
      child: Icon(
        Icons.chat,
        color: Colors.grey,
      ),
      onPressed: () {
        _chats();
      },
    );
  }

  void _checkComments(snapshot) {
    for (CommentModel comment in snapshot.data) {
      if (comment.userID == prefs.userID) {
        _myComment = comment;
      }
    }
  }
}
