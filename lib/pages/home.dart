import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cgp_calculator/test.dart';
import 'package:provider/provider.dart';
import 'package:cgp_calculator/providerBrain.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });
        print(loggedInUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffb8c8d1),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xffb8c8d1),
          body: ListView(
            children: [
              AppBarHome(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      // height: 50,
                      // width: 100,
                      decoration: BoxDecoration(
                          color: Color(0xffeaf1ed),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border:
                              Border.all(color: Color(0xff004d60), width: 2)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Text(
                          'Semester 1',
                          style: TextStyle(
                            color: Color(0xff4562a7),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          // height: 50,
                          // width: 100,
                          decoration: BoxDecoration(
                              color: Color(0xffeaf1ed),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border:
                                  Border.all(color: Colors.white, width: 2)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Text(
                              'Course Name',
                              style: TextStyle(
                                color: Color(0xff004d60),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          // height: 50,
                          // width: 100,
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                              color: Color(0xffeaf1ed),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border:
                                  Border.all(color: Colors.white, width: 2)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Text(
                              'Credit',
                              style: TextStyle(
                                color: Color(0xff004d60),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          // height: 50,
                          // width: 100,
                          decoration: BoxDecoration(
                              color: Color(0xffeaf1ed),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border:
                                  Border.all(color: Colors.white, width: 2)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Text(
                              'Course Grade',
                              style: TextStyle(
                                color: Color(0xff004d60),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Course(),
                    Course(),
                    Course(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          // height: 50,
                          // width: 100,
                          decoration: BoxDecoration(
                              color: Color(0xffeaf1ed),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border:
                                  Border.all(color: Colors.white, width: 2)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            child: Text(
                              'Delete Course',
                              style: TextStyle(
                                color: Color(0xff004d60),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          // height: 50,
                          // width: 100,
                          decoration: BoxDecoration(
                              color: Color(0xffeaf1ed),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border:
                                  Border.all(color: Colors.white, width: 2)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            child: Text(
                              'Add Course',
                              style: TextStyle(
                                color: Color(0xff004d60),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Provider.of<MyData>(context).isChanged
                  ? Container(
                      width: 200,
                      height: 100,
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<MyData>(context, listen: false)
                              .change(false);
                        },
                        child: Center(
                          child: Text(
                            'Changed',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

class Course extends StatefulWidget {
  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 125,
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Color(0xff004d60)),
              onChanged: (value) {
                Provider.of<MyData>(context, listen: false).change(true);
                print('##############################################');
                print(Provider.of<MyData>(context, listen: false).isChanged);
              },
              decoration: InputDecoration(
                hintText: 'Enter Course',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff4562a7),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 60,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 18, color: Color(0xff4562a7)),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff4562a7),
                  ),
                ),
              ),
            ),
          ),
          DropMenuWithIcon(),
        ],
      ),
    );
  }
}

class AppBarHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xffeaf1ed),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xff4562a7),
                    size: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: Color(0xffce2029),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    'CGPA Calculator',
                    style: TextStyle(
                      color: Color(0xff004d60),
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 70,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Icon(
                      Icons.lightbulb_rounded,
                      color: Color(0xff4562a7),
                      size: 25,
                    ),
                  ),
                  Icon(
                    Icons.settings,
                    color: Color(0xff4562a7),
                    size: 25,
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'CGPA',
                                  style: TextStyle(
                                      color: Color(0xff4562a7),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                '2.75',
                                style: TextStyle(
                                    color: Color(0xff4562a7),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        LinearPercentIndicator(
                          width: 250,
                          lineHeight: 15,
                          percent: 0.5,
                          backgroundColor: Colors.grey.shade400,
                          progressColor: Color(0xff4562a7),
                          animation: true,
                          barRadius: Radius.circular(10),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 20),
                        child: Text(
                          'Total Credits',
                          style: TextStyle(
                            color: Color(0xff004d60),
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          '185',
                          style: TextStyle(
                            color: Color(0xff004d60),
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
