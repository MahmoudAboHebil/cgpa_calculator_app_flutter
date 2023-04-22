import 'package:flutter/material.dart';

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
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'images/study3.png',
                    height: 250,
                    width: 250,
                  ),
                ),
                Flexible(
                  child: RichText(
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
                ),
                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xff4562a7),
                    ),
                    backgroundColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
