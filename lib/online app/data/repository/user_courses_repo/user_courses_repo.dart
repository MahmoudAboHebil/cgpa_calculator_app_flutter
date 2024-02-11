import 'package:cgp_calculator/online%20app/data/firebase_services/user_courses_service/user_courses_service.dart';
import 'package:cgp_calculator/online%20app/data/models/user_model/user_model_courses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCoursesRepo {
  final _userCoursesService = UserCoursesService();

  Future<Stream<List<UserModelCourses>>> getUserCourses(
      String semesterId, String email) async {
    CollectionReference cr =
        await _userCoursesService.getUserCoursesCollection(semesterId, email);
    return cr.snapshots().map((snapshot) {
      return snapshot.docs
          .map((snap) => UserModelCourses.fromSnapshot(snap))
          .toList();
    });
  }
}
