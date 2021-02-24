import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageUtil {
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file, String folder) async {
    String url;

    Reference reference =
        _storage.ref().child("$folder/" + DateTime.now().toString());

    UploadTask uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {});
    await reference.getDownloadURL().then((value) {
      url = value.toString();
    });
    return url;
  }
}
