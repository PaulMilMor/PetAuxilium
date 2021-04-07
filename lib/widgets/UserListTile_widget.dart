import 'package:flutter/material.dart';
import 'package:pet_auxilium/pages/chatscreen_page.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';

class UserListTile extends StatelessWidget {
  UserListTile({this.id, this.imgUrl, this.name, this.username, this.email});
  final String imgUrl, name, username, email, id;
  final dbUtil _db = dbUtil();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: (){

         var myId = preferencesUtil().userID;
    var chatRoomId = _getChatRoomIdByIds(myId, this.id);
    Map<String, dynamic> chatRoomInfoMap = {
      "users": [myId, this.id]
    };
    _db.createChatRoom(chatRoomId, chatRoomInfoMap);
    Navigator.popUntil(context, (route) => true);
    
     Navigator.of(context).push(
    
       MaterialPageRoute(
   
         builder: (context) => ChatScreenPage(this.id, this.name,)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical:8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(imgUrl,height: 40,width: 40,),
            ),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),Text(email)
              ],
            )
          ],
        ),
      ),
    );
  }

 

  _getChatRoomIdByIds(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
