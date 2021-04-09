import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:geocoding/geocoding.dart';
import 'package:path/path.dart';
import 'package:pet_auxilium/models/business_model.dart';
import 'package:pet_auxilium/models/complaint_model.dart';
import 'package:pet_auxilium/models/evaluation_model.dart';
import 'package:pet_auxilium/models/comment_model.dart';
import 'package:pet_auxilium/models/report_model.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:rxdart/rxdart.dart';

class dbUtil {
  final _firestoreInstance = FirebaseFirestore.instance;
  final preferencesUtil _prefs = preferencesUtil();
//Guarda usuario
  Future<void> addUser(UserModel user) async {
    await _firestoreInstance.collection("users").doc(user.id).set({
      "name": user.name,
      "birthday": user.birthday,
      "imgRef": user.imgRef,
      "email": user.email,
      "follows": user.follows,
      "evaluationsID": user.evaluationsID,
    }).then((value) {});
  }

//Obtiene los datos de un usario utilizando su ID
  Future<UserModel> getUser(String id) async {
    //throw Exception('jiji');
    await _firestoreInstance.collection("users").doc(id).get().then((value) {
      _prefs.userName = value.get("name");
      _prefs.userID = id;
      _prefs.userImg = value.get("imgRef");
      _prefs.userEmail = value.get("email");

      print('IMG');
      print(_prefs.userImg);
      print(value.get("imgRef"));
      //TODO: Remover todo rastro del cumpleaños
      // print(value.get("birthday"));

      return UserModel(
          name: value.get("name"),
          //birthday: value.get("birthday"),
          imgRef: value.get("imgRef"),
          follows: value.get("follows") ?? [],
          evaluationsID: value.get("evaluationsID") ?? []);
    });
  }
    Future<DocumentSnapshot> getUserById(String userID) async {
    return await FirebaseFirestore.instance.collection("users").doc(userID).get();
  }
//Guarda negocio
  Future<void> addBusiness(BusinessModel business) async {
    await _firestoreInstance.collection("business").add({
      'name': business.name,
      'location': business.location,
      'description': business.description,
      'userID': business.userID,
      'imgRef': business.imgRef,
    });
  }

//Guarda denuncia
  Future<void> addComplaint(ComplaintModel complaint) async {
    await _firestoreInstance.collection("complaints").add({
      'title': complaint.title,
      'location': complaint.location,
      'description': complaint.description,
      'userID': complaint.userID,
      'imgRef': complaint.imgRef,
    });
  }

  Future<List<BusinessModel>> getAllLocations() async {
    List<BusinessModel> locations = List<BusinessModel>();
    await _firestoreInstance.collection('business').get().then((value) {
      value.docs.forEach((element) {
        locations.add(BusinessModel.fromJsonMap(element.data()));
      });
    });
    return locations;
  }

  Future<void> addPublication(PublicationModel ad) async {
    await _firestoreInstance.collection("publications").doc(ad.id).set({
      'category': ad.category,
      'name': ad.name,
      'description': ad.description,
      'location': ad.location,
      'imgRef': ad.imgRef,
      'userID': ad.userID,
      'pricing': '',
      'nevaluations': 0,
      'score': 0,
    });
  }

  Future<void> addReport(ReportModel rm) async {
    await _firestoreInstance.collection("reports").doc(rm.publicationid).set({
      'publicationid': rm.publicationid,
      'nreports': 0,
      'nspam': 0,
      'nfalseinfo': 0,
      'nidentityfraud': 0,
      'nbadphotos': 0,
      'userid': rm.userid
    });
    print("dentro de los reportes");
    print(rm.publicationid);
  }

  Future<void> updatereport(ReportModel rm, String selectedoption) async {
    if (selectedoption == "Spam") {
      print("adentro del spam");
      print(rm.userid);
      await _firestoreInstance
          .collection("reports")
          .doc(rm.publicationid)
          .update({
        'userid': rm.userid,
        'nreports': FieldValue.increment(1),
        'nspam': FieldValue.increment(1),
      });
    }
    if (selectedoption == "Informacion fraudulenta") {
      await _firestoreInstance
          .collection("reports")
          .doc(rm.publicationid)
          .update({
        'userid': rm.userid,
        'nreports': FieldValue.increment(1),
        'nfalseinfo': FieldValue.increment(1),
      });
    }
    if (selectedoption == "Suplantacion de identidad") {
      await _firestoreInstance
          .collection("reports")
          .doc(rm.publicationid)
          .update({
        'userid': rm.userid,
        'nreports': FieldValue.increment(1),
        'nidentityfraud': FieldValue.increment(1),
      });
    }
    if (selectedoption == "Fotos Inapropiadas") {
      await _firestoreInstance
          .collection("reports")
          .doc(rm.publicationid)
          .update({
        'userid': rm.userid,
        'nreports': FieldValue.increment(1),
        'nbadphotos': FieldValue.increment(1),
      });
    }
  }

