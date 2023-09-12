import 'dart:collection';

import 'package:cgp_calculator/online%20app/home_with_firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../pages/home_with_firestore_page.dart';

List<String> repeatedSemestersIds = [];
List<String> namesCoursesNotInListIds = [];
List<String> namesCoursesNotInRequirements = [];
List<String> creditsCoursesNotInListIds = [];

class Course extends StatefulWidget {
  final int index;
  final int semesterIndex;
  final List courseList;
  final List listCoursesInSemester;
  final Function callBackUpdateListCoursesInSemester;
  final Function callBackUpdateChange;
  final Function calcCGPA;
  final GlobalKey<AnimatedListState> _keyAniSemest;
  final HomeWithFireStoreServices homeWithFireStoreServices;
  Course(
      this.index,
      this.semesterIndex,
      this.courseList,
      this.listCoursesInSemester,
      this.callBackUpdateListCoursesInSemester,
      this.callBackUpdateChange,
      this.calcCGPA,
      this._keyAniSemest,
      this.homeWithFireStoreServices,
      {Key? key})
      : super(key: key);

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  late TextEditingController _controller_Name;
  late TextEditingController _controller_Credit;
  String? _selectedCity;
  bool isRepeatedCourseModel(
      String courseName, String courseId, String semesterID) {
    List courseNames = [];
    List<String> repeatedSemesterIDs = [];

    for (List semester in allSemesters) {
      for (List course in semester) {
        courseNames.add(course[1]);
      }
    }
    int numberOfOccurrence = 0;
    numberOfOccurrence = countOccurrencesUsingLoop(courseNames, courseName);

    if (numberOfOccurrence >= 2) {
      List twoRepeatedIds = [];
      for (List semester in allSemesters) {
        for (List course in semester) {
          if (course[1] == courseName) {
            repeatedSemesterIDs.add(course[0].toString());
            if (course[0].toString() == semesterID) {
              twoRepeatedIds.add(course[6]);
            }
          }
        }
      }

      int numberOfOccurrence = 0;
      numberOfOccurrence =
          countOccurrencesUsingLoop(repeatedSemesterIDs, semesterID);

      if (numberOfOccurrence >= 2) {
        setState(() {
          repeatedSemestersIds.add(semesterID);
          repeatedSemestersIds =
              LinkedHashSet<String>.from(repeatedSemestersIds).toList();
        });
      }
      if (twoRepeatedIds.length >= 2) {
        if (courseId == twoRepeatedIds[1] && numberOfOccurrence >= 2) {
          return true;
        }
        return false;
      } else {
        bool isExist = repeatedSemestersIds.contains(semesterID);
        setState(() {
          if (isExist) {
            repeatedSemestersIds.remove(semesterID);
            // print('22222222222222222222222 : $repeatedCourseInSemestId');
          }
        });
        return false;
      }
    } else {
      bool isExist = repeatedSemestersIds.contains(semesterID);
      setState(() {
        if (isExist) {
          repeatedSemestersIds.remove(semesterID);
        }
      });
      return false;
    }
  }

  bool isValidCreditSystme() {
    var creditInput = credit ?? '';
    var creditList = '';

    bool isInList = true;

    if (CoursesService.systemOption) {
      if (creditInput.isNotEmpty &&
          creditInput.trim().isNotEmpty &&
          !namesCoursesNotInListIds.contains(courseID.toString())) {
        var name = _controller_Name.text ?? '';
        creditList = CoursesService.getCredit(name);
        if (creditList != creditInput) {
          setState(() {
            creditsCoursesNotInListIds.add(courseID.toString());
            creditsCoursesNotInListIds =
                LinkedHashSet<String>.from(creditsCoursesNotInListIds).toList();
          });
          isInList = false;
        } else {
          bool isExist =
              creditsCoursesNotInListIds.contains(courseID.toString());
          setState(() {
            if (isExist) {
              creditsCoursesNotInListIds.remove(courseID);
            }
          });
        }
      } else {
        bool isExist = creditsCoursesNotInListIds.contains(courseID.toString());
        setState(() {
          if (isExist) {
            creditsCoursesNotInListIds.remove(courseID);
          }
        });
      }
    }

    return isInList;
  }

