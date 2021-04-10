import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:pet_auxilium/widgets/ChatRoomListTile_widget.dart';
class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
    Stream chatRoomsStream;
  final preferencesUtil _prefs=preferencesUtil();
  final dbUtil _db= dbUtil();
  @override
@override
void initState() { 
  super.initState();
  _getChatRooms();
}

  Widget build(BuildContext context) {
      return Scaffold(
              body: Container(
                child: StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, snapshot) {
          print("vuil");
         // print(_prefs.userID)x;
         if(snapshot.hasData){
    return 
                ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                 
                   
                      print('Necesito tugsteno');
  return ChatRoomListTile(ds["lastMessage"], ds.id,_prefs.userID,);
                   
                    
                    });

         }
      
                else{
return Center(child: CircularProgressIndicator());

                }
        },
    ),
              ),
      );
  }
   _getChatRooms() async{
chatRoomsStream=await _db.getChatRooms();

}
}