  Future<void> addKeeper(PublicationModel ad) async {
    await _firestoreInstance.collection("publications").add({
      'category': ad.category,
      'name': ad.name,
      'description': ad.description,
      'location': ad.location,
      'imgRef': ad.imgRef,
      'userID': ad.userID,
      'pricing': ad.pricing,
      'nevaluations': 0,
      'score': 0,
    });
  }

  Future<void> addEvaluations(EvaluationModel evaluation) async {
    /*DocumentReference docRef = await 
Firestore.instance.collection('gameLevels').add(map);
print(docRef.documentID);*/
    await _firestoreInstance.collection("evaluations").add({
      'userID': evaluation.userID,
      'publicationID': evaluation.publicationID,
      'username': evaluation.username,
      'score': evaluation.score,
      'comment': evaluation.comment
    });
    double scorenum = double.parse(evaluation.score);
    await _firestoreInstance
        .collection("publications")
        .doc(evaluation.publicationID)
        .update({
      'score': FieldValue.increment(scorenum),
      'nevaluations': FieldValue.increment(1),
    });
  }

  Future<void> updateScore(EvaluationModel evaluation) async {
    double scorenum = double.parse(evaluation.score);
    await _firestoreInstance
        .collection("publications")
        .doc(evaluation.publicationID)
        .update({
      'score': FieldValue.increment(-scorenum),
      'nevaluations': FieldValue.increment(-1),
    });
  }

  Future<void> addComments(CommentModel comment) async {
    await _firestoreInstance.collection("comments").add({
      'userID': comment.userID,
      'publicationID': comment.publicationID,
      'username': comment.username,
      'comment': comment.comment
    });
    await _firestoreInstance
        .collection("publications")
        .doc(comment.publicationID)
        .update({
      'nevaluations': FieldValue.increment(1),
    });
  }

  Future<List<String>> getLocations() async {
    List<String> lista = List<String>();
    String place = "";
    await _firestoreInstance.collection('publications').get().then((value) {
      value.docs.forEach((element) {
        PublicationModel publication =
            PublicationModel.fromJsonMap(element.data(), element.id);

        publication.location.forEach((element) async {
          double latitude =
              double.parse(element.substring(0, element.indexOf(',')).trim());
          double longitude =
              double.parse(element.substring(element.indexOf(',') + 1).trim());
          List<Placemark> placemarks =
              await placemarkFromCoordinates(latitude, longitude);
          place = place +
              placemarks.first.street +
              " " +
              placemarks.first.locality +
              "\n";
          print(place);
        });

        print(lista.toString());
      });
    });
    return lista;
  }

  Future<List<String>> getAllImages(String id) async {
    List<String> images = [];
    await _firestoreInstance
        .collection("publications")
        .doc(id)
        .get()
        .then((value) {
      PublicationModel publication =
          PublicationModel.fromJsonMap(value.data(), id);

      publication.imgRef.forEach((element) {
        images.add(element);
      });
    });
    return images;
  }

  Future<QuerySnapshot> getPublications(
      String collection, String category) async {
    return _firestoreInstance
        .collection(collection)
        .where('category', isEqualTo: category)
        .get();
  }

  Stream get allFeedElements => Rx.combineLatest3(
      streamPublication(),
      streamBusiness(),streamComplaints(),
      (List<PublicationModel> p, List<PublicationModel> b, List<PublicationModel> c) => p + b+ c);
  //Stream get feedStream =>
  Stream<List<PublicationModel>> streamPublication() =>
      _firestoreInstance.collection('publications').snapshots().map((event) {
        List<PublicationModel> list = [];
        event.docs.forEach((element) {
          print(element.id);
          var data = element.data();
          PublicationModel p = PublicationModel.fromJsonMap(data, element.id);
         
          list.add(p);
        });

        return list;
      });
  Stream<List<PublicationModel>> streamComplaints() =>
      _firestoreInstance.collection('complaints').snapshots().map((event) {
        List<PublicationModel> list = [];
        event.docs.forEach((element) {
          print(element.id);
          var data = element.data();
          PublicationModel p = PublicationModel.fromJsonMap(data, element.id);
      
          list.add(p);
        });

        return list;
      });

