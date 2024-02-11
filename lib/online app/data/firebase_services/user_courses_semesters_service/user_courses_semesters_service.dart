import 'package:cloud_firestore/cloud_firestore.dart';

import '../config.dart';

// users/mahmoudbloc1@gmail.com/userSemesters/1
// 1- email
// 2- semesterID
class UserCoursesSemestersService {
  final _firebaseFirestore = FirebaseFirestore.instance;
  Future<CollectionReference> getUserCoursesSemestersCollection(
      String email) async {
    if (!await Config.isExist('users/$email', _firebaseFirestore)) {
      throw Exception(
          'There is no email with ($email) document called in (getUserCoursesSemestersCollection())');
    }
    return _firebaseFirestore
        .collection('users')
        .doc(email)
        .collection('userSemesters');
  }
}
