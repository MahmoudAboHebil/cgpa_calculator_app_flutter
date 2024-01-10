import 'package:cgp_calculator/online%20app/models/courses_service.dart';
import 'package:cgp_calculator/online%20app/pages/courses_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../online app/auth_servieses.dart';
import '../online app/pages/expect_the_cgpa_page.dart';
import '../online app/pages/home_with_firestore_page.dart';
import '../online app/pages/home_with_semester_page.dart';
import '../online app/pages/profile_page.dart';
import '../online app/pages/review_page.dart';
import '../online app/pages/sign_in_page.dart';

class DrawerUI extends StatefulWidget {
  const DrawerUI({super.key});

  @override
  State<DrawerUI> createState() => _DrawerUIState();
}

class _DrawerUIState extends State<DrawerUI> {
  String email = '';
  String name = '';
  String imageURL = '';
  String division = '';
  String department = '';
  bool collageOption = false;
  bool departmentOption = false;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> message(
      String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        // behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.none,
        elevation: 0,
        content: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Color(0xff4562a7),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 48,
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 25,
                left: 20,
                child: Icon(
                  Icons.circle,
                  color: Colors.red.shade200,
                  size: 17,
                )),
            Positioned(
                top: -20,
                left: 5,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    Icon(
                      Icons.clear_outlined,
                      color: Colors.white,
                      size: 20,
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget headerContent() {
    // here we get data from dataBase

    // if data is done (ok)
    // email = value;
    // name = value;
    // imageURL = value;
    // division = value;
    // department = value;
    // collageOption = value;
    // departmentOption =value;

    // if there any error in dataBase (problem)
    // email = '';
    // name ='';
    // imageURL = '';
    // division = '';
    // department = '';
    // collageOption = '';
    // departmentOption ='';

    return name.isEmpty
        ? Center(
            child: Text(
              'Loading .... ',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //######### IMAGE
              imageURL.isEmpty // true  user does not enter an image
                  ? Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Color(0xff4562a7),
                              // Color(0xff4562a7)
                              borderRadius:
                                  BorderRadius.all(Radius.circular(200)),
                              border:
                                  Border.all(color: Colors.white54, width: 4)),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'images/user3.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    )
                  : // false
                  Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Color(0xff4562a7),
                              // Color(0xff4562a7)
                              borderRadius:
                                  BorderRadius.all(Radius.circular(200)),
                              border:
                                  Border.all(color: Colors.white54, width: 4)),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            imageURL,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
              //##########################
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                email,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis),
              ),
              SizedBox(
                height: 5,
              ),
              department.isNotEmpty
                  ? Text(
                      department,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis),
                    )
                  : SizedBox(),
              division.isNotEmpty
                  ? Text(
                      division,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis),
                    )
                  : SizedBox(),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            //####################  top  content ##################
            Container(
              height:
                  // true || true
                  department.isEmpty || division.isEmpty ? 250 : 270,
              color: Color(0xff4562a7),
              child: headerContent(),
              padding: EdgeInsets.all(10),
            ),

            //####################  center content ##################
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.home_outlined),
                    title: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeWithFireStorePage(),
                              ));
                        },
                        child: Text('Home')),
                  ),
                  ListTile(
                    leading: Icon(Icons.school_sharp),
                    title: GestureDetector(
                        onTap: () async {
                          //ddddd
                          Scaffold.of(context).closeDrawer();
                        },
                        child: Text('With Semester')),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.lightbulb_rounded,
                    ),
                    title: GestureDetector(
                        onTap: () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExpectTheCGPAPage(),
                            ),
                          );
                        },
                        child: Text('Expectation')),
                  ),
                  ListTile(
                    leading: Icon(Icons.reviews),
                    title: GestureDetector(
                        onTap: () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewPage(allSemesters),
                            ),
                          );
                        },
                        child: Text('Review')),
                  ),
                  email.isNotEmpty &&
                          CollegeService.divisions.contains(division) &&
                          collageOption
                      ? ListTile(
                          leading: Icon(Icons.reviews),
                          title: GestureDetector(
                              onTap: () async {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CoursesPage(),
                                  ),
                                );
                              },
                              child: Text('College Courses')),
                        )
                      : SizedBox(),
                  ListTile(
                    leading: Icon(Icons.person_rounded),
                    title: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(email, name,
                                    imageURL, division, department),
                              ));
                        },
                        child: Text('Profile')),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout_outlined),
                    title: GestureDetector(
                      onTap: () async {
                        //###################
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //####################  bottom content ##################

            email.isNotEmpty && CollegeService.divisions.contains(division)
                ? Container(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            height: 18,
                            width: 18,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              border: Border.all(color: Colors.grey, width: 2),
                            ),
                            child: Container(
                              height: 10,
                              width: 10,
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: collageOption
                                    ? Colors.green
                                    : Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                              ),
                            ),
                          ),
                          title: GestureDetector(
                            onTap: () {
                              setState(() {
                                collageOption = !collageOption;
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomeWithFireStorePage(),
                                  ));
                            },
                            child: Text('Enable Collage System'),
                          ),
                        ),
                        collageOption
                            ? ListTile(
                                leading: Container(
                                  height: 18,
                                  width: 18,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    border: Border.all(
                                        color: Colors.grey, width: 2),
                                  ),
                                  child: Container(
                                      height: 10,
                                      width: 10,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: departmentOption
                                            ? Colors.green
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                      )),
                                ),
                                title: GestureDetector(
                                  onTap: () {},
                                  child: Text('Enable department System'),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  )
                : SizedBox(),
            SizedBox()
          ],
        ),
      ),
    );
  }
}
