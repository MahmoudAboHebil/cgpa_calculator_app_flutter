import 'package:cgp_calculator/online%20app/data/models/user_model/user_model_courses.dart';

class UserModelCoursesSemesters {
  final String semesterId;
  List<UserModelCourses>? courses;
  UserModelCoursesSemesters({
    required this.semesterId,
    this.courses,
  });
  factory UserModelCoursesSemesters.fromJson(
      Map<String, dynamic> jsonSemester) {
    return UserModelCoursesSemesters(
      semesterId: jsonSemester['semesterId'],
    );
  }
}
