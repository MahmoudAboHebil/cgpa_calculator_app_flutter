import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cgp_calculator/online%20app/data/models/user_model/user_model_courses_semesters.dart';
import 'package:cgp_calculator/online%20app/data/repository/user_courses_semesters_repo/user_courses_semesters_repo.dart';

import '../../data/models/user_model/user_model_courses.dart';
import '../../data/repository/user_courses_repo/user_courses_repo.dart';
import 'bloc_courses_semesters_event.dart';
import 'bloc_courses_semesters_state.dart';

class BlocCSemesters extends Bloc<BlocCSemestersEvent, BlocCSemestersState> {
  final UserCoursesSemestersRepo semestersRepo;
  final UserCoursesRepo coursesRepo;

  final String email;
  StreamSubscription? _streamSubscription;

  BlocCSemesters(
      {required this.semestersRepo,
      required this.email,
      required this.coursesRepo})
      : super(CSemestersLoading()) {
    on<LoadedCSemestersEvent>((event, emit) async {
      emit(CSemestersLoading());
      try {
        await _mapLoadedIDsEventToLoadedState();
      } catch (e) {
        emit(CSemestersError(error: e.toString()));
      }
    });
    on<LoadedCSemestersCoursesEvent>((event, emit) async {
      emit(CSemestersLoading());
      try {
        _mapLoadedCoursesEventToLoadedState(event);
      } catch (e) {
        emit(CSemestersError(error: e.toString()));
      }
    });
  }
  Future<StreamSubscription<List<UserModelCoursesSemesters>>>
      _mapLoadedIDsEventToLoadedState() async {
    Stream<List<UserModelCoursesSemesters>> stream =
        await semestersRepo.getUserSemesters(email);
    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
    }
    return _streamSubscription = stream.listen((cSemesters) {
      emit(CSemestersLoadedIds(cSemesters: cSemesters));

      add(LoadedCSemestersCoursesEvent(cSemesters: cSemesters));
    });
  }

  void _mapLoadedCoursesEventToLoadedState(
      LoadedCSemestersCoursesEvent event) async {
    List<UserModelCoursesSemesters> allSemest = [];
    for (var userCSemesters in event.cSemesters) {
      Stream<List<UserModelCourses>> stream =
          await coursesRepo.getUserCourses(userCSemesters.semesterId, email);
      UserModelCoursesSemesters semet = UserModelCoursesSemesters(
          semesterId: userCSemesters.semesterId, courses: stream);
      allSemest.add(semet);
    }
    emit(CSemestersLoadedCourses(cSemesters: allSemest));
  }

  @override
  void onChange(Change<BlocCSemestersState> change) {
    print(change);
    super.onChange(change);
  }

  @override
  Future<void> close() {
    _streamSubscription!.cancel();
    return super.close();
  }
}
