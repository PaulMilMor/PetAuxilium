import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/utils/push_notifications_util.dart';

import 'package:random_string/random_string.dart'; 
class ChatScreenPage extends StatefulWidget {
   final String id, name;
  ChatScreenPage(this.id, this.name);
 
  @override
  _ChatScreenPageState createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {
  String userImg=" ";
 String token='';
  String messageId='';
  Stream messageStream;
  final preferencesUtil _prefs=preferencesUtil();
  final dbUtil _db=dbUtil();
  final _pushUtil=PushNotificationUtil();
String chatRoomId;
TextEditingController messageTextEdittingController = TextEditingController();
@override
void initState() {
  _getUserInfo(); 
  super.initState();
  chatRoomId=getChatRoomIdByIds();
   getAndSetMessages();
}
  getAndSetMessages() async {
    messageStream = await _db.getChatRoomMessages(chatRoomId);
    setState(() {});
  }


 _getUserInfo() async{
 
 DocumentSnapshot document= await _db.getUserById(widget.id);

   token=document.data()["token"];
 

 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          //     ClipRRect(
          //   borderRadius:BorderRadius.circular(30),
          //   child:Image.network(
          //     widget.urlImg,
          //     height:40,
          //     width:40
          //   )
          // ),
            Text(widget.name),
          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageTextEdittingController,
                      // onChanged: (value) {
                      //   addMessage(false);
                      // },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Escribe lo que quieras decir hdtpsm",
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.6))),
                    )),
                    GestureDetector(
                      onTap: () {
                        addMessage(true);
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
 String  getChatRoomIdByIds() {
   String a=_prefs.userID;
   String b=widget.id;
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

 Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              
              decoration: BoxDecoration(
            
                borderRadius: BorderRadius.only(
                  
                  topLeft: Radius.circular(24),
                  bottomRight:
                      sendByMe ? Radius.circular(0) : Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft:
                      sendByMe ? Radius.circular(24) : Radius.circular(0),
                ),
                
                color: sendByMe ? Color.fromRGBO(49, 232, 93, 1) : Color(0xfff1f0f0),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                message,
                style: sendByMe ? TextStyle(color: Colors.white):TextStyle(color:Colors.black),
              )),
        ),
      ],
    );
  }
    Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMessageTile(
                      ds["message"], _prefs.userID == ds["sendBy"]);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }
addMessage(bool sendClicked)async{
 if(messageTextEdittingController.text!=""){
   String msg =messageTextEdittingController.text;
   var lastMessageTs=DateTime.now();
   Map<String,dynamic> messageInfoMap={
       "message":msg,
       "sendBy":_prefs.userID,
       "ts":lastMessageTs,
       "imgUrl":_prefs.userImg
   };
   if(messageId==""){
     messageId=randomAlphaNumeric(12);
   }
   await _db.addMessage(chatRoomId, messageId, messageInfoMap).then((value){
       Map<String,dynamic> lastMessageInfoMap={
          "lastMessage":msg,
          "lastMessageSendTs":lastMessageTs,
          "lastMessageSendBy":_prefs.userID
       };
       _db.updateLastMessageSend(chatRoomId, lastMessageInfoMap);
  if (sendClicked) {
      
          _pushUtil.sendChatMensagge(_prefs.userID, _prefs.userName,msg, token);
          messageTextEdittingController.text = "";
        
          messageId = "";
        }
   });
   
 }
}
}