import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:geocoding/geocoding.dart';
import 'package:path/path.dart';
import 'package:pet_auxilium/models/business_model.dart';
import 'package:pet_auxilium/models/complaint_model.dart';
import 'package:pet_auxilium/models/donations_model.dart';
import 'package:pet_auxilium/models/evaluation_model.dart';
import 'package:pet_auxilium/models/comment_model.dart';
import 'package:pet_auxilium/models/report_model.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/models/publication_model.dart';

import 'package:pet_auxilium/models/notification_model.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';
import 'package:rxdart/rxdart.dart';

class dbUtil {
  final _firestoreInstance = FirebaseFirestore.instance;
  final preferencesUtil _prefs = preferencesUtil();
//Guarda usuario
  Future<void> addUser(UserModel user) async {
    await _firestoreInstance.collection("users").doc(user.id).set({
      "name": user.name,
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
      print('xxxxxxx');
      UserModel userModel=UserModel.fromJsonMap(value.data(), id);


      if(userModel.patreon==null){
        _prefs.patreonUser=false;
      }else{
        _prefs.patreonUser=true;
      }
    
      return userModel;
      //TODO: Remover todo rastro del cumpleaños
      // print(value.get("birthday"));

      // return UserModel(
      //     name: value.get("name"),
      //     //birthday: value.get("birthday"),
      //     imgRef: value.get("imgRef"),
      //     follows: value.get("follows") ?? [],
      //     evaluationsID: value.get("evaluationsID") ?? []);
    });
  }

