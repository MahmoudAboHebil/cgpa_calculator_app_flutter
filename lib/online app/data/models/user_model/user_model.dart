import 'package:cgp_calculator/online%20app/data/models/user_model/user_model_courses_semesters.dart';
import 'package:cgp_calculator/online%20app/data/models/user_model/user_model_info.dart';
import 'package:cgp_calculator/online%20app/data/models/user_model/user_model_with_semester.dart';

class UserModel {
  UserModelInfo info;
  List<UserModelCoursesSemesters>? coursesSemestersList;
  List<UserModelWithSemester>? withSemesterList;

  UserModel(
      {required this.info, this.coursesSemestersList, this.withSemesterList});
}
