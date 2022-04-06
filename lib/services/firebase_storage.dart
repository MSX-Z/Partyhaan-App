import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:partyhaan_app/constants/firebase_constants.dart';

class CloudStorage {
  static Future<String?> uploadImage(File file, String key) async {
    Reference ref = firebaseStorage.ref('Partys/$key');
    try {
      await ref.putFile(file);
      String result = await ref.getDownloadURL();
      return result;
    } on FirebaseException catch (e) {
      print('error $e');
      return e.message;
    }
  }

  static Future<String?> removeImage(String imagePath) async {
    Reference ref = firebaseStorage.refFromURL(imagePath);
    try {
      await ref.delete();
      return "delete success";
    } on FirebaseException catch (e) {
      print('error $e');
      return e.message;
    }

  }
}
