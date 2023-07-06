import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import 'package:cgp_calculator/authServieses.dart';
import 'signin.dart';
import 'profilePage.dart';

//test
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

bool showSpinner = true;

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
User? loggedInUser;
CollectionReference? _courses;

void addCourseInDB(int semestID, String courseId, String? name, String? credit,
    String? grade1, String? grade2, String type) async {
  await FirebaseFirestore.instance
      .collection('UsersCourses')
      .doc('${loggedInUser!.email}')
      .collection('courses')
      .doc(courseId)
      .set({
    'courseName': name,
    'credit': credit,
    'grade1': grade1,
    'grade2': grade2,
    'semestId': semestID,
    'type': type,
    'id': courseId,
  });
}

void updateData(var semestId, var courseId, var name, var credit, var grade1,
    var grade2, var type) async {
  await _courses!.doc(courseId).set({
    'id': courseId,
    'courseName': name,
    'credit': credit,
    'grade1': grade1,
    'grade2': grade2,
    'semestId': semestId,
    'type': '$type',
  });
}

void deleteSemesterFromDB(int semesterId) async {
  await _courses!.get().then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      final DocumentSnapshot course = doc;
      if (course['semestId'] == semesterId) {
        String id = course.id;
        _courses!.doc(id).delete();
      }
    });
  });
}

void deleteCourseFromDB(String courseId) async {
  _courses!.doc(courseId).delete();
}

class HomePageFin extends StatefulWidget {
  @override
  State<HomePageFin> createState() => _HomePageFinState();
}

class _HomePageFinState extends State<HomePageFin> {
  final _keySemester = GlobalKey<AnimatedListState>();
  final _auth = FirebaseAuth.instance;
  List<bool> isChangeList = [];
  List keySemesters = [];
  var uuid = Uuid();
  bool _visible = true;
  double CGPA = 0.0;
  int earnCredit = 0;
  int totalCredit = 0;
  bool flag = true;
  bool calcFlag = true;
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

