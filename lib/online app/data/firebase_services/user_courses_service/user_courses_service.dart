import 'package:cgp_calculator/online%20app/data/firebase_services/user_courses_semesters_service/user_courses_semesters_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../config.dart';

// users/mahmoudbloc1@gmail.com/userSemesters/1/courses
// 1- email
// 2- semesterID
class UserCoursesService {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _semestersService = UserCoursesSemestersService();
  Future<CollectionReference> getUserCoursesCollection(
      String semesterId, String email) async {
    CollectionReference cr =
        await _semestersService.getUserCoursesSemestersCollection(email);
    if (!await Config.isExist(
        'users/$email/userSemesters/$semesterId', _firebaseFirestore)) {
      throw Exception(
          'There is no $semesterId document  called in (getUserCoursesCollection())');
    }
    return cr.doc(semesterId).collection('courses');
  }
}
