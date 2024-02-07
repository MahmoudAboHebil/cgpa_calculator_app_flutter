import 'package:cloud_firestore/cloud_firestore.dart';

import '../config.dart';

class UserInfoService {
  final _firebaseFirestore = FirebaseFirestore.instance;
  Future<CollectionReference> getUserInfoCollection(String email) async {
    if (!await Config.isExist('users/$email', _firebaseFirestore)) {
      throw Exception(
          'There is no email with ($email) document called in (getUserInfoCollection)');
    }

    return _firebaseFirestore
        .collection('users')
        .doc(email)
        .collection('userInfo');
  }

  Future<DocumentReference> getUserInfoDocument(String email) async {
    if (!await Config.isExist(
        'users/$email/userInfo/info', _firebaseFirestore)) {
      throw Exception(
          'There is no info document  called in (getUserInfoDocument)');
    }
    return _firebaseFirestore
        .collection('users')
        .doc(email)
        .collection('userInfo')
        .doc('info');
  }
}
