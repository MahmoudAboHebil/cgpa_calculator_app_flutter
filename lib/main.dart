import 'package:cgp_calculator/online%20app/data/repository/user_info_repo/user_info_repo.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_info/bloc_info.dart';
import 'package:cgp_calculator/online%20app/testInfo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'online app/auth_servieses.dart';
import 'online app/logic/bloc_info/bloc_info_events.dart';
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
        home: RepositoryProvider<UserInfoRepo>(
          create: (context) => UserInfoRepo(),
          child: BlocProvider<BlocInfo>(
            create: (context) => BlocInfo(
              userInfoRepo: RepositoryProvider.of<UserInfoRepo>(context),
              email: 'Mahmoud@gmail.com',
            )..add(LoadedInfoUserEvent()),
            child: TestInfo(),
          ),
        ),
      ),
    );
  }
}