  bool isValidNameSystem() {
    var Name = _controller_Name.text ?? '';
    bool isRepeatedName = true;
    bool isInList = true;
    bool isValidRequirements = true;
    if (Name.isNotEmpty && Name.trim().isNotEmpty) {
      if (CoursesService.systemOption) {
        //  is the name in the courses Of college
        if (!CoursesService.getMajorCSNames().contains(Name)) {
          setState(() {
            namesCoursesNotInListIds.add(courseID.toString());
            namesCoursesNotInListIds =
                LinkedHashSet<String>.from(namesCoursesNotInListIds).toList();
          });
          isInList = false;
        } else {
          bool isExist = namesCoursesNotInListIds.contains(courseID.toString());
          setState(() {
            if (isExist) {
              namesCoursesNotInListIds.remove(courseID);
            }
          });

          isInList = true;
        }
        // is the name valid about courses requirements

        if (!CoursesService.courseEnrollingSystem(Name)) {
          setState(() {
            namesCoursesNotInRequirements.add(courseID.toString());
            namesCoursesNotInRequirements =
                LinkedHashSet<String>.from(namesCoursesNotInRequirements)
                    .toList();
          });
          isValidRequirements = false;
        } else {
          bool isExist =
              namesCoursesNotInRequirements.contains(courseID.toString());
          setState(() {
            if (isExist) {
              namesCoursesNotInRequirements.remove(courseID);
            }
          });

          isValidRequirements = true;
        }
      }
      //  is the name is repeated

      if (isRepeatedCourseModel(Name, courseID, semesterID.toString())) {
        isRepeatedName = false;
      } else {
        isRepeatedName = true;
      }
    } else {
      bool isExist = namesCoursesNotInListIds.contains(courseID.toString());
      setState(() {
        if (isExist) {
          namesCoursesNotInListIds.remove(courseID);
        }
      });
      bool isExist1 =
          namesCoursesNotInRequirements.contains(courseID.toString());
      setState(() {
        if (isExist1) {
          namesCoursesNotInRequirements.remove(courseID);
        }
      });

      isValidRequirements = true;

      isInList = true;
    }

    return isRepeatedName && isInList && isValidRequirements;
  }

  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  FocusNode _focusName = FocusNode();
  FocusNode _focusCredit = FocusNode();
  FocusNode _focusGrade = FocusNode();

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
    'Non',
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
    _focusGrade.addListener(_onFocusGradeChange);
    setState(() {
      repeatedSemestersIds = [];
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
    suggestionBoxController.suggestionsBox?.close();
    errorGrade();
    validationMethod();
  }

  void _onFocusCreditChange() {
    errorGrade();
    validationMethod();
  }

  void _onFocusGradeChange() {
    errorGrade();
    validationMethod();
  }

  String? get _errorCredit {
    var Name = name ?? '';
    var Credit = credit ?? '';
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
    return null;
  }

  String? get _errorName {
    var Name = name ?? '';
    var Credit = credit ?? '';

    if (Credit.isNotEmpty && Credit.trim().isNotEmpty) {
      if (Name.isEmpty || Name.trim().isEmpty) {
        return '';
      }
    } else if ((Name.isEmpty || Name.trim().isEmpty) &&
        (selectedValue1 != null || selectedValue2 != null)) {
      return '';
    }

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
    isValidNameSystem();
    isValidCreditSystme();
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
  }

  deleteCourse() {
    setState(() {
      pressDeleteCourse = true;
    });
    if (widget.listCoursesInSemester.length == 1) {
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

      widget.homeWithFireStoreServices
          .updateData(semesterID, courseID, null, null, null, null, 'one');
      allSemesters[widget.semesterIndex][widget.index] =
          widget.listCoursesInSemester[widget.index];
      widget.callBackUpdateListCoursesInSemester(widget.listCoursesInSemester);
    } else {
      List deletedCourse = widget.listCoursesInSemester.removeAt(widget.index);
      widget.callBackUpdateListCoursesInSemester(widget.listCoursesInSemester);
      widget._keyAniSemest.currentState!.removeItem(widget.index,
          (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: Course(
              widget.index,
              widget.semesterIndex,
              deletedCourse,
              widget.listCoursesInSemester,
              widget.callBackUpdateListCoursesInSemester,
              () {},
              () {},
              widget._keyAniSemest,
              widget.homeWithFireStoreServices),
        );
      }, duration: Duration(milliseconds: 300));
      Future.delayed(Duration(milliseconds: 310), () {
        widget.homeWithFireStoreServices.deleteCourseFromDB(courseID);
        // print('deletedCourse:$deletedCourse');
        // print('theListAfterDeleting:${widget.listCoursesInSemester}');
      });
    }

    setState(() {
      pressDeleteCourse = false;
    });
    Future.delayed(Duration(milliseconds: 320), () {
      widget.calcCGPA();
    });
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
                              widget.callBackUpdateListCoursesInSemester(
                                  widget.listCoursesInSemester);
                              widget.callBackUpdateChange();

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
                            widget.callBackUpdateListCoursesInSemester(
                                widget.listCoursesInSemester);

                            errorGrade();
                            widget.callBackUpdateChange();
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
                    focusNode: _focusGrade,
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
                        widget.callBackUpdateListCoursesInSemester(
                            widget.listCoursesInSemester);

                        errorGrade();
                        widget.callBackUpdateChange();
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
              widget.callBackUpdateListCoursesInSemester(
                  widget.listCoursesInSemester);
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
    _focusGrade.removeListener(_onFocusGradeChange);
    _focusGrade.dispose();
  }

