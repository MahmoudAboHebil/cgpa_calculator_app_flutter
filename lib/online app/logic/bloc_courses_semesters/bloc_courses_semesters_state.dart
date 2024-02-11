import 'package:equatable/equatable.dart';

import '../../data/models/user_model/user_model_courses_semesters.dart';

abstract class BlocCSemestersState extends Equatable {}

class CSemestersLoading extends BlocCSemestersState {
  @override
  List<Object> get props => [];
}

class CSemestersLoadedIds extends BlocCSemestersState {
  final List<UserModelCoursesSemesters> cSemesters;
  CSemestersLoadedIds({required this.cSemesters});
  @override
  List<Object> get props => [cSemesters];
}

class CSemestersLoadedCourses extends BlocCSemestersState {
  final List<UserModelCoursesSemesters> cSemesters;
  CSemestersLoadedCourses({required this.cSemesters});
  @override
  List<Object> get props => [cSemesters];
}

class CSemestersError extends BlocCSemestersState {
  final String error;
  CSemestersError({required this.error});
  @override
  List<Object> get props => [error];
}
