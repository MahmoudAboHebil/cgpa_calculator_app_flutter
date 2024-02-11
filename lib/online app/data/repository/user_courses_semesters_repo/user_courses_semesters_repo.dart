import 'package:cgp_calculator/online%20app/data/firebase_services/user_courses_semesters_service/user_courses_semesters_service.dart';
import 'package:cgp_calculator/online%20app/data/models/user_model/user_model_courses_semesters.dart';
import 'package:cgp_calculator/online%20app/data/repository/user_courses_repo/user_courses_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCoursesSemestersRepo {
  final _semestersService = UserCoursesSemestersService();
  Future<Stream<List<UserModelCoursesSemesters>>> getUserSemesters(
      String email) async {
    CollectionReference cr =
        await _semestersService.getUserCoursesSemestersCollection(email);

    return cr.snapshots().map((semesterSnap) {
      return semesterSnap.docs.map((snap) {
        return UserModelCoursesSemesters.fromSnapshot(snap);
      }).toList();
    });
  }
}