  @override
  Widget build(BuildContext context) {
    errorGrade();
    validationMethod();

    return Padding(
      padding: EdgeInsets.fromLTRB(5, 15, 20, 15),
      child: GestureDetector(
        onTap: () {},
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
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: _focusName.hasFocus
                          ? BorderSide(
                              color: valideName && isValidNameSystem()
                                  ? Color(0xff4562a7)
                                  : Color(0xffce2029),
                            )
                          : BorderSide(
                              color: valideName && isValidNameSystem()
                                  ? Colors.white
                                  : Color(0xffce2029)),
                    )),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _controller_Name,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.bottom,
                            focusNode: _focusName,
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff004d60),
                            ),
                            onChanged: (value) {
                              // print(
                              //     '######################44#####################');
                              setState(() {
                                errorGrade();

                                widget.courseList[1] = value;
                                name = value;
                                if (value.isNotEmpty) {
                                  widget.listCoursesInSemester[widget.index]
                                      [1] = value;
                                } else {
                                  widget.listCoursesInSemester[widget.index]
                                      [1] = null;
                                }
                                widget.callBackUpdateListCoursesInSemester(
                                    widget.listCoursesInSemester);
                                widget.callBackUpdateChange();

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
                                      width: 0, color: Colors.transparent)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, color: Colors.transparent)),
                            ),
                          ),
                          hideSuggestionsOnKeyboardHide: false,
                          suggestionsCallback: (pattern) async {
                            return CoursesService.getSuggestions(
                                pattern, widget.listCoursesInSemester);
                          },
                          itemBuilder: (context, String suggestion) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(suggestion,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff4562a7),
                                    )),
                              ),
                            );
                          },
                          suggestionsBoxController: suggestionBoxController,
                          onSuggestionSelected: (String suggestion) {
                            this._controller_Name.text = suggestion;

                            setState(() {
                              errorGrade();
                              widget.courseList[1] = suggestion;
                              name = suggestion;
                              if (suggestion.isNotEmpty) {
                                widget.listCoursesInSemester[widget.index][1] =
                                    suggestion;
                              } else {
                                widget.listCoursesInSemester[widget.index][1] =
                                    null;
                              }

                              //  auto credit
                              String value =
                                  CoursesService.getCredit(suggestion);
                              credit = value;
                              _controller_Credit.text = value;
                              if (value.isNotEmpty) {
                                widget.listCoursesInSemester[widget.index][2] =
                                    value;
                              } else {
                                widget.listCoursesInSemester[widget.index][2] =
                                    null;
                              }
                              widget.callBackUpdateListCoursesInSemester(
                                  widget.listCoursesInSemester);
                              widget.callBackUpdateChange();

                              selectedValueIs1Null;
                              selectedValueIs2Null;
                            });
                          },
                          itemSeparatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.white,
                            );
                          },
                          suggestionsBoxDecoration: SuggestionsBoxDecoration(
                            constraints: BoxConstraints(
                              maxHeight: 250,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                            elevation: 8.0,
                            color: Color(0xffb8c8d1),
                          ),
                          // hideSuggestionsOnKeyboardHide: true,
                          // hideKeyboard: true,
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
                height: 28,
                decoration: BoxDecoration(
                    border: Border(
                  bottom: _focusCredit.hasFocus
                      ? BorderSide(
                          color: valideCredit && isValidCreditSystme()
                              ? Color(0xff4562a7)
                              : Color(0xffce2029),
                        )
                      : BorderSide(
                          color: valideCredit && isValidCreditSystme()
                              ? Colors.white
                              : Color(0xffce2029)),
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
                            widget.listCoursesInSemester[widget.index][2] =
                                value;
                          } else {
                            widget.listCoursesInSemester[widget.index][2] =
                                null;
                          }
                          widget.callBackUpdateListCoursesInSemester(
                              widget.listCoursesInSemester);
                          widget.callBackUpdateChange();
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
                            borderSide: BorderSide(
                                width: 0, color: Colors.transparent)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 0, color: Colors.transparent)),
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
      ),
    );
  }
}

