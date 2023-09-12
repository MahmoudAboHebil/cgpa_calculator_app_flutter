import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_with_firestore_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeWithFireStorePage(),
            ));

        return false;
      },
      child: Container(
        color: Color(0xffb8c8d1),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              child: Scaffold(
                backgroundColor: Color(0xffb8c8d1),
                appBar: AppBar(
                  backgroundColor: Colors.blueGrey.shade400,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeWithFireStorePage(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10, top: 5),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
