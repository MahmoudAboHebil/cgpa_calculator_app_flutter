import 'package:cgp_calculator/online%20app/data/models/user_model/user_model.dart';
import 'package:cgp_calculator/online%20app/data/models/user_model/user_model_courses.dart';
import 'package:cgp_calculator/online%20app/data/models/user_model/user_model_courses_semesters.dart';
import 'package:cgp_calculator/online%20app/data/models/user_model/user_model_info.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_courses/bloc_courses.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_info/bloc_info.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_info/bloc_info_events.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_info/bloc_info_states.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_user/bloc_user.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_user/bloc_user_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/bloc_courses/bloc_courses_state.dart';
import 'logic/bloc_courses_semesters/bloc_courses_semesters.dart';
import 'logic/bloc_courses_semesters/bloc_courses_semesters_state.dart';

class TestInfo extends StatefulWidget {
  const TestInfo({super.key});

  @override
  State<TestInfo> createState() => _TestInfoState();
}

class _TestInfoState extends State<TestInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<BlocUser, BlocUserState>(
      builder: (context, state) {
        if (state is LoadingUser) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LoadedUser) {
          UserModelInfo? info = state.user.info;
          List<UserModelCoursesSemesters>? semesters =
              state.user.coursesSemestersList;
          UserModelCourses course =
              UserModelCourses(courseId: 'test', semesterId: '1');

          return StreamBuilder<List<UserModelCourses>>(
            stream: semesters![0].courses,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(' name :    ${info!.name}'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(' courseName :    ${snapshot.data![0].courseName}'),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        } else if (state is ErrorUser) {
          return Center(
            child: Text(state.err),
          );
        }
        return Container();
      },
    ));
  }
}

class test extends StatelessWidget {
  const test({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
