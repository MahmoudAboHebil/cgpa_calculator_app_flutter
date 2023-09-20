import 'package:cgp_calculator/online%20app/home_with_firestore_services.dart';
import 'package:cgp_calculator/online%20app/pages/welcome_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:collection/collection.dart';
import '../../widgets/my_custom_appbar.dart';
import '../../widgets/my_navigation_drawer.dart';
import '../models/courses_service.dart';
import '../models/semester.dart';
import 'home_with_semester_page.dart';

// [[semesterNum,courseName,credit,grade1,grade2,('two' for two grade otherwise 'one'),id ],....]
// ToDo:  the calcCPA button disappear when adding a new semester (done - but there is a Special case when removing a course)
// ToDo:  profile sitting  (done - but there is no implementation for Department field in DB )
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

bool isTab = false;
int earnCredit = 0;

List allSemesters = [
  // // semester one
  // [
  //   ['1', null, null, null, null, 'one', '1'],
  //   ['1', null, null, null, null, 'one', '2']
  // ],
  // // semester two
  // [
  //   ['2', null, null, null, null, 'one', '3']
  // ],
  // // semester three
];
int countOccurrencesUsingLoop(List values, String? element) {
  if (values.isEmpty) {
    return 0;
  }

  int count = 0;
  for (String? value in values) {
    if (value == element) {
      count++;
    }
  }

  return count;
}

Future<dynamic> departmentMessage(BuildContext _context) {
  return showDialog(
      context: _context,
      builder: (context) => AlertDialog(
            alignment: Alignment.center,
            backgroundColor: Color(0xffb8c8d1),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "congratulation!",
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Now, you can choose your department at profile page",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff4562a7),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Is your department Computer Science and Statistics (Alex)?",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff4562a7),
                  ),
                ),
              ],
            ),
            // alignment: Alignment.center,

            actions: [
              TextButton(
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                onPressed: () async {
                  CoursesService.departmentOption = false;
                  await FirebaseFirestore.instance
                      .collection('UsersInfo')
                      .doc(loggedInUser!.email)
                      .update({
                    'departmentOption': false,
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Yes",
                    style: TextStyle(color: Colors.green, fontSize: 18)),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('UsersInfo')
                      .doc(loggedInUser!.email)
                      .update({
                    'departmentOption': true,
                    'department': 'Computer Science and Statistics (Alex)',
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomePage(),
                    ),
                  );
                },
              ),
            ],
          ));
}

User? loggedInUser;
CollectionReference? _courses;

CollectionReference? semestersRef;
bool showSpinner = true;
late HomeWithFireStoreServices? homeWithFireStoreServices;

class HomeWithFireStorePage extends StatefulWidget {
  @override
  State<HomeWithFireStorePage> createState() => _HomeWithFireStorePageState();
}

class _HomeWithFireStorePageState extends State<HomeWithFireStorePage> {
  final _keySemester = GlobalKey<AnimatedListState>();
  final _pageViewController = PageController();
  final _auth = FirebaseAuth.instance;
  CollectionReference? _usersInfo =
      FirebaseFirestore.instance.collection('UsersInfo');
  List<bool> isChangeList =
      []; // to update calc_GPA button when there is any changing  in the course
  List keySemesters = [];
  var uuid = Uuid();
  bool _visible = true;
  double CGPA = 0.0;
  double CGPAPage2 = 0.0;
  int totalCreditPage2 = 0;
  int totalCredit = 0;
  bool flag = true;
  bool flag2 = true;
  bool calcFlag = true;
  String division = '';
  String department = '';
  // bool showSpinner2 = true;
  callBackChangeList(int index, bool value, remove) {
    setState(() {
      if (remove) {
        isChangeList.removeAt(index);
      } else {
        isChangeList[index] = value;
      }
    });
  }

