import 'package:flutter/material.dart';
import 'signin.dart';
import 'HomeWithFireStoreFinal.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffb8c8d1),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xffb8c8d1),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 150),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: Image.asset(
                      'images/study3.png',
                      height: 250,
                      width: 250,
                    ),
                  ),
                  RichText(
                    maxLines: 2,
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'A simple way to find the best with CGPA App  ',
                          style: TextStyle(
                              color: Color(0xff004d60),
                              fontSize: 26,
                              wordSpacing: 2,
                              height: 1.4)),
                      WidgetSpan(
                          child: Icon(
                        Icons.rocket_launch,
                        size: 25,
                        color: Color(0xff6e1783),
                      )),
                    ]),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Siginin(),
                            ));
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: Color(0xff4562a7),
                          size: 30,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