class CoursesService {
  static bool systemOption = true;
  static List<String> cities = [
    'Beirut',
    'Damascus',
    'San Fransisco',
    'Rome',
    'Los Angeles',
    'Madrid',
    'Bali',
    'Barcelona',
    'Paris',
    'Bucharest',
    'New York City',
    'Philadelphia',
    'Sydney',
  ];
  static List majorCS = [
    [
      'Introduction to Probability and Statistics',
      '2',
      '040102102',
      [[], []]
    ],
    [
      'Object Oriented Programming',
      '2',
      '040103201',
      [
        ['040102102'],
        ['040102102', '040103202']
      ]
    ],
    [
      'Data Structures and File Processing',
      '3',
      '040103202',
      [
        ['040103201'],
        []
      ]
    ],
    [
      'Discrete Structures',
      '2',
      '040103203',
      [[], []]
    ],
    [
      'Theory of Computation',
      '2',
      '040103204',
      [
        ['040103203'],
        []
      ]
    ],
    //
    [
      'Network and Internet Programming',
      '3',
      '040103205',
      [
        ['040102102'],
        []
      ]
    ],
    [
      'Advanced Programming',
      '3',
      '040103206',
      [
        ['040103201'],
        []
      ]
    ],
    [
      'Computer Programming (Practical)',
      '1',
      '040103207',
      [
        ['040103205', '040103201'],
        []
      ]
    ],
    [
      'Matrices',
      '2',
      '040101231',
      [[], []]
    ],
    [
      'Digital Logic Circuits',
      '3',
      '040103250',
      [[], []]
    ],

    //
  ];

  static List<String> getMajorCSNames() {
    List<String> names = [];
    for (List list in majorCS) {
      names.add(list[0]);
    }
    return names;
  }

  static String getCredit(String courseName) {
    String credit = '';
    for (List course in majorCS) {
      if (course[0] == courseName) {
        credit = course[1];
      }
    }
    return credit;
  }

  static String? getCourseNumberByName(String courseName) {
    String? number;
    for (List course in majorCS) {
      if (course[0] == courseName) {
        number = course[2];
      }
    }
    return number;
  }

