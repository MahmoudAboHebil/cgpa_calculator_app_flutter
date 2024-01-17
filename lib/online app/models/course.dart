import 'dart:collection';
import 'package:cgp_calculator/online%20app/home_with_firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
// ToDo:  Future.delayed makes problems in speed

import '../pages/home_with_firestore_page.dart';
import 'courses_service.dart';

List<String> repeatedSemestersIds = [];
List<String> repeatedCoursesIDs = [];
List<String> halfLoadCourseId = [];

//
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
  final Function calcGPA;
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
      this.calcGPA,
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
  bool isHalfLoad = false;
  bool isRepeated = false;
  bool isValidRequirements = true;
  void repeatedAndHalfLoad(String Name) {
    if (!CollegeService.getSuggestions(Name, widget.listCoursesInSemester,
                semesterID, false, false, widget.semesterIndex)
            .contains(Name) &&
        CollegeService.getCoursesNames().contains(Name) &&
        CGPA != 0.0) {
      // print('widget.semesterIndex :${widget.semesterIndex} , Name:$Name');
      // print(Name);
      // print(CoursesService.getSuggestions(
      //     Name,
      //     widget.listCoursesInSemester,
      //     semesterID,
      //     false,
      //     widget.semesterIndex));
      setState(() {
        halfLoadCourseId.add(courseID.toString());
        halfLoadCourseId =
            LinkedHashSet<String>.from(halfLoadCourseId).toList();
        isHalfLoad = true;
      });
    } else {
      setState(() {
        bool isExist = halfLoadCourseId.contains(courseID.toString());
        if (isExist) {
          halfLoadCourseId.remove(courseID);
        }
        isHalfLoad = false;
      });
    }
    if (!CollegeService.getSuggestions('', widget.listCoursesInSemester,
                semesterID, true, true, widget.semesterIndex)
            .contains(Name) &&
        CollegeService.getCoursesNames().contains(Name) &&
        isValidRequirements &&
        !isRepeated &&
        !isHalfLoad) {
      setState(() {
        repeatedCoursesIDs.add(courseID.toString());
        repeatedCoursesIDs =
            LinkedHashSet<String>.from(repeatedCoursesIDs).toList();
        isRepeated = true;
      });
    } else {
      setState(() {
        bool isExist = repeatedCoursesIDs.contains(courseID.toString());
        if (isExist) {
          repeatedCoursesIDs.remove(courseID);
        }
        isRepeated = false;
      });
    }
  }

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
    var courseName = name ?? '';
    var creditList = '';

    bool isInList = true;

    // disable validation when departmentOption is false only after Requirements is succeed
    bool val = CollegeService.isGlobalDepartmentValidationOK() &&
        !CollegeService.departmentOption &&
        !CollegeService.getCoursesNames().contains(name);
    if (CollegeService.systemOption) {
      if (creditInput.isNotEmpty &&
          creditInput.trim().isNotEmpty &&
          !namesCoursesNotInListIds.contains(courseID.toString()) &&
          !val) {
        var name = _controller_Name.text ?? '';
        creditList = CollegeService.getCredit(name);
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
    String Name = _controller_Name.text ?? '';
    bool isRepeatedName = false;
    bool isRepeated = false;
    bool isHalfLoad = false;
    bool isInList = true;
    bool val = CollegeService.isGlobalDepartmentValidationOK() &&
        !CollegeService.departmentOption;

    if (Name.isNotEmpty && Name.trim().isNotEmpty) {
      //  is the name is repeated

      if (isRepeatedCourseModel(Name, courseID, semesterID.toString())) {
        isRepeatedName = true;
      } else {
        isRepeatedName = false;
      }
      if (CollegeService.systemOption) {
        ///todo: if the value is not at list means ( there is repeating or  half-load )

        // print('#########herrrrrrrrrrrrrrrrrrrrrr');

        // print(CoursesService.getSuggestions(Name, widget.listCoursesInSemester,
        //     semesterID, false, widget.semesterIndex));

        ///todo: if the value is not allowed case CGPA<1.67

        if (!CollegeService.getCoursesNames().contains(Name) && !val) {
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

        if (!CollegeService.courseEnrollingSystem(
            Name, semesterID, widget.listCoursesInSemester)) {
          List<int> allSemesterIds = [];
          List<int> allSemesterIdsBeforeTheCurrentSemest = [];
          // print(earnCredit);
          // print(Name);
          for (List semester in allSemesters) {
            for (List course in semester) {
              allSemesterIds.add(course[0]);
            }
          }
          for (int v in allSemesterIds) {
            if (semesterID < v) {
              allSemesterIdsBeforeTheCurrentSemest.add(v);
            }
          }
          setState(() {
            namesCoursesNotInRequirements.add(courseID.toString());
            namesCoursesNotInRequirements =
                LinkedHashSet<String>.from(namesCoursesNotInRequirements)
                    .toList();
            isValidRequirements = false;
          });
        } else {
          bool isExist =
              namesCoursesNotInRequirements.contains(courseID.toString());
          setState(() {
            if (isExist) {
              namesCoursesNotInRequirements.remove(courseID);
            }
            isValidRequirements = true;
          });
        }
        if (widget.semesterIndex == 1) {
          // print('##################################');
          // print(Name);
          // print(CoursesService.getSuggestions(
          //         '', [], semesterID, true, widget.semesterIndex)
          //     .contains(Name));
        }
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
      bool isExist2 = repeatedCoursesIDs.contains(courseID.toString());
      setState(() {
        if (isExist2) {
          repeatedCoursesIDs.remove(courseID);
        }
      });
      bool isExist3 = halfLoadCourseId.contains(courseID.toString());

      setState(() {
        if (isExist3) {
          halfLoadCourseId.remove(courseID);
        }
        isValidRequirements = true;
      });
      isHalfLoad = false;

      isInList = true;
    }

    return !isRepeatedName &&
        isInList &&
        isValidRequirements &&
        !isHalfLoad &&
        !isRepeated;
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
    'W',
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
      repeatedSemestersIds = [];
      namesCoursesNotInListIds = [];
      namesCoursesNotInRequirements = [];
      creditsCoursesNotInListIds = [];

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
    // repeatedAndHalfLoad(name ?? '');
  }

  void _onFocusNameChange() {
    suggestionBoxController.suggestionsBox?.close();
    errorGrade();

    if (!_focusName.hasFocus) {
      validationMethod();
      repeatedAndHalfLoad(_controller_Name.text);
    }
  }

  void _onFocusCreditChange() {
    errorGrade();

    if (!_focusCredit.hasFocus) {
      validationMethod();
    }
  }

  void _onFocusGradeChange() {
    errorGrade();

    if (!_focusGrade.hasFocus) {
      validationMethod();
    }
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

  deleteCourse() async {
    setState(() {
      pressDeleteCourse = true;
      isHalfLoad = false;
      isRepeated = false;
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
      widget.calcGPA();
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
                                          style: TextStyle(
                                            fontSize: 16,
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
                            width: 65,
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
                                      '2 nd',
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
                                          fontSize: 16,
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
                          width: 65,
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
                widget.callBackUpdateChange();
              }

              widget.callBackUpdateListCoursesInSemester(
                  widget.listCoursesInSemester);
              widget.calcCGPA();
              widget.calcGPA();
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
                    height: 30,
                    margin: EdgeInsets.only(top: 0, left: 10),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: _focusName.hasFocus
                          ? BorderSide(
                              color: valideName &&
                                      isValidNameSystem() &&
                                      !isRepeated &&
                                      !isHalfLoad
                                  ? Color(0xff4562a7)
                                  : Color(0xffce2029),
                            )
                          : BorderSide(
                              color: valideName &&
                                      isValidNameSystem() &&
                                      !isRepeated &&
                                      !isHalfLoad
                                  ? Colors.white
                                  : Color(0xffce2029)),
                    )),
                    child: CollegeService.systemOption
                        ? TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: _controller_Name,
                              scrollPadding: EdgeInsets.only(bottom: 200),
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.bottom,
                              focusNode: _focusName,
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff004d60),
                              ),
                              onChanged: (value) {
                                if (value != 'There are no courses left') {
                                  // print(
                                  //     '######################44#####################');
                                  setState(() {
                                    // auto grade2 if grade 1 fail
                                    for (List semester in allSemesters) {
                                      for (List course in semester) {
                                        if (course[1] ==
                                            _controller_Name.text) {
                                          if ((course[3] == 'U' ||
                                                  course[3] == 'Non' ||
                                                  course[3] == 'F') &&
                                              course[4] == null) {
                                            val = true;

                                            selectedValue1 = course[3];
                                            selectedValueIs1Null = false;
                                            widget.listCoursesInSemester[widget
                                                .index][3] = selectedValue1;
                                            widget.courseList[3] =
                                                selectedValue1;

                                            widget.listCoursesInSemester[
                                                widget.index][5] = 'two';
                                          } else if ((course[4] == 'U' ||
                                                  course[4] == 'Non' ||
                                                  course[4] == 'F') &&
                                              course[4] != null) {
                                            val = true;

                                            selectedValue1 = course[4];
                                            selectedValueIs1Null = false;

                                            widget.listCoursesInSemester[widget
                                                .index][3] = selectedValue1;
                                            widget.courseList[3] =
                                                selectedValue1;

                                            widget.listCoursesInSemester[
                                                widget.index][5] = 'two';
                                          }
                                          credit = course[2];
                                          _controller_Credit.text = credit!;
                                          widget.courseList[2] = credit!;

                                          widget.listCoursesInSemester[
                                              widget.index][2] = credit!;
                                        }
                                      }
                                    }
                                    widget.courseList[1] = value;
                                    name = value;
                                    if (value.isNotEmpty) {
                                      widget.listCoursesInSemester[widget.index]
                                          [1] = value;
                                    } else {
                                      widget.listCoursesInSemester[widget.index]
                                          [1] = null;
                                    }

                                    errorGrade();

                                    allSemesters[widget.semesterIndex]
                                            [widget.index] =
                                        widget.listCoursesInSemester[
                                            widget.index];
                                    widget.callBackUpdateListCoursesInSemester(
                                        widget.listCoursesInSemester);
                                    widget.callBackUpdateChange();

                                    selectedValueIs1Null;
                                    selectedValueIs2Null;
                                  });
                                }
                              },
                              maxLines: 1,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.only(bottom: 3),
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
                              return CollegeService.getSuggestions(
                                  pattern,
                                  widget.listCoursesInSemester,
                                  semesterID,
                                  true,
                                  false,
                                  widget.semesterIndex);
                            },
                            itemBuilder: (context, String suggestion) {
                              return suggestion != 'There are no courses left'
                                  ? Container(
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
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 10),
                                      child: Text(suggestion,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey.shade700,
                                          )),
                                    );
                            },
                            suggestionsBoxController: suggestionBoxController,
                            hideOnEmpty: false,
                            onSuggestionSelected: (String suggestion) {
                              if (suggestion != 'There are no courses left') {
                                this._controller_Name.text = suggestion;

                                setState(() {
                                  // auto grade2 if grade 1 fail
                                  for (List semester in allSemesters) {
                                    for (List course in semester) {
                                      if (course[1] == _controller_Name.text) {
                                        if ((course[3] == 'U' ||
                                                course[3] == 'Non' ||
                                                course[3] == 'F') &&
                                            course[4] == null) {
                                          val = true;

                                          selectedValue1 = course[3];
                                          selectedValueIs1Null = false;
                                          widget.listCoursesInSemester[
                                              widget.index][3] = selectedValue1;
                                          widget.courseList[3] = selectedValue1;

                                          widget.listCoursesInSemester[
                                              widget.index][5] = 'two';
                                        } else if ((course[4] == 'U' ||
                                                course[4] == 'Non' ||
                                                course[4] == 'F') &&
                                            course[4] != null) {
                                          val = true;

                                          selectedValue1 = course[4];
                                          selectedValueIs1Null = false;

                                          widget.listCoursesInSemester[
                                              widget.index][3] = selectedValue1;
                                          widget.courseList[3] = selectedValue1;

                                          widget.listCoursesInSemester[
                                              widget.index][5] = 'two';
                                        }
                                        credit = course[2];
                                        _controller_Credit.text = credit!;
                                        widget.courseList[2] = credit!;

                                        widget.listCoursesInSemester[
                                            widget.index][2] = credit!;
                                      }
                                    }
                                  }

                                  errorGrade();
                                  widget.courseList[1] = suggestion;
                                  name = suggestion;
                                  if (suggestion.isNotEmpty) {
                                    widget.listCoursesInSemester[widget.index]
                                        [1] = suggestion;
                                  } else {
                                    widget.listCoursesInSemester[widget.index]
                                        [1] = null;
                                  }

                                  //  auto credit
                                  String value =
                                      CollegeService.getCredit(suggestion);
                                  credit = value;
                                  _controller_Credit.text = value;
                                  if (value.isNotEmpty) {
                                    widget.listCoursesInSemester[widget.index]
                                        [2] = value;
                                  } else {
                                    widget.listCoursesInSemester[widget.index]
                                        [2] = null;
                                  }

                                  allSemesters[widget.semesterIndex]
                                          [widget.index] =
                                      widget
                                          .listCoursesInSemester[widget.index];

                                  widget.callBackUpdateListCoursesInSemester(
                                      widget.listCoursesInSemester);
                                  widget.callBackUpdateChange();

                                  selectedValueIs1Null;
                                  selectedValueIs2Null;
                                });
                              }
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
                          )
                        : TextField(
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
                                // auto grade2 if grade 1 fail
                                for (List semester in allSemesters) {
                                  for (List course in semester) {
                                    if (course[1] == _controller_Name.text) {
                                      if ((course[3] == 'U' ||
                                              course[3] == 'Non' ||
                                              course[3] == 'F') &&
                                          course[4] == null) {
                                        val = true;

                                        selectedValue1 = course[3];
                                        selectedValueIs1Null = false;
                                        widget.listCoursesInSemester[
                                            widget.index][3] = selectedValue1;
                                        widget.courseList[3] = selectedValue1;

                                        widget.listCoursesInSemester[
                                            widget.index][5] = 'two';
                                      } else if ((course[4] == 'U' ||
                                              course[4] == 'Non' ||
                                              course[4] == 'F') &&
                                          course[4] != null) {
                                        val = true;

                                        selectedValue1 = course[4];
                                        selectedValueIs1Null = false;

                                        widget.listCoursesInSemester[
                                            widget.index][3] = selectedValue1;
                                        widget.courseList[3] = selectedValue1;

                                        widget.listCoursesInSemester[
                                            widget.index][5] = 'two';
                                      }
                                      credit = course[2];
                                      _controller_Credit.text = credit!;
                                      widget.courseList[2] = credit!;

                                      widget.listCoursesInSemester[widget.index]
                                          [2] = credit!;
                                    }
                                  }
                                }

                                widget.courseList[1] = value;
                                name = value;
                                if (value.isNotEmpty) {
                                  widget.listCoursesInSemester[widget.index]
                                      [1] = value;
                                } else {
                                  widget.listCoursesInSemester[widget.index]
                                      [1] = null;
                                }

                                errorGrade();

                                allSemesters[widget.semesterIndex]
                                        [widget.index] =
                                    widget.listCoursesInSemester[widget.index];
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
                  ),
                ],
              ),
              Container(
                width: 60,
                height: 30,
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
                    contentPadding: EdgeInsets.only(bottom: 3),
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                    hintText: 'Credit',
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent)),
                  ),
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
