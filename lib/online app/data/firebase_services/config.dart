import 'package:cloud_firestore/cloud_firestore.dart';

class Config {
  static Future<bool> isExist(
      String path, FirebaseFirestore firebaseFirestore) async {
    bool exist = false;
    try {
      await firebaseFirestore.doc(path).get().then((doc) {
        exist = doc.exists;
      });
      return exist;
    } catch (e) {
      // If any error
      return false;
    }
  }
}
