import 'package:cgp_calculator/test.dart';
import 'package:flutter/material.dart';
import 'pages/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home.dart';
import 'package:provider/provider.dart';
import 'providerBrain.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('course1');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyData>(
      create: (context) => MyData(),
      child: MaterialApp(
        theme: ThemeData().copyWith(
            textSelectionTheme: TextSelectionThemeData(
                selectionColor: Colors.transparent,
                selectionHandleColor: Colors.transparent)),
        home: HomePage(),
      ),
    );
  }
}
