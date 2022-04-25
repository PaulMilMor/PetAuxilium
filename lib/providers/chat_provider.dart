import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
final _instancia=dbUtil().instancia;
final _prefs=preferencesUtil();
class ChatProvider{

final CollectionReference _collection=_instancia
        .collection("chatrooms");
  Stream<QuerySnapshot> getChatRooms() 
    //print('El user es $myUsername');
 => _collection
        // .orderBy("lastMessageSendTs", descending: true)
        .where("users", arrayContains: _prefs.userID)
        .snapshots();
  
  
  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async =>
   _collection
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  
    Future<QuerySnapshot> getAllChatRooms() => _instancia.collection("chatrooms").get();
    Future addMessage(
      String chatRoomId, String messageId, Map messageInfoMap) async => await _collection
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  

  Future updateLastMessageSend(
      String chatRoomId, Map lastMessageInfoMap) async=> _collection
        .doc(chatRoomId)
        .update(lastMessageInfoMap)
        .then((value) => print('en teoria funciono'));

  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapShot = await _collection
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      return true;
    } else {
      return _collection
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }


  
}