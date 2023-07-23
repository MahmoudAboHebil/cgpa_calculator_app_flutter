import 'package:cgp_calculator/home_with_firestore_services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Course extends StatefulWidget {
  final int index;
  final int semesterIndex;
  final List courseList;
  final List listCoursesInSemester;
  final List listAllSemesters;
  final Function callBackUpdateListCoursesInSemester;
  final Function callBackUpdateListAllSemesters;
  final Function callBackUpdateChange;
  final Function calcCGPA;
  final GlobalKey<AnimatedListState> _keyAniSemest;
  Course(
      this.index,
      this.semesterIndex,
      this.courseList,
      this.listCoursesInSemester,
      this.listAllSemesters,
      this.callBackUpdateListCoursesInSemester,
      this.callBackUpdateListAllSemesters,
      this.callBackUpdateChange,
      this.calcCGPA,
      this._keyAniSemest,
      {Key? key})
      : super(key: key);

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  final HomeWithFireStoreServices homeWithFireStoreServices =
      HomeWithFireStoreServices();
  late TextEditingController _controller_Name;
  late TextEditingController _controller_Credit;
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
      if (!_focusCredit.hasFocus && !_focusGrade.hasFocus) {
        print(
            '_onFocus  Name Change jffffffffffffffffffffffffffffffffffffffffffff');

        widget
            .callBackUpdateListCoursesInSemester(widget.listCoursesInSemester);
        widget.callBackUpdateChange();
      }
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
      if (!_focusName.hasFocus && !_focusGrade.hasFocus) {
        print(
            '_onFocus  Credit   Change jffffffffffffffffffffffffffffffffffffffffffff');
        widget
            .callBackUpdateListCoursesInSemester(widget.listCoursesInSemester);
        widget.callBackUpdateChange();
      }
    }
  }

  void _onFocusGradeChange() {
    if (_focusGrade.hasFocus) {
    } else {
      // Future.delayed(D)
      if (!_focusName.hasFocus && !_focusCredit.hasFocus) {
        print(
            '_onFocus  Grade   Change jffffffffffffffffffffffffffffffffffffffffffff');
        widget
            .callBackUpdateListCoursesInSemester(widget.listCoursesInSemester);
        widget.callBackUpdateChange();
      }
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

      homeWithFireStoreServices.updateData(
          semesterID, courseID, null, null, null, null, 'one');
      // addCourseInDB(semesterID, courseID, null, null, null, null, 'one');
      widget.listAllSemesters[widget.semesterIndex][widget.index] =
          widget.listCoursesInSemester[widget.index];
      widget.callBackUpdateListAllSemesters(widget.listAllSemesters);
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
              widget.listAllSemesters,
              widget.callBackUpdateListCoursesInSemester,
              widget.callBackUpdateListAllSemesters,
              () {},
              () {},
              widget._keyAniSemest),
        );
      }, duration: Duration(milliseconds: 300));
      Future.delayed(Duration(milliseconds: 310), () {
        homeWithFireStoreServices.deleteCourseFromDB(courseID);
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
                  // _focusName.unfocus();
                  // _focusCredit.unfocus();
                  print('heeeeeeeeeeeeeeeeeeeeeeee');

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
                    // openWithLongPress: true,
                    // focusNode: _focusGrade,
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
                        // focusNode: _focusName,
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
                            widget.callBackUpdateListCoursesInSemester(
                                widget.listCoursesInSemester);
                            widget.callBackUpdateChange();

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
                        color: valideCredit
                            ? Color(0xff4562a7)
                            : Color(0xffce2029),
                      )
                    : BorderSide(
                        color: valideCredit ? Colors.white : Color(0xffce2029)),
              )),
              child: Column(
                children: [
                  TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: _controller_Credit,
                    // focusNode: _focusCredit,
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
