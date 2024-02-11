import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cgp_calculator/online%20app/data/models/user_model/user_model_courses.dart';
import 'package:cgp_calculator/online%20app/data/repository/user_courses_repo/user_courses_repo.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_courses/bloc_courses_event.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_courses/bloc_courses_state.dart';

class BlocCourses extends Bloc<BlocCoursesEvent, BlocCoursesState> {
  final UserCoursesRepo coursesRepo;
  final String email;
  StreamSubscription? _streamSubscription;
  BlocCourses({required this.coursesRepo, required this.email})
      : super(CoursesLoading()) {
    on<LoadedCoursesEvent>((event, emit) async {
      emit(CoursesLoading());
      try {
        await _mapLoadedEventToLoadedState(event);
      } catch (e) {
        emit(CoursesError(error: e.toString()));
      }
    });
  }
  Future<StreamSubscription<List<UserModelCourses>>>
      _mapLoadedEventToLoadedState(LoadedCoursesEvent event) async {
    Stream<List<UserModelCourses>> stream =
        await coursesRepo.getUserCourses(event.semesterId, email);
    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
    }
    return _streamSubscription = stream.listen((courses) {
      emit(CoursesLoaded(courses: courses));
    });
  }

  @override
  Future<void> close() {
    _streamSubscription!.cancel();
    return super.close();
  }
}
