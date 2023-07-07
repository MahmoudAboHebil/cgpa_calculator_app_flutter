import 'package:flutter/material.dart';

class ExpectTheCGPAPage extends StatefulWidget {
  const ExpectTheCGPAPage({super.key});

  @override
  State<ExpectTheCGPAPage> createState() => _ExpectTheCGPAPageState();
}

class _ExpectTheCGPAPageState extends State<ExpectTheCGPAPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffb8c8d1),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff1E5162), Color(0xff296E85)],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 300,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Current CGPA',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff296E85),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                      width: 150,
                                      height: 75,
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        autofocus: false,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff67B7D1),
                                        ),
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'CGPA',
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 18),
                                        ),
                                      ))
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Current Cradits',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff296E85),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                      width: 150,
                                      height: 75,
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        autofocus: false,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff67B7D1),
                                        ),
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Cradits',
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 18),
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Semester GPA',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff296E85),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                      width: 150,
                                      height: 75,
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        autofocus: false,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff67B7D1),
                                        ),
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'GPA',
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 18),
                                        ),
                                      ))
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Semester Credits',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff296E85),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                      width: 150,
                                      height: 75,
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        autofocus: false,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff67B7D1),
                                        ),
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Credits',
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 18),
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 300,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
