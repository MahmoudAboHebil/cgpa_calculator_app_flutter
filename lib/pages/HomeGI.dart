import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:uuid/uuid.dart';

// [[semesterNum,courseName,credit,grade1,grade2,('two' for two grade otherwise 'one'),id ],....]

// ToDo: you must learn how to use callBack to improve the calcCGPA button to show up automatic
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class HomePageGI extends StatefulWidget {
  @override
  State<HomePageGI> createState() => _HomePageGIState();
}

class _HomePageGIState extends State<HomePageGI> {
  bool _visible = true;
  List allSemesters = [
    // semester one
    [
      [1, null, null, null, null, 'one', '1'],
      [1, null, null, null, null, 'one', '2']
    ],
    // semester two
    [
      [1, null, null, null, null, 'one', '3']
    ],
    // semester three
    []
  ];
  @override
  void initState() {
    super.initState();
  }

  // callBackToUpdateAllSemestersList(List allSemest){
  //   setState(() {
  //     allSemesters=allSemest;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffb8c8d1),
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
              backgroundColor: Color(0xffb8c8d1),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                      child: Stack(
                    children: [
                      ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            AnimatedList(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              initialItemCount: allSemesters.length,
                              itemBuilder: (context, index, animation) {
                                return SizeTransition(
                                  sizeFactor: animation,
                                  key: UniqueKey(),
                                  child: SemesterGI(
                                    allSemesters[index],
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ))
                ],
              ),
              floatingActionButton: Visibility(
                visible: _visible,
                child: FloatingActionButton(
                  backgroundColor: Color(0xff4562a7),
                  onPressed: () async {},
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              )),
        ),
      ),
    );
  }
}

class SemesterGI extends StatefulWidget {
  List semesterCourses;
  SemesterGI(this.semesterCourses, {Key? key}) : super(key: key);

  @override
  State<SemesterGI> createState() => _SemesterGIState();
}

class _SemesterGIState extends State<SemesterGI> {
  GlobalKey<AnimatedListState> _keyAniListCourses =
      GlobalKey<AnimatedListState>();
  var uuid = Uuid();

  bool isChanged = false;
  int semesterID = 0;
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

  @override
  void initState() {
    super.initState();

    setState(() {
      listOfCoursesInSemester = widget.semesterCourses;
      if (listOfCoursesInSemester.isEmpty) {
        var uniqueId = uuid.v1();

        setState(() {
          listOfCoursesInSemester
              .add([1, null, null, null, null, 'one', uniqueId]);
          semesterID = 1;
          print('theListAfterAdd:${listOfCoursesInSemester}');
        });
      }
    });
  }

