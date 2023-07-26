import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'online app/auth_servieses.dart';
import 'online app/pages/welcome_page.dart';
import 'offline app/provider_brain.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('courses00');
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
        theme: ThemeData().copyWith(
            textSelectionTheme: TextSelectionThemeData(
                selectionColor: Colors.transparent,
                selectionHandleColor: Colors.transparent)),
        home: WelcomePage(),
      ),
    );
  }
}