  callBackPage2(double cgpa, int credits) {
    setState(() {
      CGPAPage2 = cgpa;
      totalCreditPage2 = credits;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _courses = null;
      _usersInfo = null;
      semestersRef = null;
      loggedInUser = null;
      showSpinner = true;
      allSemesters.clear();
      allSemesters2.clear();
      homeWithFireStoreServices = null;
    });
    getCurrentUser();
    setState(() {
      _usersInfo = FirebaseFirestore.instance.collection('UsersInfo');
    });
  }

  Widget getInfo() {
    setState(() {
      _usersInfo = FirebaseFirestore.instance.collection('UsersInfo');
    });
    if (_usersInfo != null && loggedInUser != null) {
      return StreamBuilder(
        stream: _usersInfo!.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData &&
              loggedInUser != null &&
              snapshot.data != null) {
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              final DocumentSnapshot userInfo = snapshot.data!.docs[i];
              if (userInfo['email'] == loggedInUser!.email) {
                division = userInfo['division'];
                department = userInfo['department'];
                CoursesService.systemOption = userInfo['divisionOption'];
                CoursesService.departmentOption = userInfo['departmentOption'];
              }
            }
          }
          if (CoursesService.divisions.contains(division)) {
            CoursesService.divisionName = division;
          }
          if (CoursesService.departments.contains(department)) {
            CoursesService.departmentName = department;
          }

          return Container();
        },
      );
    } else {
      return Container();
    }
  }

  static Future<bool> checkExist(String docID) async {
    bool exist = false;
    try {
      await FirebaseFirestore.instance
          .doc("UsersCourses/$docID")
          .get()
          .then((doc) {
        exist = doc.exists;
      });
      return exist;
    } catch (e) {
      // If any error
      return false;
    }
  }

  void setNewUser(User user) async {
    await FirebaseFirestore.instance
        .collection('UsersCourses')
        .doc('${user.email}')
        .set({'email': '${user.email}'});

    await FirebaseFirestore.instance
        .collection('UsersCourses')
        .doc('${user.email}')
        .collection('courses')
        .doc('init')
        .set({
      'courseName': null,
      'credit': null,
      'grade1': null,
      'grade2': null,
      'semestId': -1,
      'type': 'one',
      'id': 'init',
    });
    await FirebaseFirestore.instance
        .collection('UsersSemesters')
        .doc('${user.email}')
        .set({'email': '${user.email}'});

    await FirebaseFirestore.instance
        .collection('UsersSemesters')
        .doc('${user.email}')
        .collection('Semesters')
        .doc('init')
        .set({
      'semesterId': 'first',
      'semesterIndex': -1,
      'SGPA': null,
      'Credits': null,
    });
    setState(() {
      _courses = FirebaseFirestore.instance
          .collection('UsersCourses')
          .doc('${user.email}')
          .collection('courses');
      semestersRef = FirebaseFirestore.instance
          .collection('UsersSemesters')
          .doc('${user.email}')
          .collection('Semesters');
    });
  }

  void getCurrentUser() async {
    setState(() {
      showSpinner = true;
    });
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        bool exist = await checkExist('${user.email}');
        setState(() {
          loggedInUser = user;
          if (!exist) {
            setNewUser(user);
          } else {
            _courses = FirebaseFirestore.instance
                .collection('UsersCourses')
                .doc('${user.email}')
                .collection('courses');
            semestersRef = FirebaseFirestore.instance
                .collection('UsersSemesters')
                .doc('${user.email}')
                .collection('Semesters');
          }
        });
        // print(loggedInUser!.email);
      }
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      print(e);
    }
  }

  int maxSemester = 0;

  Widget Content() {
    if (_courses != null) {
      return StreamBuilder(
        stream: _courses!.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            List<int> keys = [];
            for (int i = 0; i < streamSnapshot.data!.docs.length; i++) {
              final DocumentSnapshot course = streamSnapshot.data!.docs[i];

              keys.add(course['semestId']);
            }
            maxSemester = keys.max;
            keys = keys.toSet().toList();
            keys.sort();
            keys.remove(-1);
            if (flag) {
              for (int i = 0; i < keys.length; i++) {
                if (allSemesters.length < keys.length) {
                  allSemesters.add(getSemesterCourses(keys[i], streamSnapshot));
                }
              }
              if (allSemesters.isEmpty) {
                // print('jerrrrrrrrrrrrrrr');
                allSemesters = [
                  [
                    [
                      1,
                      null,
                      null,
                      null,
                      null,
                      'one',
                      'firstCourse',
                    ]
                  ]
                ];
                homeWithFireStoreServices!.addCourseInDB(
                    1, 'firstCourse', null, null, null, null, 'one');
              }
              isChangeList = [];
              for (int i = 0; i < keys.length; i++) {
                isChangeList.add(false);
              }
              // print(isChangeList);
              if (isChangeList.isEmpty) {
                isChangeList = [false];
              }
              Future.delayed(Duration.zero, () {
                calcCGPA();
              });
              flag = false;
            }

            // print(allSemesters.length);

            return AnimatedList(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              initialItemCount: allSemesters.length,
              key: _keySemester,
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  key: ObjectKey(allSemesters[index][0][0]),
                  child: allSemesters.isNotEmpty
                      ? SemesterFin(
                          allSemesters[index],
                          allSemesters[index][0][0],
                          index,
                          department,
                          () {
                            setState(() {
                              calcCGPA();
                            });
                          },
                          _keySemester,
                          isChangeList[index],
                          callBackChangeList,
                        )
                      : Container(),
                );
              },
            );
          } else {
            return Container();
          }
        },
      );
    } else {
      return Container();
    }
  }

  List getSemesterCourses(int ID, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
    List courses = [];
    for (int i = 0; i < streamSnapshot.data!.docs.length; i++) {
      final DocumentSnapshot course = streamSnapshot.data!.docs[i];
      if (course['semestId'] == ID && course.id != 'init') {
        courses.add([
          course['semestId'],
          course['courseName'],
          course['credit'],
          course['grade1'],
          course['grade2'],
          course['type'],
          course['id'],
        ]);
      }
    }
    // print(courses);
    return courses;
  }

  callBackToUpdateAllSemestersList(List allSemest) {
    setState(() {
      allSemesters = allSemest;
    });
  }

  void addSemester() {
    setState(() {
      // String year = DateTime.now().year.toString();
      // String month = DateTime.now().month.toString();
      // String day = DateTime.now().day.toString();
      // String hour = DateTime.now().hour.toString();
      // String minute = DateTime.now().minute.toString();
      // String second = DateTime.now().second.toString();
      // String semestDateID = '$year-$month-$day-$hour-$minute-$second';
      int insertIndex =
          allSemesters.isEmpty ? allSemesters.length : allSemesters.length - 1;

      var uniqueId = uuid.v1();
      allSemesters.add([
        [maxSemester + 1, null, null, null, null, 'one', uniqueId]
      ]);
      isChangeList.add(false);
      // print([maxSemester + 1, null, null, null, null, 'one', uniqueId]);
      homeWithFireStoreServices!.addCourseInDB(
          maxSemester + 1, uniqueId, null, null, null, null, 'one');
      _keySemester.currentState!
          .insertItem(insertIndex, duration: Duration(milliseconds: 0));
    });
  }

  void calcCGPA() {
    int totalCredit_without_SU = 0;
    double totalPointsOfSemest = 0.0;
    setState(() {
      CGPA = 0.0;
      earnCredit = 0;
      totalCredit = 0;
    });
    // print('#####################  CGPA ##########################');
    // print(allSemesters);
// [[semesterNum,courseName,credit,grade1,grade2,('two' for two grade otherwise 'one') ],....]
    if (allSemesters.isNotEmpty) {
      for (List semester in allSemesters) {
        // semester = [[],[],]

        for (List course in semester) {
          // course = [ ]
          // print('course');
          // print(course);
          if (course[1] != null && course[2] != null && course[3] != null) {
            String grade1 = course[3];
            int credit = int.parse(course[2]);
            double pointOfGrade = 0.0;
            double pointOfCourse = 0.0;
            setState(() {
              if (grade1 == 'A') {
                pointOfGrade = 4.00;
              } else if (grade1 == 'A-') {
                pointOfGrade = 3.67;
              } else if (grade1 == 'B+') {
                pointOfGrade = 3.33;
              } else if (grade1 == 'B') {
                pointOfGrade = 3.00;
              } else if (grade1 == 'B-') {
                pointOfGrade = 2.67;
              } else if (grade1 == 'C+') {
                pointOfGrade = 2.33;
              } else if (grade1 == 'C') {
                pointOfGrade = 2.00;
              } else if (grade1 == 'C-') {
                pointOfGrade = 1.67;
              } else if (grade1 == 'D+') {
                pointOfGrade = 1.33;
              } else if (grade1 == 'D') {
                pointOfGrade = 1.00;
              } else if (grade1 == 'F') {
                pointOfGrade = 0.00;
              } else if (grade1 == 'S') {
                pointOfGrade = -1.00;
              } else if (grade1 == 'Non') {
                pointOfGrade = -3.00;
              } else {
                pointOfGrade = -2.00;
              }
            });
            setState(() {
              if (pointOfGrade >= 0.00) {
                // not s/u course
                totalCredit_without_SU = totalCredit_without_SU + credit;
                totalCredit = totalCredit + credit;
                pointOfCourse = pointOfGrade * credit;
                totalPointsOfSemest = totalPointsOfSemest + pointOfCourse;
              } else {
                // s/u course
                totalCredit = totalCredit + credit;
              }

              if (!(pointOfGrade == 0.00 ||
                  pointOfGrade == -2.00 ||
                  pointOfGrade == -3.00)) {
                //  passed course
                earnCredit = earnCredit + credit;
              }
            });
          }
        }
      }
      setState(() {
        if (totalPointsOfSemest == 0.0 && totalCredit_without_SU == 0) {
          CGPA = 0.0;
        } else {
          CGPA = (totalPointsOfSemest / totalCredit_without_SU);
        }
        if (CGPA > 4.0) {
          CGPA = 4.0;
        }
      });
    } else {
      // print('################## Empty CGPA#################');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (flag2 && loggedInUser != null && _courses != null) {
      setState(() {
        homeWithFireStoreServices =
            HomeWithFireStoreServices(_courses!, loggedInUser!);
        flag2 = false;
      });
    }
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Container(
        color: Color(0xffb8c8d1),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                isTab = !isTab;
              });
            },
            child: Scaffold(
              backgroundColor: Color(0xffb8c8d1),
              drawer: MyNavigationDrawer(_pageViewController),
              body: ModalProgressHUD(
                inAsyncCall: showSpinner,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _visible
                        ? MyCustomAppBar(100, CGPA, earnCredit, totalCredit)
                        : MyCustomAppBar(
                            100, CGPAPage2, totalCreditPage2, totalCreditPage2),
                    Expanded(
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        controller: _pageViewController,
                        allowImplicitScrolling: true,
                        padEnds: false,
                        onPageChanged: (page) {
                          setState(() {
                            if (page == 1) {
                              _visible = false;
                            } else {
                              _visible = true;
                            }
                          });
                        },
                        children: [
                          Stack(
                            children: [
                              ScrollConfiguration(
                                behavior: MyBehavior(),
                                child: ListView(
                                  shrinkWrap: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    showSpinner ? Container() : Content(),
                                    showSpinner ? Container() : getInfo(),
                                    SizedBox(
                                      height: 100,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          HomeWithSemesterPage(callBackPage2),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              floatingActionButton: Visibility(
                visible: _visible,
                child: FloatingActionButton(
                  backgroundColor: Color(0xff4562a7),
                  onPressed: () async {
                    addSemester();
                    if (CoursesService.isGlobalDepartmentValidationOK() &&
                        CoursesService.departmentOption &&
                        department.isEmpty &&
                        CoursesService.systemOption) {
                      departmentMessage(context);
                    }
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
