import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../pages/home_with_firestore_page.dart';
import 'course.dart';
import 'courses_service.dart';

class SemesterFin extends StatefulWidget {
  List semesterCourses;
  int semesterId;
  int index;
  String department;
  Function calcCGPA;
  bool isChanged;
  Function ChangeList;
  GlobalKey<AnimatedListState> _allSemestersKey;
  SemesterFin(
      this.semesterCourses,
      this.semesterId,
      this.index,
      this.department,
      this.calcCGPA,
      this._allSemestersKey,
      this.isChanged,
      this.ChangeList,
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
  // 2 mean that there are repeated Names
  List<int?> errorTypeCredit = [];
  // 1 mean that some fields are empty
  // 2 means that the credit is more than three numbers
  // 3 means that the credit  equals zero

  List<int?> errorTypeGrade = [];
  // 1 mean that some fields are empty

  String? emptyField;
  String? repeatedField;
  String? validNameInList;
  String? validRequirements;
  String? creditMoreThanThree;
  String? creditEqZero;

  double GPA = 0.0;
  int earnCredit = 0;
  int totalCredit = 0;
  List allCoursesInSemstd = [];
  bool isRepeatedSemesterModel() {
    if (repeatedSemestersIds.contains(widget.semesterId.toString())) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      listOfCoursesInSemester = widget.semesterCourses;

      Future.delayed(Duration.zero, () {
        if (!isValide()) {
          // print('fffffffffffffffffffffffffffffffffff');
          widget.isChanged = true;
          widget.ChangeList(widget.index, true, false);
        }
        if (!widget.isChanged) {
          calcGPA();
        }
      });
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

  callBackToUpdateGPA() {
    setState(() {
      calcGPA();
    });
  }

  callBackToUpdateTheAllSemestersList(newList) {
    setState(() {
      allSemesters = newList;
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
    bool isRepeated = isRepeatedSemesterModel();
    if (CoursesService.systemOption) {
      List<String> coursesIDs = [];
      List<bool> val = [];
      List<bool> val2 = [];
      for (List course in listOfCoursesInSemester) {
        coursesIDs.add(course[6]);
      }
      for (String v in namesCoursesNotInListIds) {
        if (coursesIDs.contains(v)) {
          val.add(true);
        } else {
          val.add(false);
        }
      }

      for (String v in creditsCoursesNotInListIds) {
        if (coursesIDs.contains(v)) {
          val.add(true);
        } else {
          val.add(false);
        }
      }

      bool isValidNameInList = val.contains(true);

      for (String v in namesCoursesNotInRequirements) {
        if (coursesIDs.contains(v)) {
          val2.add(true);
        } else {
          val2.add(false);
        }
      }
      bool isValidRequirements = val2.contains(true);
      // print(
      //     'dhjjjjjjjj$isValidRequirements jjjjj: $namesCoursesNotInRequirements');
      if (isValidRequirements) {
        setState(() {
          validRequirements =
              'Invalid Requirements ,this course is not allowed to enroll';
        });
      } else {
        setState(() {
          validRequirements = null;
        });
      }
      if (isValidNameInList) {
        List<bool> val4 = [];
        for (String v in namesCoursesNotInListIds) {
          if (coursesIDs.contains(v)) {
            val4.add(true);
          } else {
            val4.add(false);
          }
        }
        if (val4.contains(true) &&
            !CoursesService.isGlobalDepartmentValidationOK() &&
            !CoursesService.departmentOption) {
          setState(() {
            validNameInList =
                'you have to finish requirements Courses (متطلب كلية)';
          });
        } else {
          setState(() {
            validNameInList = 'Invalid Name Or Credit ,there is no record  ';
          });
        }
      } else {
        setState(() {
          validNameInList = null;
        });
      }
    }

    if (isRepeated) {
      setState(() {
        repeatedField = 'there is repeated field';
      });
    } else {
      setState(() {
        repeatedField = null;
      });
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
    // print('theListAfterAdd:${listOfCoursesInSemester}');
    Future.delayed(Duration(milliseconds: 270), () {
      homeWithFireStoreServices!.addCourseInDB(
          widget.semesterId, uniqueId, null, null, null, null, 'one');
    });
  }

  void deleteSemester() async {
    setState(() {
      List deletedSemest = allSemesters.removeAt(widget.index);

      widget._allSemestersKey.currentState!.removeItem(widget.index,
          (context, animation) {
        return SlideTransition(
          position: animation.drive(_offset),
          child: SemesterFin(deletedSemest, widget.semesterId, widget.index,
              widget.department, () {}, widget._allSemestersKey, false, () {}),
        );
      }, duration: Duration(milliseconds: 250));

      widget.calcCGPA();
    });
    homeWithFireStoreServices!.deleteSemesterFromDB(widget.semesterId);
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
          } else if (grade1 == 'Non') {
            pointOfGrade = -3.00;
          } else {
            // S grade
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
      setState(() {
        if (totalPointsOfSemest == 0.0 && totalCredit_without_SU == 0) {
          GPA = 0.0;
        } else {
          GPA = (totalPointsOfSemest / totalCredit_without_SU);
        }
      });
    } else {
      // print('################## Empty GPA #################');
    }
  }

  bool isValide() {
    findErrors();
    if (emptyField == null &&
        creditEqZero == null &&
        creditMoreThanThree == null &&
        validNameInList == null &&
        validRequirements == null &&
        repeatedField == null) {
      return true;
    } else {
      return false;
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> message() {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                              maxLines: 2,
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
                              maxLines: 2,
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          : SizedBox(
                              width: 0,
                              height: 0,
                            ),
                      repeatedField != null
                          ? Text(
                              '$repeatedField',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          : SizedBox(
                              width: 0,
                              height: 0,
                            ),
                      validNameInList != null
                          ? Text(
                              '$validNameInList',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            )
                          : SizedBox(
                              width: 0,
                              height: 0,
                            ),
                      validRequirements != null
                          ? Text(
                              '$validRequirements',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              maxLines: 2,
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
        homeWithFireStoreServices!.updateData(semesterID, courseID, name,
            credit, selectedValue1, selectedValue2, 'two');
      } else {
        homeWithFireStoreServices!.updateData(
            semesterID, courseID, name, credit, selectedValue1, null, 'one');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (isRepeatedSemesterModel()) {
        // print('repeatedCourseInSemestIddddd  $repeatedCourseInSemestId');
        setState(() {
          widget.isChanged = true;
          widget.ChangeList(widget.index, true, false);
        });
      }
    });
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
                          !widget.isChanged
                              ? Text(
                                  '${GPA.toStringAsFixed(3)}',
                                  style: TextStyle(
                                    color: Color(0xff4562a7),
                                    fontSize: 18,
                                  ),
                                )
                              : Text(
                                  '0.000',
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
                          !widget.isChanged
                              ? Text(
                                  '$earnCredit / $totalCredit',
                                  style: TextStyle(
                                    color: Color(0xff4562a7),
                                    fontSize: 18,
                                  ),
                                )
                              : Text(
                                  '0 / 0',
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
                  key: ObjectKey(listOfCoursesInSemester[index][6]),
                  child: Course(
                    index,
                    widget.index,
                    listOfCoursesInSemester[index],
                    listOfCoursesInSemester,
                    callBackToUpdateTheCoursesList,
                    callbackIsChanged,
                    () {
                      widget.calcCGPA();
                    },
                    callBackToUpdateGPA,
                    _keyAniListCourses,
                    homeWithFireStoreServices!,
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
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    addCourse();
                    if (CoursesService.isGlobalDepartmentValidationOK() &&
                        CoursesService.departmentOption &&
                        widget.department.isEmpty &&
                        CoursesService.systemOption) {
                      departmentMessage(context);
                    }
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
                              creditMoreThanThree == null &&
                              validNameInList == null &&
                              validRequirements == null &&
                              repeatedField == null) {
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
                            repeatedField = null;
                            validNameInList = null;
                            validRequirements = null;
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
