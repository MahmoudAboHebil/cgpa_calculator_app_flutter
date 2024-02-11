import 'package:equatable/equatable.dart';

import '../../data/models/user_model/user_model_courses_semesters.dart';

abstract class BlocCSemestersEvent extends Equatable {}

class LoadedCSemestersEvent extends BlocCSemestersEvent {
  @override
  List<Object> get props => [];
}

class LoadedCSemestersCoursesEvent extends BlocCSemestersEvent {
  final List<UserModelCoursesSemesters> cSemesters;
  LoadedCSemestersCoursesEvent({required this.cSemesters});
  @override
  List<Object> get props => [cSemesters];
}
