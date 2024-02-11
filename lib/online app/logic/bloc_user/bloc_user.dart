import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cgp_calculator/online%20app/data/models/user_model/user_model.dart';
import 'package:cgp_calculator/online%20app/data/models/user_model/user_model_courses_semesters.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_courses_semesters/bloc_courses_semesters.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_user/bloc_user_event.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_user/bloc_user_state.dart';

import '../../data/models/user_model/user_model_info.dart';
import '../bloc_courses_semesters/bloc_courses_semesters_state.dart';
import '../bloc_info/bloc_info.dart';
import '../bloc_info/bloc_info_states.dart';

class BlocUser extends Bloc<BlocUserEvent, BlocUserState> {
  BlocUser() : super(LoadingUser()) {
    on<LoadedUserEvent>((event, emit) async {
      emit(LoadingUser());
      try {
        if (event.userModelInfo != null && event.cSemesters != null) {
          emit(LoadedUser(
              user: UserModel(
                  info: event.userModelInfo,
                  coursesSemestersList: event.cSemesters)));
        }
      } catch (e) {
        emit(ErrorUser(err: e.toString()));
      }
    });
  }
  @override
  void onChange(Change<BlocUserState> change) {
    print(change);
    super.onChange(change);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
