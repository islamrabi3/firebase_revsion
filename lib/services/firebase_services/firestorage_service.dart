import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirestorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(String path, File fileName) async {
    final ref = _storage.ref().child(path).child(fileName.path);
    UploadTask uploadTask = ref.putFile(fileName);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }
}
