import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:pet_auxilium/utils/prefs_util.dart';

class StorageUtil {
  FirebaseStorage _storage = FirebaseStorage.instance;
  final preferencesUtil prefs=preferencesUtil();
  Future<String> uploadFile(File file, String folder) async {
    String url;
 //TODO: agregar que tambien el userid al nombre del archivo para evitar problemas
    Reference reference =
        _storage.ref().child("$folder/" + DateTime.now().toString()+prefs.userID);

    UploadTask uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {});
    await reference.getDownloadURL().then((value) {
      url = value.toString();
    });
    return url;
  }
}