  Stream<List<PublicationModel>> streamBusiness() =>
      _firestoreInstance.collection('business').snapshots().map((event) {
        List<PublicationModel> list = [];
        event.docs.forEach((element) {
          print(element.id);
          var data = element.data();
          PublicationModel p = PublicationModel.fromJsonMap(data, element.id);
          
          list.add(p);
        });

        //print(list);

        return list;
      });
  Stream<QuerySnapshot> getFollowPublications(data) {
    return _firestoreInstance
        .collection('publications')
        .where(FieldPath.documentId, whereIn: data)
        .snapshots();
  }

  void updateFollows(List follows) async {
    await _firestoreInstance
        .collection('users')
        .doc(_prefs.userID)
        .update({'follows': follows});
  }

  Future<List<String>> getFollows(id) async {
    List<String> follows = [];
    await _firestoreInstance.collection('users').doc(id).get().then((value) {
      UserModel user = UserModel.fromJsonMap(value.data());
      if (user.follows != null) {
        user.follows.forEach((element) {
          follows.add(element);
        });
      }
    }).catchError((e) {
      follows = [];
    });
    return follows;
  }

  Future<void> banUser(String id) async {
    await _firestoreInstance.collection('bans').doc(id).set({});
    await _firestoreInstance
        .collection('publications')
        .where('userID', isEqualTo: id)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await _firestoreInstance
            .collection('publications')
            .doc(element.id)
            .delete();
      });
    });
  }

  Future<List<String>> bansList() async {
    List<String> banlist = [];

    await _firestoreInstance.collection('bans').get().then((value) {
      value.docs.forEach((element) {
        banlist.add(element.id);
      });
    }).catchError((e) {
      banlist = [];
    });
    return banlist;
  }

  void updateEvaluations(List evaluationsID) async {
    await _firestoreInstance
        .collection('users')
        .doc(_prefs.userID)
        .update({'evaluationsID': evaluationsID});
  }

  void updateComments(List commentsID) async {
    await _firestoreInstance
        .collection('users')
        .doc(_prefs.userID)
        .update({'commentsID': commentsID});
  }

  Future<void> deleteDocument(String id, String collection) async {
    await _firestoreInstance.collection(collection).doc(id).delete();
  }

  Future<List<ReportModel>> getreports() async {
    List<ReportModel> reports = [];
    await _firestoreInstance.collection('reports').get().then((value) {
      value.docs.forEach((element) {
        print(element.id);
        ReportModel report =
            ReportModel.fromJsonMap(element.data(), element.id);
        print(report.nreports);
        reports.add(report);
      });
    });

    print(reports.first.id);
    return reports;
  }

  Stream<List<EvaluationModel>> getOpinions(String id) =>

  _firestoreInstance
        .collection('evaluations')
        .where('publicationID', isEqualTo: id)
        .snapshots()
        .map((value) {
              List<EvaluationModel> opinions = [];
      value.docs.forEach((element) {
        EvaluationModel opinion = EvaluationModel.fromJsonMap(element.data());
        opinion.id = element.id;
        opinions.add(opinion);
      });
          return opinions;
    });

  

  Stream<List<CommentModel>> getComments(String id)  =>
   
   _firestoreInstance
        .collection('comments')
        .where('publicationID', isEqualTo: id)
        .snapshots()
        .map((value) {
          List<CommentModel> comments = [];
      value.docs.forEach((element) {
         
        CommentModel comment = CommentModel.fromJsonMap(element.data());
        comments.add(comment);
      });
    return comments;
    });
  
  

  Future<PublicationModel> getPublication(String id) async {
    PublicationModel publication;
    await _firestoreInstance
        .collection('publications')
        .doc(id)
        .get()
        .then((value) {
      publication = PublicationModel.fromJsonMap(value.data(), id);
    });
    return publication;
  }

  Future<List<String>> getEvaluations(id) async {
    List<String> evaluationsID = [];
    await _firestoreInstance.collection('users').doc(id).get().then((value) {
      UserModel user = UserModel.fromJsonMap(value.data());
      if (user.evaluationsID != null) {
        user.evaluationsID.forEach((element) {
          evaluationsID.add(element);
        });
      }
    });
    return evaluationsID;
  }

  Future addMessage(
      String chatRoomId, String messageId, Map messageInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  Future updateLastMessageSend(
      String chatRoomId, Map lastMessageInfoMap) async {
    print('deberia entrar en update');
    print(chatRoomId);
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap)
        .then((value) => print('en teoria funciono'));
  }

  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    print('fafaaf');
    //print('El user es $myUsername');
    return FirebaseFirestore.instance
        .collection("chatrooms")
        // .orderBy("lastMessageSendTs", descending: true)
       .where("users", arrayContains: _prefs.userID)
        .snapshots();
  }

  Future<QuerySnapshot> getAllChatRooms() async {
    print('fafaaf');
    // print('El user es $myUsername');
    return FirebaseFirestore.instance.collection("chatrooms").get();
  }
}
