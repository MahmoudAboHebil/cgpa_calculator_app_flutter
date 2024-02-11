import 'package:cgp_calculator/online%20app/data/models/user_model/user_model_courses.dart';
import 'package:equatable/equatable.dart';

abstract class BlocCoursesState extends Equatable {}

class CoursesLoading extends BlocCoursesState {
  @override
  List<Object> get props => [];
}

class CoursesLoaded extends BlocCoursesState {
  final List<UserModelCourses> courses;
  CoursesLoaded({required this.courses});
  @override
  List<Object> get props => [courses];
}

class CoursesError extends BlocCoursesState {
  final String error;
  CoursesError({required this.error});
  @override
  List<Object> get props => [error];
}
