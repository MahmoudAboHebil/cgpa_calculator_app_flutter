import 'package:cgp_calculator/online%20app/data/models/user_model/user_model_courses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModelCoursesSemesters {
  final String semesterId;
  final List<UserModelCourses>? courses;
  UserModelCoursesSemesters({
    required this.semesterId,
    this.courses,
  });
  factory UserModelCoursesSemesters.fromSnapshot(DocumentSnapshot snap) {
    return UserModelCoursesSemesters(
      semesterId: snap['semesterId'],
    );
  }
}