  static bool courseEnrollingSystem(String courseName) {
    Function eq = const ListEquality().equals;

    bool isValidMustCourses = true;
    bool isValidOneCourses = true;
    List coursesMustBeEnrolled = [];
    List coursesMustOneBeEnrolled = [];
    List<String> val1 = [];
    List<bool> val = [];
    for (List course in majorCS) {
      if (course[0] == courseName) {
        coursesMustBeEnrolled = course[3][0];
        coursesMustOneBeEnrolled = course[3][1];
      }
    }
    for (String v in coursesMustOneBeEnrolled) {
      val.add(false);
    }

    for (List semester in allSemesters) {
      for (List course in semester) {
        if (course[1] != null && course[3] != null) {
          if (course[3] != 'U' &&
              course[3] != 'F' &&
              course[3] != 'Non' &&
              course[4] == null) {
            String? num = getCourseNumberByName(course[1]);
            if (num != null) {
              if (coursesMustBeEnrolled.contains(num)) {
                val1.add(num);
              }
            }
          } else if (course[4] != null &&
              course[4] != 'U' &&
              course[4] != 'F' &&
              course[4] != 'Non') {
            String? num = getCourseNumberByName(course[1]);
            if (num != null) {
              if (coursesMustBeEnrolled.contains(num)) {
                val1.add(num);
              }
            }
          }
        }
      }
    }
    if (coursesMustOneBeEnrolled.isNotEmpty) {
      for (List semester in allSemesters) {
        for (List course in semester) {
          if (course[1] != null && course[3] != null) {
            if (course[3] != 'U' &&
                course[3] != 'F' &&
                course[3] != 'Non' &&
                course[4] == null) {
              String? num = getCourseNumberByName(course[1]);
              if (num != null) {
                if (coursesMustOneBeEnrolled.isNotEmpty) {
                  if (coursesMustOneBeEnrolled.contains(num)) {
                    val = [];
                  }
                }
              }
            } else if (course[4] != null &&
                course[4] != 'U' &&
                course[4] != 'F' &&
                course[4] != 'Non') {
              String? num = getCourseNumberByName(course[1]);
              if (num != null) {
                if (coursesMustOneBeEnrolled.isNotEmpty) {
                  if (coursesMustOneBeEnrolled.contains(num)) {
                    val = [];
                  }
                }
              }
            }
          }
        }
      }
    }

    if (val.isNotEmpty) {
      if (val.contains(false)) {
        isValidOneCourses = false;
      } else {
        isValidOneCourses = true;
      }
    }
    if (eq(val1, coursesMustBeEnrolled)) {
      isValidMustCourses = true;
    } else {
      isValidMustCourses = false;
    }
    return isValidMustCourses && isValidOneCourses;
  }

  static List<String> getSuggestions(String query, List listInSemester) {
    List<String> matches = <String>[];
    if (systemOption) {
      // avoiding repeating course in the list
      List<String> coursesNamesEntered = [];
      for (List semester in allSemesters) {
        for (List course in semester) {
          if (course[1] != null && course[3] != null) {
            if (course[3] != 'U' &&
                course[3] != 'F' &&
                course[3] != 'Non' &&
                course[4] == null) {
              coursesNamesEntered.add(course[1]);
            } else if (course[4] != null &&
                course[4] != 'U' &&
                course[4] != 'F' &&
                course[4] != 'Non') {
              coursesNamesEntered.add(course[1]);
            }
          }
        }
      }

      List<String> namesCoursesInSemest = [];
      for (List course in listInSemester) {
        if (course[1] != null) {
          namesCoursesInSemest.add(course[1]);
        }
      }
      for (List course in majorCS) {
        if (!coursesNamesEntered.contains(course[0]) &&
            !namesCoursesInSemest.contains(course[0]) &&
            courseEnrollingSystem(course[0])) {
          matches.add(course[0]);
        }
      }
    } else {
      for (List course in majorCS) {
        matches.add(course[0]);
      }
    }

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
