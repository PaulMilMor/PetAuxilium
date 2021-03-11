import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pet_auxilium/models/business_model.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/models/publication_model.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';

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
      "follows": user.follows
    }).then((value) {});
  }

//Obtiene los datos de un usario utilizando su ID
  Future<UserModel> getUser(String id) async {
    await _firestoreInstance.collection("users").doc(id).get().then((value) {
      _prefs.userName = value.get("name");
      _prefs.userID = id;
      _prefs.userImg = value.get("imgRef");
      _prefs.userEmail = value.get("email");

      print('IMG');
      print(_prefs.userImg);
      print(value.get("imgRef"));
      print(value.get("birthday"));

      return UserModel(
          name: value.get("name"),
          birthday: value.get("birthday"),
          imgRef: value.get("imgRef"),
          follows: value.get("follows") ?? List());
    });
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
    await _firestoreInstance.collection("publications").add({
      'category': ad.category,
      'name': ad.name,
      'description': ad.description,
      'location': ad.location,
      'imgRef': ad.imgRef,
      'userID': ad.userID,
      'pricing': ''
    });
  }

  Future<void> deleteDocument(String id, String collection) async {
    await _firestoreInstance.collection(collection).doc(id).delete();
  }

  Future<void> addKeeper(PublicationModel ad) async {
    await _firestoreInstance.collection("publications").add({
      'category': ad.category,
      'name': ad.name,
      'description': ad.description,
      'location': ad.location,
      'imgRef': ad.imgRef,
      'userID': ad.userID,
      'pricing': ad.pricing
    });
  }

  Future<List<String>> getLocations() async {
    List<String> lista = List<String>();
    String place = "";
    await _firestoreInstance.collection('publications').get().then((value) {
      value.docs.forEach((element) {
        PublicationModel publication =
            PublicationModel.fromJsonMap(element.data());

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
    List<String> images = List<String>();
    await _firestoreInstance
        .collection("publications")
        .doc(id)
        .get()
        .then((value) {
      PublicationModel publication = PublicationModel.fromJsonMap(value.data());

      publication.imgRef.forEach((element) {
        images.add(element);
      });
    });
    return images;
  }

  Future<List<PublicationModel>> getPublications(String category) async {
    List<PublicationModel> publications = List<PublicationModel>();
    await _firestoreInstance
        .collection('business')
        .where('category', isEqualTo: category)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        publications.add(PublicationModel.fromJsonMap(element.data()));
      });
    });
    return publications;
  }

  void updateFollows(List follows) async {
    await _firestoreInstance
        .collection('users')
        .doc(_prefs.userID)
        .update({'follows': follows});
  }

  Future<List<String>> getFollows(id) async {
    List<String> follows = List<String>();
    await _firestoreInstance.collection('users').doc(id).get().then((value) {
      UserModel user = UserModel.fromJsonMap(value.data());
      if (user.follows != null) {
        user.follows.forEach((element) {
          follows.add(element);
        });
      }
    });
    return follows;
  }
}
