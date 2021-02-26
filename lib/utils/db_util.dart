import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_auxilium/models/business_model.dart';
import 'package:pet_auxilium/models/user_model.dart';
import 'package:pet_auxilium/models/publication_model.dart';

class dbUtil {
  final _firestoreInstance = FirebaseFirestore.instance;

//Guarda usuario
  Future<void> addUser(UserModel user) async {
    await _firestoreInstance.collection("users").doc(user.id).set({
      "name": user.name,
      "birthday": user.birthday,
      "imgRef": user.imgRef
    }).then((value) {});
  }

//Obtiene los datos de un usario utilizando su ID
  Future<UserModel> getUser(String id) async {
    await _firestoreInstance.collection("users").doc(id).get().then((value) {
      return UserModel(
          name: value.get("name"),
          birthday: value.get("birthday"),
          imgRef: value.get("imgRef"));
    });
  }

//Guarda negocio
  Future<void> addBusiness(BusinessModel business) async {
    await _firestoreInstance.collection("business").add({
      'name': business.name,
      'location': business.location,
      'description': business.description,
      'userID': business.userID
    });
  }

  Future<List<BusinessModel>> getAllLocations() async {
    await _firestoreInstance.collection('business').get().then((value) {
      value.docs.forEach((element) {
        var info = element.data();
        print(info.keys);
      });
    });
  }

  Future<void> addPublication(PublicationModel ad) async {
    await _firestoreInstance.collection("publications").add({
      'category': ad.category,
      'name': ad.name,
      'description': ad.description,
      'location': ad.location,
      'imgRef': ad.imgRef,
      'userID':ad.userID
    });
  }
}