  Future<DocumentSnapshot> getUserById(String userID) =>
      FirebaseFirestore.instance.collection("users").doc(userID).get();

//Guarda negocio
  Future<void> addBusiness(BusinessModel business) async {
    bool patreonValue = false;
    if (_prefs.patreonUser) patreonValue = true;
    await _firestoreInstance.collection("business").add({
      'category': 'NEGOCIO',
      'name': business.name,
      'location': business.location,
      'description': business.description,
      'userID': business.userID,
      'imgRef': business.imgRef,
      'services': business.services,
      'nevaluations': business.nevaluations == null ? 0 : business.nevaluations,
      'score': business.score == null ? 0 : business.score,
      'pricing': '',
      'date': business.date == null ? DateTime.now() : business.date,
      'patreon': patreonValue
    });
  }

//Guarda denuncia
  Future<void> addComplaint(ComplaintModel complaint) async {
    await _firestoreInstance.collection("complaints").doc(complaint.id).set({
      'name': complaint.name,
      'location': complaint.location,
      'description': complaint.description,
      'userID': complaint.userID,
      'imgRef': complaint.imgRef,
      'category': complaint.category,
      'nevaluations': 0,
      'score': 0,
      'pricing': "",
      'date': complaint.date == null ? DateTime.now() : complaint.date,
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
    print('xxxxx');
    print(_prefs.patreonUser);
    bool patreonValue = false;
    if (_prefs.patreonUser) patreonValue = true;
    await _firestoreInstance.collection("publications").doc(ad.id).set({
      'category': ad.category,
      'name': ad.name,
      'description': ad.description,
      'location': ad.location,
      'imgRef': ad.imgRef,
      'userID': ad.userID,
      'pricing': '',
      'nevaluations': ad.nevaluations == null ? 0 : ad.nevaluations,
      'score': ad.score == null ? 0 : ad.score,
      'date': ad.date == null ? DateTime.now() : ad.date,
      'patreon': patreonValue
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
    await _firestoreInstance.collection("publications").doc(ad.id).set({
      'category': ad.category,
      'name': ad.name,
      'description': ad.description,
      'location': ad.location,
      'imgRef': ad.imgRef,
      'userID': ad.userID,
      'pricing': ad.pricing,
      'nevaluations': 0,
      'score': 0,
      'services': ad.services,
      'date': DateTime.now(),
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
      'comment': evaluation.comment,
      'date': DateTime.now(),
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

  Future<void> addEvaluationsBusiness(EvaluationModel evaluation) async {
    await _firestoreInstance.collection("evaluations").add({
      'userID': evaluation.userID,
      'publicationID': evaluation.publicationID,
      'username': evaluation.username,
      'score': evaluation.score,
      'comment': evaluation.comment,
      'date': DateTime.now(),
    });
    double scorenum = double.parse(evaluation.score);
    await _firestoreInstance
        .collection("business")
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

  Future<void> updateScoreBusiness(EvaluationModel evaluation) async {
    double scorenum = double.parse(evaluation.score);
    await _firestoreInstance
        .collection("business")
        .doc(evaluation.publicationID)
        .update({
      'score': FieldValue.increment(-scorenum),
      'nevaluations': FieldValue.increment(-1),
    });
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String userId = FirebaseAuth.instance.currentUser.uid;

    await _firestoreInstance.collection('users').doc(userId).update({
      'token': FieldValue.arrayUnion([token]),
    });
  }

  Future<void> addComments(CommentModel comment) async {
    await _firestoreInstance.collection("comments").add({
      'userID': comment.userID,
      'publicationID': comment.publicationID,
      'username': comment.username,
      'comment': comment.comment,
      'date': DateTime.now(),
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
        });
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

  Future<Void> setPatreonPublications(
      String collection, String userID) async {
    await _firestoreInstance.collection(collection).where('userID', isEqualTo: userID).get().then((value){
      print('object');
          value.docs.forEach((element) async { 
            print(element.id);
           _firestoreInstance.collection(collection).doc(element.id).update({
              'patreon':true
            });
          });
        });
        
  }

//STREAM SERVICES
  Stream<List<PublicationModel>> streamPubsServices(String category) =>
      _firestoreInstance
          .collection('publications')
          .where('category', isEqualTo: category)
          .snapshots()
          .map((event) {
        List<PublicationModel> list = [];
        event.docs.forEach((element) {
          var data = element.data();
          PublicationModel p = PublicationModel.fromJsonMap(data, element.id);

          list.add(p);
        });

        return list;
      });
  Stream<List<PublicationModel>> streamKeepersServices(String category) =>
      _firestoreInstance
          .collection('publications')
          .where('category', isEqualTo: 'CUIDADOR')
          .where('services', arrayContains: category)
          .snapshots()
          .map((event) {
        List<PublicationModel> list = [];
        event.docs.forEach((element) {
          var data = element.data();
          PublicationModel p = PublicationModel.fromJsonMap(data, element.id);

          list.add(p);
        });

        return list;
      });
  Stream<List<PublicationModel>> streamBusinessServices(String category) =>
      _firestoreInstance
          .collection('business')
          .where('services', arrayContains: category)
          .snapshots()
          .map((event) {
        List<PublicationModel> list = [];
        event.docs.forEach((element) {
          var data = element.data();
          PublicationModel p = PublicationModel.fromJsonMap(data, element.id);

          list.add(p);
        });

        return list;
      });
  Stream<List<PublicationModel>> streamComplaintsServices(String category) =>
      _firestoreInstance.collection('complaints').snapshots().map((event) {
        List<PublicationModel> list = [];
        event.docs.forEach((element) {
          var data = element.data();
          PublicationModel p = PublicationModel.fromJsonMap(data, element.id);

          list.add(p);
        });

        return list;
      });
  Stream serviceFeed(String category) => Rx.combineLatest2(
      streamKeepersServices(category),
      streamBusinessServices(category),
      (List<PublicationModel> p, List<PublicationModel> b) => p + b);
  Future<QuerySnapshot> getKeepers(String service) async {
    return _firestoreInstance
        .collection('publications')
        .where('category', isEqualTo: 'CUIDADOR')
        .where('services', arrayContains: service)
        .get();
  }

  Future<QuerySnapshot> getAllPublications() {
    return _firestoreInstance.collection('publications').get();
  }

  Stream searchedElements(String query) {
    return Rx.combineLatest3(
        streamPublication(query, null, null),
        streamBusiness(query, null, null),
        streamComplaints(query, null, null),
        (List<PublicationModel> p, List<PublicationModel> b,
                List<PublicationModel> c) =>
            p + b + c);
  }

  Stream mypublic(List<PublicationModel> query) {
    return Rx.combineLatest3(
        streamPublication('', null, _prefs.userID),
        streamBusiness('', null, _prefs.userID),
        streamComplaints('', null, _prefs.userID),
        (List<PublicationModel> p, List<PublicationModel> b,
                List<PublicationModel> c) =>
            p + b + c);
  }

  Stream followedElements(List<String> follow) {
    return Rx.combineLatest3(
        streamPublication('', follow, null),
        streamBusiness('', follow, null),
        streamComplaints('', follow, null),
        (List<PublicationModel> p, List<PublicationModel> b,
                List<PublicationModel> c) =>
            p + b + c);
  }

  //Stream get feedStream =>
  Stream<List<PublicationModel>> streamPublication(
          String query, List<String> follow, String id) =>
      _firestoreInstance.collection('publications').snapshots().map((event) {
        List<PublicationModel> list = [];
        event.docs.forEach((element) async {
          var data = element.data();
          PublicationModel p = PublicationModel.fromJsonMap(data, element.id);
          if (p.name
              .substring(0, query.length)
              .contains(new RegExp('$query', caseSensitive: false)))
            list.add(p);

          if (follow != null) {
            if (!follow.contains(p.id)) list.remove(p);
          }

          if (id != null) {
            if (!id.contains(p.userID)) {
              list.remove(p);
            }
          }
        });

        return list;
      });

  Stream<List<PublicationModel>> streamComplaints(
          String query, List<String> follow, String id) =>
      _firestoreInstance.collection('complaints').snapshots().map((event) {
        List<PublicationModel> list = [];
        event.docs.forEach((element) {
          var data = element.data();
          PublicationModel p = PublicationModel.fromJsonMap(data, element.id);

          if (p.name
              .substring(0, query.length)
              .contains(new RegExp('$query', caseSensitive: false)))
            list.add(p);

          if (follow != null) {
            if (!follow.contains(p.id)) list.remove(p);
          }

          if (id != null) {
            if (!id.contains(p.userID)) {
              list.remove(p);
            }
          }
        });

        return list;
      });

  Stream<List<PublicationModel>> streamBusiness(
          String query, List<String> follow, String id) =>
      _firestoreInstance.collection('business').snapshots().map((event) {
        List<PublicationModel> list = [];
        event.docs.forEach((element) {
          var data = element.data();
          PublicationModel p = PublicationModel.fromJsonMap(data, element.id);

          if (p.name
              .substring(0, query.length)
              .contains(new RegExp('$query', caseSensitive: false)))
            list.add(p);

          if (follow != null) {
            if (!follow.contains(p.id)) list.remove(p);
          }
          if (id != null) {
            if (!id.contains(p.userID)) {
              list.remove(p);
            }
          }
        });

        return list;
      });
  //FIXME: Estos streams son temporales(Cambiarlos en el futuro)

  Stream get allFeedElements => Rx.combineLatest3(
      streamFeedPublication('', null, false),
      streamFeedBusiness('', null, false),
      streamComplaints('', null, null),
      (List<PublicationModel> p, List<PublicationModel> b,
              List<PublicationModel> c) =>
          p + b + c);
  Stream get PatreonFeedElements => Rx.combineLatest2(
      streamFeedPublication('', null, true),
      streamFeedBusiness('', null, true),
      (
        List<PublicationModel> p,
        List<PublicationModel> b,
      ) =>
          p + b);
  Stream<List<PublicationModel>> streamFeedPublication(
          String query, List<String> follow, bool isPatreon) =>
      _firestoreInstance
          .collection('publications')
          .where('patreon', isEqualTo: isPatreon)
          .snapshots()
          .map((event) {
        List<PublicationModel> list = [];
        event.docs.forEach((element) async {
          var data = element.data();
          PublicationModel p = PublicationModel.fromJsonMap(data, element.id);
          if (p.name
              .substring(0, query.length)
              .contains(new RegExp('$query', caseSensitive: false)))
            list.add(p);

          if (follow != null) {
            if (!follow.contains(p.id)) list.remove(p);
          }
        });

        return list;
      });
  Stream<List<PublicationModel>> streamFeedBusiness(
          String query, List<String> follow, bool isPatreon) =>
      _firestoreInstance
          .collection('business')
          .where('patreon', isEqualTo: isPatreon)
          .snapshots()
          .map((event) {
        List<PublicationModel> list = [];
        event.docs.forEach((element) {
          var data = element.data();
          PublicationModel p = PublicationModel.fromJsonMap(data, element.id);

          if (p.name
              .substring(0, query.length)
              .contains(new RegExp('$query', caseSensitive: false)))
            list.add(p);
          if (follow != null) {
            if (!follow.contains(p.id)) list.remove(p);
          }
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

  void updateFollows(List follows, PublicationModel publication) async {
    await _firestoreInstance
        .collection('users')
        .doc(_prefs.userID)
        .update({'follows': follows});
    String _collection = 'publications';
    switch (publication.category) {
      case 'CUIDADOR':
        _collection = 'cuidador';
        break;
      case 'NEGOCIO':
        _collection = 'business';
        break;
      case 'DENUNCIA':
        _collection = 'complaints';
        break;
      default:
        _collection = 'publications';
        break;
    }
    await _firestoreInstance
        .collection(_collection)
        .doc(publication.id)
        .update({'followers': publication.followers});
  }

  /*void updateNotifications(String notification) async {
    await _firestoreInstance
        .collection('notifications')
        .add({'notification':notification});
  }*/

  void updateNotifications(
      String notification, List<dynamic> userID, String publicationID) async {
    await _firestoreInstance.collection('notifications').add({
      'notification': notification,
      'receiverID': userID,
      'senderID': _prefs.userID,
      'publicationID': publicationID,
      'date': DateTime.now(),
      'senderName': _prefs.userName,
    });
  }

  Future<List<String>> getFollowsFuture(id) async {
    List<String> follows = [];
    await _firestoreInstance.collection('users').doc(id).get().then((value) {
      UserModel user = UserModel.fromJsonMap(value.data(), id);
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

  Future<Timestamp> getPatreon(id) {}
  Stream<List<String>> getFollows(id) =>
      _firestoreInstance.collection('users').doc(id).snapshots().map((value) {
        List<String> follows = [];
        UserModel user = UserModel.fromJsonMap(value.data(), id);
        if (user.follows != null) {
          user.follows.forEach((element) {
            follows.add(element);
          });
        }
        return follows;
      });

  Stream<List<PublicationModel>> getMypublications(id) => _firestoreInstance
          .collection('publications')
          .where('userID', isEqualTo: id)
          .snapshots()
          .map((event) {
        List<PublicationModel> mypublications = [];

        event.docs.forEach((element) {
          var data = element.data();
          PublicationModel publication =
              PublicationModel.fromJsonMap(data, element.id);

          mypublications.add(publication);
          print(publication);
        });
        return mypublications;
      });

  Stream<List<NotificationModel>> getNotifications() => _firestoreInstance
          .collection('notifications')
          .where('receiverID', arrayContains: _prefs.userID)
          .snapshots()
          .map((event) {
        List<NotificationModel> list = [];
        event.docs.forEach((element) {
          var data = element.data();
          NotificationModel n = NotificationModel.fromJsonMap(data, element.id);
          list.add(n);
        });
        return list;
        /*[
          NotificationModel(
              id: 'a',
              notification: 'b',
              receiverID: ['c'],
              senderID: 'd',
              publicationID: 'e',
              chatID: 'f')
        ];*/
      });
//        Future<List<String>> getNotificationsFuture() async{
//      List<String> notifications = [];
//      await _firestoreInstance.collection('users').doc(_prefs.userID).get().then((value) {

//         UserModel user = UserModel.fromJsonMap(value.data());
//         if (user.notifications != null) {
//           user.follows.forEach((element) {
//             notifications.add(element);
//           });
//         }

// });
// return notifications;}
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
        ReportModel report =
            ReportModel.fromJsonMap(element.data(), element.id);

        print('El reporte es ${report.id}');
        reports.add(report);
      });
    });

    return reports;
  }

  Stream<List<EvaluationModel>> getOpinions(String id) => _firestoreInstance
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

  Stream<List<CommentModel>> getComments(String id) => _firestoreInstance
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
      value.data() == null
          ? publication = null
          : publication = PublicationModel.fromJsonMap(value.data(), id);
    });
    return publication;
  }

  Future<List<String>> getEvaluations(id) async {
    List<String> evaluationsID = [];
    await _firestoreInstance.collection('users').doc(id).get().then((value) {
      UserModel user = UserModel.fromJsonMap(value.data(), id);
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

  Stream<QuerySnapshot> getChatRooms() {
    //print('El user es $myUsername');
    return FirebaseFirestore.instance
        .collection("chatrooms")
        // .orderBy("lastMessageSendTs", descending: true)
        .where("users", arrayContains: _prefs.userID)
        .snapshots();
  }

  Stream<List<DonationModel>> getDonations() =>
      _firestoreInstance.collection('donations').snapshots().map((value) {
        List<DonationModel> donations = [];
        value.docs.forEach((element) {
          var data = element.data();
          DonationModel d = DonationModel.fromJsonMap(data, element.id);
          donations.add(d);
        });
        return donations;
      });

  Future<void> addDonation(DonationModel dm) async {
    await _firestoreInstance.collection("donations").doc(dm.id).set({
      'name': dm.name,
      'description': dm.description,
      'img': dm.img,
      'website': dm.website,
    });
  }

  Future<QuerySnapshot> getAllChatRooms() async {
    // print('El user es $myUsername');
    return FirebaseFirestore.instance.collection("chatrooms").get();
  }

  updateToken(id, token) async {
    await _firestoreInstance
        .collection('users')
        .doc(id)
        .update({'token': token});
  }

  setPatreon(time) async {
    var days = 30 * time;
    var hours = 10 * time;
    var date = Timestamp.now().toDate().add(Duration(days: days, hours: hours));
    await _firestoreInstance
        .collection('users')
        .doc(_prefs.userID)
        .update({'patreon': date});
  }
}
