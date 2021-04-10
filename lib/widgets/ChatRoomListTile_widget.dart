import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/pages/chatscreen_page.dart';
import 'package:pet_auxilium/utils/db_util.dart';
String urlImg,name,userID;


class ChatRoomListTile extends StatefulWidget {
   final String lastMessage, chatRoomId, myUserID;
 
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUserID);
  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  final dbUtil _db=dbUtil();
    
 _getUserInfo() async{
 userID=widget.chatRoomId.replaceAll(widget.myUserID, "").replaceAll("_", "");
 DocumentSnapshot document= await _db.getUserById(userID);
 print(document.data());
   name=document.data()["name"];
 urlImg=document.data()["imgRef"];
 setState(() {
 
 });
 }
    @override
  void initState() {
    // TODO: implement initState
 urlImg='';
   name='';
   
   userID='';
    _getUserInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

   
    return GestureDetector(
      onTap:(){
print('dssds');
        Navigator.push(context, MaterialPageRoute(
   builder:(context)=>ChatScreenPage(userID,  name,) 
 
 ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical:8),
        child: Row(children: [
          ClipRRect(
            borderRadius:BorderRadius.circular(30),
            child:Image.network(
              urlImg,
              height:40,
              width:40
            )
          ),
          SizedBox(width:12),
          Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children:[
              Text(name, style:TextStyle(fontSize: 16)),
              SizedBox(height:3),
              Text(widget.lastMessage)
            ]
          )
        ],)),
    );

    
  }

}