  @override
  void initState() {
    super.initState();
    setState(() {
      _courses = null;
      loggedInUser = null;
      showSpinner = true;
      allSemesters.clear();
    });
    getCurrentUser();
    // Future.delayed(Duration(seconds: 3), () {
    //   calcCGPA();
    // });
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

    setState(() {
      _courses = FirebaseFirestore.instance
          .collection('UsersCourses')
          .doc('${user.email}')
          .collection('courses');
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
                print('jerrrrrrrrrrrrrrr');
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
                addCourseInDB(1, 'firstCourse', null, null, null, null, 'one');
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

            print(allSemesters.length);

            return AnimatedList(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              initialItemCount: allSemesters.length,
              key: _keySemester,
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  key: UniqueKey(),
                  child: allSemesters.isNotEmpty
                      ? SemesterFin(
                          allSemesters[index],
                          allSemesters[index][0][0],
                          index,
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
      print([maxSemester + 1, null, null, null, null, 'one', uniqueId]);
      addCourseInDB(maxSemester + 1, uniqueId, null, null, null, null, 'one');
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
    print('#####################  CGPA ##########################');
    print(allSemesters);
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

              if (!(pointOfGrade == 0.00 || pointOfGrade == -2.00)) {
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
      });
    } else {
      print('################## Empty CGPA#################');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // final prov = Provider.of<AuthServer>(context, listen: false);
        // prov.googleLogout();
        //
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => Siginin(),
        //     ));
        //
        return false;
      },
      child: Container(
        color: Color(0xffb8c8d1),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
                backgroundColor: Color(0xffb8c8d1),
                drawer: NavigationDrawer(),
                body: ModalProgressHUD(
                  inAsyncCall: showSpinner,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyCustomAppBar(100, CGPA, earnCredit, totalCredit),
                      Flexible(
                          child: Stack(
                        children: [
                          ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  showSpinner ? Container() : Content(),
                                  SizedBox(
                                    height: 50,
                                  )
                                ],
                              ))
                        ],
                      ))
                    ],
                  ),
                ),
                floatingActionButton: Visibility(
                  visible: _visible,
                  child: FloatingActionButton(
                    backgroundColor: Color(0xff4562a7),
                    onPressed: () async {
                      // calcCGPA();
                      addSemester();
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

class MyCustomAppBar extends StatelessWidget {
  final double height;
  double cgpa;
  int earnCredit;
  int totalCredit;

  MyCustomAppBar(this.height, this.cgpa, this.earnCredit, this.totalCredit);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.only(top: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: IconButton(
              icon: Icon(
                Icons.menu,
                color: Color(0xff4562a7),
                size: 28,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          AppBarHomeFin(
            cgpa,
            earnCredit,
            totalCredit,
          ),
        ],
      ),
    );
  }
}

// bool isChanged = false;

class SemesterFin extends StatefulWidget {
  List semesterCourses;
  int semesterId;
  int index;
  Function calcCGPA;
  bool isChanged;
  Function ChangeList;
  GlobalKey<AnimatedListState> _allSemestersKey;
  SemesterFin(this.semesterCourses, this.semesterId, this.index, this.calcCGPA,
      this._allSemestersKey, this.isChanged, this.ChangeList,
      {Key? key})
      : super(key: key);

  @override
  State<SemesterFin> createState() => _SemesterFinState();
}

class _SemesterFinState extends State<SemesterFin> {
  final _keyAniListCourses = GlobalKey<AnimatedListState>();
  // late List<GlobalObjectKey<_CourseFinState>> _courseKeys;
  Tween<Offset> _offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));
  var uuid = Uuid();

  List listOfCoursesInSemester = [];
  List<int?> errorTypeName = [];
  // 1 mean that some fields are empty

  List<int?> errorTypeCredit = [];
  // 1 mean that some fields are empty
  // 2 means that the credit is more than three numbers
  // 3 means that the credit  equals zero

  List<int?> errorTypeGrade = [];
  // 1 mean that some fields are empty

  String? emptyField;
  String? creditMoreThanThree;
  String? creditEqZero;

  double GPA = 0.0;
  int earnCredit = 0;
  int totalCredit = 0;
  List allCoursesInSemstd = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      listOfCoursesInSemester = widget.semesterCourses;
      if (!widget.isChanged) {
        calcGPA();
      }
    });
  }

  callbackIsChanged() {
    setState(() {
      widget.ChangeList(widget.index, true, false);
    });
  }

  callBackToUpdateTheCoursesList(newList) {
    setState(() {
      listOfCoursesInSemester = newList;
    });
  }

  void findErrors() {
    for (List course in listOfCoursesInSemester) {
      // not empty course
      if (!(course[1] == null &&
          course[2] == null &&
          course[3] == null &&
          course[4] == null)) {
        //name validation
        if (course[1] == null ||
            course[1].isEmpty ||
            course[1].trim().isEmpty) {
          setState(() {
            errorTypeName.add(1);
          });
        } else {
          setState(() {
            errorTypeName.add(null);
          });
        }

        // credit validation
        if (course[2] == null ||
            course[2].isEmpty ||
            course[2].trim().isEmpty) {
          setState(() {
            errorTypeCredit.add(1);
          });
        } else if (course[2].trim().isNotEmpty || course[2].isNotEmpty) {
          if (course[2].length > 3) {
            setState(() {
              errorTypeCredit.add(2);
            });
          } else if (int.parse(course[2]) == 0 ||
              int.parse(course[2]) == 00 ||
              int.parse(course[2]) == 000) {
            setState(() {
              errorTypeCredit.add(3);
            });
          } else {
            setState(() {
              errorTypeCredit.add(null);
            });
          }
        }

        //grade validation
        if (course[3] == null ||
            course[3].isEmpty ||
            course[3].trim().isEmpty) {
          setState(() {
            errorTypeGrade.add(1);
          });
        } else {
          setState(() {
            errorTypeGrade.add(null);
          });
        }

        if ((course[4] == null ||
                course[4].isEmpty ||
                course[4].trim().isEmpty) &&
            course[5] == 'two') {
          setState(() {
            errorTypeGrade.add(1);
          });
        } else {
          setState(() {
            errorTypeGrade.add(null);
          });
        }
      }
    }

    for (int? name in errorTypeName) {
      if (name == 1) {
        setState(() {
          emptyField = 'there is an empty field';
        });
      }
    }

    for (int? credit in errorTypeCredit) {
      if (credit == 1) {
        setState(() {
          emptyField = 'there is an empty field';
        });
      }
      if (credit == 2) {
        setState(() {
          creditMoreThanThree = 'the credit must be less than 3 numbers';
        });
      }

      if (credit == 3) {
        setState(() {
          creditEqZero = 'the credit must not equal Zero';
        });
      }
    }
    for (int? grade in errorTypeGrade) {
      if (grade == 1) {
        setState(() {
          emptyField = 'there is an empty field';
        });
      }
    }
  }

  void addCourse() {
    var uniqueId = uuid.v1();

    setState(() {
      listOfCoursesInSemester
          .add([widget.semesterId, null, null, null, null, 'one', uniqueId]);
      allSemesters[widget.index] = listOfCoursesInSemester;
    });
    // _courseKeys = List.generate(listOfCoursesInSemester.length, (index) {
    //   var uuid = Uuid();
    //   var uniqueId = uuid.v1();
    //   return GlobalObjectKey<_CourseFinState>(uniqueId);
    // });
    int insertIndex = listOfCoursesInSemester.isEmpty
        ? listOfCoursesInSemester.length
        : listOfCoursesInSemester.length - 1;
    _keyAniListCourses.currentState!
        .insertItem(insertIndex, duration: Duration(milliseconds: 250));
    print('theListAfterAdd:${listOfCoursesInSemester}');
    Future.delayed(Duration(milliseconds: 270), () {
      addCourseInDB(widget.semesterId, uniqueId, null, null, null, null, 'one');
    });
  }

  void deleteSemester() {
    setState(() {
      List deletedSemest = allSemesters.removeAt(widget.index);

      widget._allSemestersKey.currentState!.removeItem(widget.index,
          (context, animation) {
        return SlideTransition(
          position: animation.drive(_offset),
          child: SemesterFin(deletedSemest, widget.semesterId, widget.index,
              () {}, widget._allSemestersKey, false, () {}),
        );
      }, duration: Duration(milliseconds: 250));

      widget.calcCGPA();
    });
    deleteSemesterFromDB(widget.semesterId);
    widget.ChangeList(widget.index, false, true);
  }

  void calcGPA() {
    int totalCredit_without_SU = 0;
    double totalPointsOfSemest = 0.0;
    setState(() {
      GPA = 0.0;
      earnCredit = 0;
      totalCredit = 0;
    });

    List allCoursesInSemstd = [];
    setState(() {
      for (List list in listOfCoursesInSemester) {
        if (list[1] != null && list[2] != null && list[3] != null) {
          allCoursesInSemstd.add(list);
        }
      }
    });
    if (allCoursesInSemstd.isNotEmpty) {
      for (var value in allCoursesInSemstd) {
        String grade1 = value[3];
        // [[semesterNum,courseName,credit,grade1,grade2,('two' for two grade otherwise 'one') ],....]

        int credit = int.parse(value[2]);
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

          if (!(pointOfGrade == 0.00 || pointOfGrade == -2.00)) {
            //  passed course
            earnCredit = earnCredit + credit;
          }
        });
      }
      setState(() {
        if (totalPointsOfSemest == 0.0 && totalCredit_without_SU == 0) {
          GPA = 0.0;
        } else {
          GPA = (totalPointsOfSemest / totalCredit_without_SU);
        }
      });
      // print('################## semester #################');
      // print(allCoursesInSemstd);
      // print('GPA  : $GPA');
      // print('totalPointsOfSemest  : $totalPointsOfSemest');
      // print('totalCredit_without_SU  : $totalCredit_without_SU');
      // print('totalCredit  : $totalCredit');
      // print('earnCredit  : $earnCredit');
    } else {
      print('################## Empty GPA #################');
    }
  }

  bool isValide() {
    findErrors();
    if (emptyField == null &&
        creditEqZero == null &&
        creditMoreThanThree == null) {
      return true;
    } else {
      return false;
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> message() {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      clipBehavior: Clip.none,
      elevation: 0,
      content: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xff4562a7),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Oops Error!',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      emptyField != null
                          ? Text(
                              '$emptyField',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : SizedBox(
                              width: 0,
                              height: 0,
                            ),
                      creditMoreThanThree != null
                          ? Text(
                              '$creditMoreThanThree',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : SizedBox(
                              width: 0,
                              height: 0,
                            ),
                      creditEqZero != null
                          ? Text(
                              '$creditEqZero',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : SizedBox(
                              width: 0,
                              height: 0,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 25,
              left: 20,
              child: ClipRRect(
                child: Stack(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.red.shade200,
                      size: 17,
                    )
                  ],
                ),
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
                  Positioned(
                      top: 5,
                      child: Icon(
                        Icons.clear_outlined,
                        color: Colors.white,
                        size: 20,
                      ))
                ],
              )),
        ],
      ),
    ));
  }

  Widget dis() {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            '${listOfCoursesInSemester[index]}',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        );
      },
      itemCount: listOfCoursesInSemester.length,
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> Display() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 10),
        clipBehavior: Clip.none,
        elevation: 0,
        content: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xff4562a7),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        dis(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void collectDate() {
    for (List courseList in listOfCoursesInSemester) {
      var semesterID = courseList[0];
      var name = courseList[1];
      var credit = courseList[2];
      var selectedValue1 = courseList[3];
      var selectedValue2 = courseList[4];
      var type = courseList[5];
      var courseID = courseList[6];
      var val = type == 'one' ? false : true;

      if (val) {
        updateData(semesterID, courseID, name, credit, selectedValue1,
            selectedValue2, 'two');
      } else {
        updateData(
            semesterID, courseID, name, credit, selectedValue1, null, 'one');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    deleteSemester();
                  },
                  child: Icon(
                    Icons.delete_forever,
                    color: Color(0xffce2029),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  // height: 50,
                  width: 360,
                  margin: EdgeInsets.only(left: 5, bottom: 10, right: 10),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Colors.white54, width: 2),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 1,
                          color: Colors.grey,
                          spreadRadius: 0.1,
                          blurStyle: BlurStyle.outer)
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Semester',
                            style: TextStyle(
                                color: Color(0xff004d60),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${widget.index + 1}',
                            style: TextStyle(
                              color: Color(0xff4562a7),
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'GPA',
                            style: TextStyle(
                              color: Color(0xff004d60),
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${GPA.toStringAsFixed(3)}',
                            style: TextStyle(
                              color: Color(0xff4562a7),
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Earn credits',
                            style: TextStyle(
                              color: Color(0xff004d60),
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '$earnCredit / $totalCredit',
                            style: TextStyle(
                              color: Color(0xff4562a7),
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      alignment: Alignment.center,
                      // height: 50,
                      // width: 100,
                      decoration: BoxDecoration(
                          color: Color(0xffeaf1ed),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.white, width: 2)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Text(
                          'Course Name',
                          style: TextStyle(
                            color: Color(0xff004d60),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -10,
                      top: 12,
                      child: Icon(
                        Icons.not_listed_location_outlined,
                        color: Colors.green,
                        size: 28,
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  // height: 50,
                  // width: 100,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Color(0xffeaf1ed),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.white, width: 2)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.white, width: 2)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
            AnimatedList(
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  key: UniqueKey(),
                  child: CourseFin(
                    index,
                    widget.index,
                    listOfCoursesInSemester[index],
                    listOfCoursesInSemester,
                    callBackToUpdateTheCoursesList,
                    callbackIsChanged,
                    () {
                      widget.calcCGPA();
                    },
                    _keyAniListCourses,
                  ),
                );
              },
              initialItemCount: listOfCoursesInSemester.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              key: _keyAniListCourses,
            ),
            Row(
              mainAxisAlignment: widget.isChanged
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    addCourse();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: widget.isChanged
                        ? EdgeInsets.only(right: 30)
                        : EdgeInsets.only(right: 85),
                    decoration: BoxDecoration(
                        color: Color(0xffeaf1ed),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Colors.white, width: 2)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      child: Text(
                        'Add Course',
                        style: TextStyle(
                          color: Color(0xff004d60),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                widget.isChanged
                    ? GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();

                          findErrors();
                          if (emptyField == null &&
                              creditEqZero == null &&
                              creditMoreThanThree == null) {
                            collectDate();
                            calcGPA();
                            widget.calcCGPA();
                            setState(() {
                              widget.isChanged = false;
                              widget.ChangeList(widget.index, false, false);
                            });
                          } else {
                            message();
                          }
                          setState(() {
                            emptyField = null;
                            creditMoreThanThree = null;
                            creditEqZero = null;
                            errorTypeGrade.clear();
                            errorTypeCredit.clear();
                            errorTypeName.clear();
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: widget.isChanged
                              ? EdgeInsets.all(0)
                              : EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                              color: Color(0xff4562a7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border:
                                  Border.all(color: Colors.white, width: 2)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            child: Text(
                              'Calc GPA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.isChanged = true;
                            widget.ChangeList(widget.index, true, false);
                          });
                        },
                        child: AbsorbPointer(
                          child: Container(
                            margin: EdgeInsets.only(right: 18),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Color(0xff004d60),
                              size: 26,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CourseFin extends StatefulWidget {
  int index;
  int semesterIndex;
  List courseList;
  List listCoursesInSemester;
  Function CallBackUpdateList;
  Function CallBackUpdateChange;
  Function calcCGPA;

  GlobalKey<AnimatedListState> _keyAniSemest;
  CourseFin(
      this.index,
      this.semesterIndex,
      this.courseList,
      this.listCoursesInSemester,
      this.CallBackUpdateList,
      this.CallBackUpdateChange,
      this.calcCGPA,
      this._keyAniSemest,
      {Key? key})
      : super(key: key);

  @override
  State<CourseFin> createState() => _CourseFinState();
}

class _CourseFinState extends State<CourseFin> {
  late TextEditingController _controller_Name;
  late TextEditingController _controller_Credit;
  FocusNode _focusName = FocusNode();
  FocusNode _focusCredit = FocusNode();

  late String? selectedValue1;
  late String? selectedValue2;
  int semesterID = 0;
  String courseID = '';
  String? name = '';
  String? credit = '';
  String? type = '';
  late bool val;
  bool selectedValueIs1Null = false;
  bool selectedValueIs2Null = false;
  bool valideName = true;
  bool valideCredit = true;
  bool pressDeleteCourse = false;

  final List<String> items = [
    'A',
    'A-',
    'B+',
    'B',
    'B-',
    'C+',
    'C',
    'C-',
    'D+',
    'D',
    'F',
    'S',
    'U'
  ];

  @override
  void initState() {
    super.initState();
// [[semesterNum,courseName,credit,grade1,grade2,('two' for two grade otherwise 'one'),id ],....]
    _focusName.addListener(_onFocusNameChange);
    _focusCredit.addListener(_onFocusCreditChange);

    setState(() {
      semesterID = widget.courseList[0];
      name = widget.courseList[1];
      credit = widget.courseList[2];
      selectedValue1 = widget.courseList[3];
      selectedValue2 = widget.courseList[4];
      type = widget.courseList[5];
      courseID = widget.courseList[6];
      val = type == 'one' ? false : true;
      if (name == null) {
        _controller_Name = TextEditingController();
      } else {
        _controller_Name = TextEditingController(text: name);
      }
      if (credit == null) {
        _controller_Credit = TextEditingController();
      } else {
        _controller_Credit = TextEditingController(text: credit);
      }
    });
    validationMethod();
  }

  void _onFocusNameChange() {
    if (_focusName.hasFocus) {
    } else {
      String value = _controller_Name.text;
      if (value.isNotEmpty) {
        widget.listCoursesInSemester[widget.index][1] = value;
      } else {
        widget.listCoursesInSemester[widget.index][1] = null;
      }
      widget.CallBackUpdateList(widget.listCoursesInSemester);
      widget.CallBackUpdateChange();
    }
    errorGrade();
    validationMethod();
  }

  void _onFocusCreditChange() {
    if (_focusCredit.hasFocus) {
    } else {
      String value = _controller_Credit.text;
      if (value.isNotEmpty) {
        widget.listCoursesInSemester[widget.index][2] = value;
      } else {
        widget.listCoursesInSemester[widget.index][2] = null;
      }
      widget.CallBackUpdateList(widget.listCoursesInSemester);
      widget.CallBackUpdateChange();
    }
  }

  String? get _errorCredit {
    var Name = name ?? '';
    var Credit = credit ?? '';
    // if (pressed) {
    if (Credit.isNotEmpty && Credit.length > 3) {
      return '';
    }
    if (Credit.isNotEmpty &&
        (int.parse(Credit) == 0 ||
            int.parse(Credit) == 00 ||
            int.parse(Credit) == 000)) {
      return '';
    }

    if ((Name.isNotEmpty && Name.trim().isNotEmpty)) {
      if (Credit.isEmpty || Credit.trim().isEmpty) {
        return '';
      }
    } else if ((Credit.isEmpty || Credit.trim().isEmpty) &&
        (selectedValue1 != null || selectedValue2 != null)) {
      return '';
    }
    // }
    return null;
  }

  String? get _errorName {
    var Name = name ?? '';
    var Credit = credit ?? '';
    // if (pressed) {

    if (Credit.isNotEmpty && Credit.trim().isNotEmpty) {
      if (Name.isEmpty || Name.trim().isEmpty) {
        return '';
      }
    } else if ((Name.isEmpty || Name.trim().isEmpty) &&
        (selectedValue1 != null || selectedValue2 != null)) {
      return '';
    }
    // }

    return null;
  }

  void validationMethod() {
    if (_errorName != null) {
      setState(() {
        valideName = false;
      });
    } else {
      setState(() {
        valideName = true;
      });
    }

    if (_errorCredit != null) {
      setState(() {
        valideCredit = false;
      });
    } else {
      setState(() {
        valideCredit = true;
      });
    }
  }

  void errorGrade() {
    var Name = name ?? '';
    var Credit = credit ?? '';
    if ((Name.isNotEmpty && Name.trim().isNotEmpty) ||
        (Credit.isNotEmpty && Credit.trim().isNotEmpty)) {
      if (selectedValue1 == null) {
        setState(() {
          selectedValueIs1Null = true;
        });
      } else {
        setState(() {
          selectedValueIs1Null = false;
        });
      }
      if (selectedValue2 == null) {
        setState(() {
          selectedValueIs2Null = true;
        });
      } else {
        setState(() {
          selectedValueIs2Null = false;
        });
      }
    } else {
      setState(() {
        if (selectedValue1 != null && selectedValue2 == null) {
          selectedValueIs2Null = true;
        } else if (selectedValue2 != null && selectedValue1 == null) {
          selectedValueIs1Null = true;
        } else {
          selectedValueIs1Null = false;
          selectedValueIs2Null = false;
        }
      });
    }
    // }
  }

  deleteCourse() {
    print('####################$courseID');
    setState(() {
      pressDeleteCourse = true;
    });

    if (widget.listCoursesInSemester.length == 1) {
      // var uuid = Uuid();
      // var uniqueId = uuid.v1();

      setState(() {
        widget.listCoursesInSemester[widget.index] = [
          semesterID,
          null,
          null,
          null,
          null,
          'one',
          courseID
        ];
        _controller_Credit = TextEditingController();
        _controller_Name = TextEditingController();
        selectedValue2 = null;
        selectedValue1 = null;
        name = '';
        credit = '';
        type = 'one';
        val = false;
        selectedValueIs1Null = false;
        selectedValueIs2Null = false;
      });

      updateData(semesterID, courseID, null, null, null, null, 'one');
      // addCourseInDB(semesterID, courseID, null, null, null, null, 'one');
      print('theListAfterUpdate:${widget.listCoursesInSemester}');
      allSemesters[widget.semesterIndex][widget.index] =
          widget.listCoursesInSemester[widget.index];
      widget.CallBackUpdateList(widget.listCoursesInSemester);
    } else {
      List deletedCourse = widget.listCoursesInSemester.removeAt(widget.index);
      widget.CallBackUpdateList(widget.listCoursesInSemester);
      widget._keyAniSemest.currentState!.removeItem(widget.index,
          (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: CourseFin(
              widget.index,
              widget.semesterIndex,
              deletedCourse,
              widget.listCoursesInSemester,
              widget.CallBackUpdateList,
              () {},
              () {},
              widget._keyAniSemest),
        );
      }, duration: Duration(milliseconds: 300));
      Future.delayed(Duration(milliseconds: 310), () {
        deleteCourseFromDB(courseID);
        print('deletedCourse:$deletedCourse');
        print('theListAfterDeleting:${widget.listCoursesInSemester}');
      });
    }

    setState(() {
      pressDeleteCourse = false;
    });

    Future.delayed(Duration(milliseconds: 320), () {
      widget.calcCGPA();
    });

//###############################################################
    // if (widget.allSemesterss.length == 1 &&
    //     widget.listCoursesInSemester.length == 1) {
    //   print('no delete');
    // }
    //
    // widget.CallBackUpdateChange(true);
    //
    // List deletedCourse = widget.listCoursesInSemester.removeAt(widget.index);
    //
    // widget.CallBackUpdateList(widget.listCoursesInSemester);
    // widget._keyAniSemest.currentState!.removeItem(widget.index,
    //     (context, animation) {
    //   return SizeTransition(
    //     sizeFactor: animation,
    //     child: Course(
    //         widget.index,
    //         deletedCourse,
    //         widget.listCoursesInSemester,
    //         widget.CallBackUpdateList,
    //         widget.CallBackUpdateChange,
    //         widget.allSemesterss,
    //         widget.callBackallSemesterss,
    //         widget.semesterIndex,
    //         widget._keyAniSemest),
    //   );
    // }, duration: Duration(milliseconds: 0));
    // print('deletedCourse:$deletedCourse');
    // print('theListAfterDeleting:${widget.listCoursesInSemester}');

    // if (widget.listCoursesInSemester.isEmpty) {
    //   var uuid = Uuid();
    //   var uniqueId = uuid.v1();
    //
    //   setState(() {
    //     widget.listCoursesInSemester
    //         .add([semesterID, null, null, null, null, 'one', uniqueId]);
    //     widget.allSemesterss[widget.index] = widget.listCoursesInSemester;
    //     widget.callBackallSemesterss(widget.allSemesterss);
    //     widget.allSemesterss[widget.semesterIndex] =
    //         widget.listCoursesInSemester;
    //     widget.callBackallSemesterss(widget.allSemesterss);
    //   });
    //   widget._keyAniSemest.currentState!
    //       .insertItem(0, duration: Duration(milliseconds: 250));
    //   print('theListAfterAdd:${widget.listCoursesInSemester}');
    // } else {
    //   widget.allSemesterss[widget.semesterIndex] = widget.listCoursesInSemester;
    //   widget.callBackallSemesterss(widget.allSemesterss);
    // }
  }

  Widget gradeContainer() {
    return Row(
      children: [
        val
            ? Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          onMenuStateChange: (value) {
                            errorGrade();
                          },
                          customButton: Container(
                            width: 45,
                            height: 31,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border(
                                  bottom: BorderSide(
                                      color: selectedValueIs1Null
                                          ? Color(0xffce2029)
                                          : Colors.white,
                                      width: 1)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                selectedValue1 == null
                                    ? Text(
                                        '1 st',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 18),
                                      )
                                    : Text(
                                        '$selectedValue1',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff4562a7),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Center(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 45,
                                        height: 80,
                                        decoration: BoxDecoration(
                                            border: Border(
                                          bottom: BorderSide(
                                              color: Colors.white, width: 1),
                                        )),
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff4562a7),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue1,
                          key: ValueKey(selectedValue1),
                          onChanged: (value) {
                            setState(() {
                              selectedValue1 = value as String;
                              widget.courseList[3] = selectedValue1;
                              if (value.isNotEmpty) {
                                widget.listCoursesInSemester[widget.index][3] =
                                    value;
                              } else {
                                widget.listCoursesInSemester[widget.index][3] =
                                    null;
                              }
                              widget.CallBackUpdateList(
                                  widget.listCoursesInSemester);
                              widget.CallBackUpdateChange();

                              errorGrade();
                            });
                          },
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: 60,
                            padding: null,
                            elevation: 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: Color(0xffb8c8d1),
                              // boxShadow: [
                              //   BoxShadow(color: Colors.white, blurRadius: 5, spreadRadius: 0.2)
                              // ],
                            ),
                            offset: const Offset(0, 0),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(0),
                              thumbVisibility: MaterialStateProperty.all(false),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        onMenuStateChange: (value) {
                          errorGrade();
                        },
                        customButton: Container(
                          width: 45,
                          height: 31,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border(
                                bottom: BorderSide(
                                    color: selectedValueIs2Null
                                        ? Color(0xffce2029)
                                        : Colors.white,
                                    width: 1)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              selectedValue2 == null
                                  ? Text(
                                      '2 sd',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 18),
                                    )
                                  : Text(
                                      '$selectedValue2',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff4562a7),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Center(
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 45,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          border: Border(
                                        bottom: BorderSide(
                                            color: Colors.white, width: 1),
                                      )),
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff4562a7),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValue2,
                        key: ValueKey(selectedValue2),
                        onChanged: (value) {
                          setState(() {
                            selectedValue2 = value as String;
                            widget.courseList[4] = selectedValue2;
                            if (value.isNotEmpty) {
                              widget.listCoursesInSemester[widget.index][4] =
                                  value;
                            } else {
                              widget.listCoursesInSemester[widget.index][4] =
                                  null;
                            }
                            widget.CallBackUpdateList(
                                widget.listCoursesInSemester);

                            errorGrade();
                            widget.CallBackUpdateChange();
                          });
                        },
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 60,
                          padding: null,
                          elevation: 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: Color(0xffb8c8d1),
                            // boxShadow: [
                            //   BoxShadow(color: Colors.white, blurRadius: 5, spreadRadius: 0.2)
                            // ],
                          ),
                          offset: const Offset(-10, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all(0),
                            thumbVisibility: MaterialStateProperty.all(false),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    onMenuStateChange: (value) {
                      errorGrade();
                    },
                    customButton: Container(
                      width: 95,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                            bottom: BorderSide(
                                color: selectedValueIs1Null
                                    ? Color(0xffce2029)
                                    : Colors.white,
                                width: 1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          selectedValue1 == null
                              ? Text(
                                  'Grade',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                )
                              : Text(
                                  '$selectedValue1',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff4562a7),
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 30,
                              color: Color(0xff4562a7),
                            ),
                          )
                        ],
                      ),
                    ),
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 45,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      border: Border(
                                    bottom: BorderSide(
                                        color: Colors.white, width: 1),
                                  )),
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff4562a7),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                    value: selectedValue1,
                    key: ValueKey(selectedValue1),
                    onChanged: (value) {
                      setState(() {
                        selectedValue1 = value as String;
                        widget.courseList[3] = selectedValue1;
                        if (value.isNotEmpty) {
                          widget.listCoursesInSemester[widget.index][3] = value;
                        } else {
                          widget.listCoursesInSemester[widget.index][3] = null;
                        }
                        widget.CallBackUpdateList(widget.listCoursesInSemester);

                        errorGrade();
                        widget.CallBackUpdateChange();
                      });
                    },
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 70,
                      padding: null,
                      elevation: 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: Color(0xffb8c8d1),
                        // boxShadow: [
                        //   BoxShadow(color: Colors.white, blurRadius: 5, spreadRadius: 0.2)
                        // ],
                      ),
                      offset: const Offset(20, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all(0),
                        thumbVisibility: MaterialStateProperty.all(false),
                      ),
                    ),
                  ),
                ),
              ),
        GestureDetector(
          onTap: () {
            setState(() {
              val = !val;
              if (val == false) {
                setState(() {
                  selectedValue2 = null;
                  widget.courseList[4] = null;
                  widget.listCoursesInSemester[widget.index][4] = null;
                  widget.courseList[5] = 'one';
                  widget.listCoursesInSemester[widget.index][5] = 'one';
                });
              } else {
                setState(() {
                  widget.courseList[4] = selectedValue2;
                  widget.listCoursesInSemester[widget.index][4] =
                      selectedValue2;
                  widget.courseList[5] = 'two';
                  widget.listCoursesInSemester[widget.index][5] = 'two';
                });
              }
              widget.CallBackUpdateList(widget.listCoursesInSemester);
            });
          },
          child: AbsorbPointer(
            child: Container(
              margin: EdgeInsets.only(left: 8, top: 0),
              height: 18,
              width: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(100)),
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: Container(
                  height: 10,
                  width: 10,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: val ? Colors.green : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  )),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller_Name.dispose();
    _controller_Credit.dispose();
    _focusName.removeListener(_onFocusNameChange);
    _focusName.dispose();
    _focusCredit.removeListener(_onFocusCreditChange);
    _focusCredit.dispose();
  }

  @override
  Widget build(BuildContext context) {
    errorGrade();
    validationMethod();

    return Padding(
      padding: EdgeInsets.fromLTRB(5, 15, 20, 15),
      child: Container(
        height: 31,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    // widget.CallBackUpdateChange();
                    setState(() {
                      Future.delayed(Duration(milliseconds: 100), () {
                        deleteCourse();
                        // widget.calcCGPA();
                      });
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Icon(
                      Icons.delete_outline,
                      color: Color(0xffce2029),
                    ),
                  ),
                ),
                Container(
                  width: 125,
                  height: 28,
                  margin: EdgeInsets.only(top: 0, left: 10),
                  // padding: EdgeInsets.,
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: _focusName.hasFocus
                        ? BorderSide(
                            color: valideName
                                ? Color(0xff4562a7)
                                : Color(0xffce2029),
                          )
                        : BorderSide(
                            color:
                                valideName ? Colors.white : Color(0xffce2029)),
                  )),
                  // padding: EdgeInsets.only(bottom: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _controller_Name,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.bottom,
                        focusNode: _focusName,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff004d60),
                        ),
                        onChanged: (value) {
                          setState(() {
                            errorGrade();
                            widget.courseList[1] = value;
                            name = value;
                            if (value.isNotEmpty) {
                              widget.listCoursesInSemester[widget.index][1] =
                                  value;
                            } else {
                              widget.listCoursesInSemester[widget.index][1] =
                                  null;
                            }
                            // widget.CallBackUpdateList(widget.listCoursesInSemester);
                            selectedValueIs1Null;
                            selectedValueIs2Null;
                          });
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Enter Course',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 18),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0, color: Colors.transparent)
                              // borderSide: BorderSide(
                              //   color:
                              //       valideName ? Colors.white : Color(0xffce2029)),
                              ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0, color: Colors.transparent)

                              // borderSide: BorderSide(
                              //   color: valideName
                              //       ? Color(0xff4562a7)
                              //       : Color(0xffce2029),
                              // ),
                              ),
                        ),
                      ),
                      SizedBox(
                        height: 0.5,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: 60,
              // height: 34,
              height: 28,
              // margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                  border: Border(
                bottom: _focusCredit.hasFocus
                    ? BorderSide(
                        color:
                            valideName ? Color(0xff4562a7) : Color(0xffce2029),
                      )
                    : BorderSide(
                        color: valideName ? Colors.white : Color(0xffce2029)),
              )),
              child: Column(
                children: [
                  TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: _controller_Credit,
                    focusNode: _focusCredit,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        credit = value;
                        if (value.isNotEmpty) {
                          widget.listCoursesInSemester[widget.index][2] = value;
                        } else {
                          widget.listCoursesInSemester[widget.index][2] = null;
                        }
                      });
                    },
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff4562a7),
                    ),
                    maxLines: 1,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      hintText: 'Credit',
                      enabledBorder: UnderlineInputBorder(
                          // borderSide: BorderSide(
                          //     color: valideCredit
                          //         ? Colors.white
                          //         : Color(0xffce2029)),
                          borderSide:
                              BorderSide(width: 0, color: Colors.transparent)),
                      focusedBorder: UnderlineInputBorder(
                          // borderSide: BorderSide(
                          //   color: valideCredit
                          //       ? Color(0xff4562a7)
                          //       : Color(0xffce2029),
                          // ),
                          borderSide:
                              BorderSide(width: 0, color: Colors.transparent)),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  )
                ],
              ),
            ),
            gradeContainer()
          ],
        ),
      ),
    );
  }
}

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({super.key});

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  String email = '';
  String name = '';
  String imageURL = '';

  CollectionReference? _usersInfo;

  @override
  void initState() {
    super.initState();
    setState(() {
      _usersInfo = FirebaseFirestore.instance.collection('UsersInfo');
    });
  }

  Future showImageDealog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        contentPadding: EdgeInsets.all(0),
        alignment: Alignment.center,
        content: Container(
          height: 300,
          width: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageURL,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget headerContent() {
    if (_usersInfo != null && loggedInUser != null) {
      return StreamBuilder(
        stream: _usersInfo!.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              final DocumentSnapshot userInfo = snapshot.data!.docs[i];
              if (userInfo['email'] == loggedInUser!.email) {
                email = userInfo['email'];
                name = userInfo['name'];
                print('#########################################');
                print(name);
                imageURL = userInfo['image'];
              }
            }
            // showSpinner = false;
          }

          return name.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imageURL.isEmpty
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
                                    border: Border.all(
                                        color: Colors.white54, width: 4)),
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
                        : Stack(
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
                                    border: Border.all(
                                        color: Colors.white54, width: 4)),
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
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    'Loading .... ',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                );
        },
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 220,
              color: Color(0xff4562a7),
              child: headerContent(),
              padding: EdgeInsets.all(10),
            ),
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.home_outlined),
                    title: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePageFin(),
                              ));
                        },
                        child: Text('Home')),
                  ),
                  ListTile(
                    leading: Icon(Icons.person_rounded),
                    title: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Profile(email, name, imageURL),
                              ));
                        },
                        child: Text('Profile')),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout_outlined),
                    title: GestureDetector(
                        onTap: () async {
                          final prov =
                              Provider.of<AuthServer>(context, listen: false);
                          await prov.googleLogout();

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Siginin(),
                            ),
                            (route) => true,
                          );
                        },
                        child: Text('Logout')),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AppBarHomeFin extends StatefulWidget {
  double cgpa;
  int earnCredit;
  int totalCredit;

  AppBarHomeFin(this.cgpa, this.earnCredit, this.totalCredit);

  @override
  State<AppBarHomeFin> createState() => _AppBarHomeFinState();
}

class _AppBarHomeFinState extends State<AppBarHomeFin> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> openDialogSitting() => showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(20),
              contentPadding: EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              content: Container(
                height: 300,
                width: 100,
                color: Colors.red,
              ),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
                              '${widget.cgpa.toStringAsFixed(3)}',
                              style: TextStyle(
                                  color: Color(0xff4562a7),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      LinearPercentIndicator(
                        width: 230,
                        lineHeight: 15,
                        percent: widget.cgpa / 4,
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
                      padding: EdgeInsets.only(left: 0, top: 20),
                      child: Text(
                        'Total Credits',
                        style: TextStyle(
                          color: Color(0xff004d60),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Text(
                        '${widget.earnCredit} / ${widget.totalCredit}',
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
      ],
    );
  }
}
