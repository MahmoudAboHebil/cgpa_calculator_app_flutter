import 'package:equatable/equatable.dart';

import '../../data/models/user_model/user_model_courses_semesters.dart';
import '../../data/models/user_model/user_model_info.dart';

abstract class BlocUserEvent extends Equatable {}

class LoadedUserEvent extends BlocUserEvent {
  final UserModelInfo? userModelInfo;
  final List<UserModelCoursesSemesters>? cSemesters;

  LoadedUserEvent({this.cSemesters, this.userModelInfo});
  @override
  List<Object?> get props => [cSemesters, userModelInfo];
}
