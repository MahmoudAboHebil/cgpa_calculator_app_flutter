import 'package:cgp_calculator/online%20app/data/repository/user_courses_repo/user_courses_repo.dart';
import 'package:cgp_calculator/online%20app/data/repository/user_info_repo/user_info_repo.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_courses/bloc_courses.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_courses/bloc_courses_event.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_courses_semesters/bloc_courses_semesters.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_info/bloc_info.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_user/bloc_user.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_user/bloc_user_state.dart';
import 'package:cgp_calculator/online%20app/testInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'online app/auth_servieses.dart';
import 'online app/data/repository/user_courses_semesters_repo/user_courses_semesters_repo.dart';
import 'online app/logic/bloc_courses_semesters/bloc_courses_semesters_event.dart';
import 'online app/logic/bloc_courses_semesters/bloc_courses_semesters_state.dart';
import 'online app/logic/bloc_info/bloc_info_events.dart';
import 'online app/logic/bloc_info/bloc_info_states.dart';
import 'online app/logic/bloc_user/bloc_user_event.dart';
import 'online app/pages/courses_page.dart';
import 'online app/pages/welcome_page.dart';
import 'offline app/provider_brain.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: FirebaseOptions(
      //     apiKey: "apiKey",
      //     appId: "appId",
      //     messagingSenderId: "messagingSenderId",
      //     projectId: "projectId"),
      );
  // await Hive.initFlutter();;
  // await Hive.openBox('courses00');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthServer>(
          create: (context) => AuthServer(),
        ),
        ChangeNotifierProvider<MyData>(
          create: (context) => MyData(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
            textSelectionTheme: TextSelectionThemeData(
                selectionColor: Colors.transparent,
                selectionHandleColor: Colors.transparent)),
        home: MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (context) => UserInfoRepo(),
            ),
            RepositoryProvider(
              create: (context) => UserCoursesSemestersRepo(),
            ),
            RepositoryProvider(
              create: (context) => UserCoursesRepo(),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<BlocInfo>(
                create: (context) => BlocInfo(
                  userInfoRepo: RepositoryProvider.of<UserInfoRepo>(context),
                  email: 'mahmoudbloc1@gmail.com',
                )..add(LoadedInfoUserEvent()),
              ),
              BlocProvider<BlocCSemesters>(
                create: (context) => BlocCSemesters(
                  semestersRepo:
                      RepositoryProvider.of<UserCoursesSemestersRepo>(context),
                  email: 'mahmoudbloc1@gmail.com',
                  coursesRepo: RepositoryProvider.of<UserCoursesRepo>(context),
                )..add(LoadedCSemestersEvent()),
              ),
              BlocProvider<BlocUser>(create: (context) => BlocUser()),
            ],
            child: Builder(builder: (context) {
              final info = context.watch<BlocInfo>().state;
              final semester = context.watch<BlocCSemesters>().state;
              if (info is BlocInfoLoaded &&
                  semester is CSemestersLoadedCourses) {
                BlocProvider.of<BlocUser>(context).add(
                  LoadedUserEvent(
                      cSemesters: semester.cSemesters,
                      userModelInfo: info.userModelInfo),
                );
              }
              return TestInfo();
            }),
          ),
        ),
      ),
    );
  }
}