  callbackIsChanged(value) {
    setState(() {
      isChanged = value;
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

  addCourse() {
    var uniqueId = uuid.v1();

    setState(() {
      listOfCoursesInSemester
          .add([semesterID, null, null, null, null, 'one', uniqueId]);
    });
    int insertIndex = listOfCoursesInSemester.isEmpty
        ? listOfCoursesInSemester.length
        : listOfCoursesInSemester.length - 1;
    _keyAniListCourses.currentState!
        .insertItem(insertIndex, duration: Duration(milliseconds: 250));
    print('theListAfterAdd:${listOfCoursesInSemester}');
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
                            '$semesterID',
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
                            '0',
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
                  key: UniqueKey(),
                  child: Course(
                      index,
                      listOfCoursesInSemester[index],
                      listOfCoursesInSemester,
                      callBackToUpdateTheCoursesList,
                      callbackIsChanged,
                      _keyAniListCourses),
                );
              },
              initialItemCount: listOfCoursesInSemester.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              key: _keyAniListCourses,
            ),
            Row(
              mainAxisAlignment: isChanged
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    addCourse();
                  },
                  child: Container(
                    alignment: Alignment.center,
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
                isChanged
                    ? GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();

                          findErrors();
                          if (emptyField == null &&
                              creditEqZero == null &&
                              creditMoreThanThree == null) {
                            // for (int i = 0;
                            //     i < listOfCoursesInSemester.length;
                            //     i++) {}
                            Display();
                            setState(() {
                              isChanged = false;
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
                    : SizedBox(
                        width: 0,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Course extends StatefulWidget {
  int index;
  List courseList;
  List listCoursesInSemester;
  Function CallBackUpdateList;
  Function CallBackUpdateChange;
  GlobalKey<AnimatedListState> _keyAniSemest;
  Course(this.index, this.courseList, this.listCoursesInSemester,
      this.CallBackUpdateList, this.CallBackUpdateChange, this._keyAniSemest,
      {Key? key})
      : super(key: key);

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  late TextEditingController _controller_Name;
  late TextEditingController _controller_Credit;
  FocusNode _focusName = FocusNode();
  FocusNode _focusCredit = FocusNode();

  late String? selectedValue1;
  late String? selectedValue2;
  int semesterID = 0;
  String? courseID = '';
  String? name = '';
  String? credit = '';
  String? type = '';
  late bool val;
  bool selectedValueIs1Null = false;
  bool selectedValueIs2Null = false;
  bool valideName = true;
  bool valideCredit = true;
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
      widget.CallBackUpdateChange(true);
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
      widget.CallBackUpdateChange(true);
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
    List deletedCourse = widget.listCoursesInSemester.removeAt(widget.index);
    widget.CallBackUpdateList(widget.listCoursesInSemester);
    widget._keyAniSemest.currentState!.removeItem(widget.index,
        (context, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: Course(
            widget.index,
            deletedCourse,
            widget.listCoursesInSemester,
            widget.CallBackUpdateList,
            widget.CallBackUpdateChange,
            widget._keyAniSemest),
      );
    }, duration: Duration(milliseconds: 300));
    print('deletedCourse:$deletedCourse');
    print('theListAfterDeleting:${widget.listCoursesInSemester}');
    widget.CallBackUpdateChange(true);
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
                              mainAxisAlignment: MainAxisAlignment.end,
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
                              widget.CallBackUpdateChange(true);

                              errorGrade();
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
                            mainAxisAlignment: MainAxisAlignment.end,
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
                            widget.CallBackUpdateChange(true);
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
                        widget.CallBackUpdateChange(true);
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
              margin: EdgeInsets.only(left: 8, top: 5),
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
                    setState(() {
                      Future.delayed(Duration(milliseconds: 100), () {
                        deleteCourse();
                      });
                    });
                  },
                  child: Icon(
                    Icons.delete_outline,
                    color: Color(0xffce2029),
                  ),
                ),
                Container(
                  width: 125,
                  height: 18,
                  margin: EdgeInsets.only(top: 4, left: 10),
                  child: TextField(
                    controller: _controller_Name,
                    textAlign: TextAlign.center,
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
                          widget.listCoursesInSemester[widget.index][1] = value;
                        } else {
                          widget.listCoursesInSemester[widget.index][1] = null;
                        }
                        // widget.CallBackUpdateList(widget.listCoursesInSemester);
                        selectedValueIs1Null;
                        selectedValueIs2Null;
                        // widget.CallBackUpdateChange(true);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Course',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                valideName ? Colors.white : Color(0xffce2029)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: valideName
                              ? Color(0xff4562a7)
                              : Color(0xffce2029),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 60,
              height: 18,
              margin: EdgeInsets.only(bottom: 0.4),
              child: TextField(
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
                    // widget.CallBackUpdateList(widget.listCoursesInSemester);
                  });
                  // widget.CallBackUpdateChange(true);
                },
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff4562a7),
                ),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  hintText: 'Credit',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: valideCredit ? Colors.white : Color(0xffce2029)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          valideCredit ? Color(0xff4562a7) : Color(0xffce2029),
                    ),
                  ),
                ),
              ),
            ),
            gradeContainer()
          ],
        ),
      ),
    );
  }
}

class AppBarHomeGI extends StatefulWidget {
  double cgpa;
  int earnCredit;
  int totalCredit;

  AppBarHomeGI(this.cgpa, this.earnCredit, this.totalCredit);

  @override
  State<AppBarHomeGI> createState() => _AppBarHomeGIState();
}

class _AppBarHomeGIState extends State<AppBarHomeGI> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            border: Border.all(color: Colors.white54, width: 2),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {});
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xff4562a7),
                      size: 30,
                    ),
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
                    width: 65,
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
        ),
      ],
    );
  }
}
