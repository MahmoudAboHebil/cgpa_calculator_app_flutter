import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:cgp_calculator/providerBrain.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:collection/collection.dart';
import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ToDo: the data entry removed when click the deleteCourse button  (done)
// ToDo: there is a problem sometimes when clicking the addCourse button  (done)
// ToDo: name disappear when get long  (done)
// ToDo: save data in DataBase automatic without press any button  ( -i need that to update the id- done)
// ToDo: there is a problem when save a data in dataBase in same time there some  validation errors (done)
// ToDo: must do not call calc button function if there any errors about  validation (done)
// ToDo: the validation design need to fix  (done)
// ToDo: the validation need to be more handel like the course must be not repeated in one semester (will be problem when dealing by one year CGPA ,so no need)
// ToDo: validation message  (done)
// ToDo: add second try course ( need to save option in database & put its validation when press the calc button done)
// ToDo: there is a bug in arrangement element when delete course   (done)

// ToDo: finish the semester design
// ToDo: there is a problem when scrolling (done but you need to disappear the waving at end and start of scrolling)

var box = Hive.box('courses177');
// [[semesterNum,courseName,credit,grade1,grade2,('two' for two grade otherwise 'one') ],....]
GlobalKey<AnimatedListState> _keyOfCourse = GlobalKey();
List listOfCoursesInSemester = [];

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  List allCourse = [];
  List<String> Ids = [];
  int numbersOfSemester = 0;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    print(box.toMap());
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
    // getData();
    Provider.of<MyData>(context).isChanged;

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
                    ListView(
                      shrinkWrap: true,
                      children: [
                        AppBarHome(),
                        Semester(1),
                      ],
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Semester extends StatefulWidget {
  int semesterNum;

  Semester(this.semesterNum);

  @override
  State<Semester> createState() => _SemesterState();
}

class _SemesterState extends State<Semester> {
  late String semestNumString;
  bool val = true;
  void getData() async {
    setState(() {
      listOfCoursesInSemester.clear();
    });
    bool t = box.isEmpty;
    if (t && val) {
      // emtyBox
      setState(() {
        listOfCoursesInSemester
            .add([semestNumString, null, null, null, null, 'one']);
      });
      setState(() {
        val = false;
      });
    } else {
      Map map = box.toMap();

      for (final mapEntry in map.entries) {
        var key = mapEntry.key;
        var value = mapEntry.value;
        setState(() {
          listOfCoursesInSemester.add(value);
          listOfCoursesInSemester = listOfCoursesInSemester.toSet().toList();
        });
      }
    }
  }

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
    setState(() {
      listOfCoursesInSemester
          .add([semestNumString, null, null, null, null, 'one']);
    });
    int insertIndex = listOfCoursesInSemester.isEmpty
        ? listOfCoursesInSemester.length
        : listOfCoursesInSemester.length - 1;
    // print('################# insertIndex: $insertIndex ######################');
    _keyOfCourse.currentState!.insertItem(insertIndex);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      semestNumString = widget.semesterNum.toString();
    });
    getData();
    // print('################### map #####################');
    // print(box.toMap());
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              // height: 50,
              margin: EdgeInsets.only(left: 25, bottom: 10, right: 10),
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
                        '$semestNumString',
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
                        'GPA 2.57',
                        style: TextStyle(
                          color: Color(0xff004d60),
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '2.57',
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
                        '333',
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
                return Course(
                  listOfCoursesInSemester[index][0],
                  listOfCoursesInSemester[index][1],
                  listOfCoursesInSemester[index][2],
                  listOfCoursesInSemester[index][3],
                  listOfCoursesInSemester[index][4],
                  listOfCoursesInSemester[index][5],
                  listOfCoursesInSemester[index],
                );
              },
              initialItemCount: listOfCoursesInSemester.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              key: _keyOfCourse,
            ),
            Row(
              mainAxisAlignment: Provider.of<MyData>(context).isChanged
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
                Provider.of<MyData>(context).isChanged
                    ? GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          findErrors();
                          print(listOfCoursesInSemester);
                          print(emptyField);
                          print(creditEqZero);
                          print(creditMoreThanThree);

                          if (emptyField == null &&
                              creditEqZero == null &&
                              creditMoreThanThree == null) {
                            Provider.of<MyData>(context, listen: false)
                                .changeSaveData(true);
                            Provider.of<MyData>(context, listen: false)
                                .change(false);
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
                          Future.delayed(Duration(milliseconds: 600), () {
                            Provider.of<MyData>(context, listen: false)
                                .changeSaveData(false);
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
  String? semestNum;
  String? name;
  String? credite;
  String? grade1;
  String? grade2;
  String option;
  List courseList;
  Course(this.semestNum, this.name, this.credite, this.grade1, this.grade2,
      this.option, this.courseList);

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  late TextEditingController _controller_Name;
  late TextEditingController _controller_Credit;
  final Function eq = const ListEquality().equals;
  FocusNode _focusName = FocusNode();
  FocusNode _focusCredite = FocusNode();
  void _onFocusNameChange() {
    // print("Focus Name: ${_focusName.hasFocus.toString()}");

    if (_focusName.hasFocus) {
      Provider.of<MyData>(context, listen: false).changeSaveData(true);
      Provider.of<MyData>(context, listen: false).changeSetValues(false);
    } else {
      Provider.of<MyData>(context, listen: false).changeSaveData(false);

      Provider.of<MyData>(context, listen: false).changeSetValues(true);
    }
    // bool setValues = Provider.of<MyData>(context, listen: false).setValues;
    // print(
    //     '######################  $setValues  #################################');
  }

  void _onFocusCrediteChange() {
    // print("Focus Credite: ${_focusCredite.hasFocus.toString()}");

    if (_focusCredite.hasFocus) {
      Provider.of<MyData>(context, listen: false).changeSaveData(true);
      Provider.of<MyData>(context, listen: false).changeSetValues(false);
    } else {
      Provider.of<MyData>(context, listen: false).changeSaveData(false);
      Provider.of<MyData>(context, listen: false).changeSetValues(true);
    }

    // bool setValues = Provider.of<MyData>(context, listen: false).setValues;
    // print(
    //     '######################  $setValues  #################################');
  }

  late String? selectedValue1;
  late String? selectedValue2;
  bool selectedValueIs1Null = false;
  bool selectedValueIs2Null = false;
  int index = 0;
  int? id;
  final List<String> items = [
    'A+',
    'b+',
    'c+',
    'd+',
    'e+',
    'f+',
    'g',
    'k+',
  ];
  void test() {
    bool setValues = Provider.of<MyData>(context, listen: false).setValues;
    bool isDelete = Provider.of<MyData>(context, listen: false).delete;
    print('p############### $isDelete ##############');
    print(widget.grade2);
    // if (isDelete) {
    setState(() {
      val = widget.courseList[5] == 'one' ? false : true;
    });
    // }
    print('###################### test ##########################');
    print(box.toMap());
    // print(listOfCoursesInSemester);
    if (setValues) {
      setState(() {
        index = listOfCoursesInSemester.indexOf(widget.courseList);
        selectedValue1 = widget.grade1;
        selectedValue2 = widget.grade2;
        // selectedValue == null
        //     ? selectedValueIsNull = true
        //     : selectedValueIsNull = false;
        if (widget.name == null) {
          _controller_Name = TextEditingController();
        } else {
          _controller_Name = TextEditingController(text: widget.name);
        }
        if (widget.credite == null) {
          _controller_Credit = TextEditingController();
        } else {
          _controller_Credit = TextEditingController(text: widget.credite);
        }
      });
    }
  }

  // void isNameRepeating() {
  //   var t = box.isNotEmpty;
  //   if (t) {
  //     Map map = box.toMap();
  //     List list = [];
  //     for (final mapEntry in map.entries) {
  //       var key = mapEntry.key;
  //       var value = mapEntry.value;
  //       list.add(value[1]);
  //     }
  //
  //     print('############## list ######################');
  //     print(list);
  //   }
  // }

  // bool secondTry = false;
  @override
  void initState() {
    super.initState();
    _focusName.addListener(_onFocusNameChange);
    _focusCredite.addListener(_onFocusCrediteChange);

    setState(() {
      index = listOfCoursesInSemester.indexOf(widget.courseList);
      selectedValue1 = widget.grade1;
      selectedValue2 = widget.grade2;
      val = widget.courseList[5] == 'one' ? false : true;
      if (widget.name == null) {
        _controller_Name = TextEditingController();
      } else {
        _controller_Name = TextEditingController(text: widget.name);
      }
      if (widget.credite == null) {
        _controller_Credit = TextEditingController();
      } else {
        _controller_Credit = TextEditingController(text: widget.credite);
      }
    });

    var name = _controller_Name.text;
    var credit = _controller_Credit.text;
    String? sNum = widget.courseList[0];
    String option = widget.courseList[5];
    var idBox = box.toMap().keys.firstWhere(
        (k) => eq(box.toMap()[k],
            [sNum, name, credit, selectedValue1, selectedValue2, option]),
        orElse: () => null);
    setState(() {
      id = idBox;
    });
    validationMethod();
  }

  bool valideName = true;
  bool valideCredit = true;
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

  String? get _errorCredit {
    var name = widget.name ?? '';
    var credit = widget.credite ?? '';
    // if (pressed) {
    if (credit.isNotEmpty && credit.length > 3) {
      return '';
    }
    if (credit.isNotEmpty &&
        (int.parse(credit) == 0 ||
            int.parse(credit) == 00 ||
            int.parse(credit) == 000)) {
      return '';
    }

    if ((name.isNotEmpty && name.trim().isNotEmpty)) {
      if (credit.isEmpty || credit.trim().isEmpty) {
        return '';
      }
    } else if ((credit.isEmpty || credit.trim().isEmpty) &&
        (selectedValue1 != null || selectedValue2 != null)) {
      return '';
    }
    // }
    return null;
  }

  String? get _errorName {
    var name = widget.name ?? '';
    var credit = widget.credite ?? '';
    // if (pressed) {

    if (credit.isNotEmpty && credit.trim().isNotEmpty) {
      if (name.isEmpty || name.trim().isEmpty) {
        return '';
      }
    } else if ((name.isEmpty || name.trim().isEmpty) &&
        (selectedValue1 != null || selectedValue2 != null)) {
      return '';
    }
    // }

    return null;
  }

  void errorGrade() {
    var name = widget.name ?? '';
    var credit = widget.credite ?? '';
    // if (pressed) {
    if ((name.isNotEmpty && name.trim().isNotEmpty) ||
        (credit.isNotEmpty && credit.trim().isNotEmpty)) {
      if (selectedValue1 == null) {
        setState(() {
          selectedValueIs1Null = true;
          // print('############# red ###############');
        });
      } else {
        setState(() {
          selectedValueIs1Null = false;
          // print('############# white ###############');
        });
      }
      if (selectedValue2 == null) {
        setState(() {
          selectedValueIs2Null = true;
          // print('############# red ###############');
        });
      } else {
        setState(() {
          selectedValueIs2Null = false;
          // print('############# white ###############');
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
        // print('############# white ###############');
      });
    }
    // }
  }

  bool pressDelete = false;
  void deleteCourse() {
    Provider.of<MyData>(context, listen: false).changeSaveData(false);
    setState(() {
      pressDelete = true;
      // delete = true;
      // List deletedCourse = [
      //   widget.semestCourse,
      //   widget.name,
      //   widget.credite,
      //   widget.grade
      // ];
      int index = listOfCoursesInSemester.indexOf(widget.courseList);
      List deletedCourse = listOfCoursesInSemester.removeAt(index);
      // print('################## deleted course###############################');
      // print(deletedCourse);
      _keyOfCourse.currentState!.removeItem(index, (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          key: ValueKey(
            widget.name,
          ),
          child: Course(widget.semestNum, widget.name, widget.credite,
              widget.grade1, widget.grade2, widget.option, widget.courseList),
        );
      }, duration: Duration(milliseconds: 400));
      var id = box.toMap().keys.firstWhere(
          (k) => eq(box.toMap()[k], deletedCourse),
          orElse: () => null);
      print('################# id delete: $id ############################');
      if (id != null) {
        // print('################# id delete: $id ############################');
        box.delete(id);
        setState(() {
          id == null;
        });
      }
    });
    // Future.delayed(Duration(milliseconds: 600), () {
    //   setState(() {
    //     pressDelete = false;
    //   });
    // });
  }

  late MyData _provider;

  @override
  void didChangeDependencies() {
    _provider = Provider.of<MyData>(context, listen: false);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _controller_Name.dispose();
    _controller_Credit.dispose();
    _focusName.removeListener(_onFocusNameChange);
    _focusName.dispose();
    _focusCredite.removeListener(_onFocusCrediteChange);
    _focusCredite.dispose();
  }

  late bool val;
  void collectDate() {
    bool save = Provider.of<MyData>(context, listen: false).savaData;
    var name = _controller_Name.text;
    var credit = _controller_Credit.text;
    String? sNum = widget.courseList[0];
    String option = widget.courseList[5];
    setState(() {
      selectedValue2 = widget.courseList[4];
    });
    if (valideName &&
        valideCredit &&
        selectedValue1 != null &&
        save &&
        !pressDelete) {
      List? alreadyExistValue = box.get(id);
      if (alreadyExistValue != null) {
        // list is already exist
        if (val) {
          box.put(
              id, [sNum, name, credit, selectedValue1, selectedValue2, 'two']);
        } else {
          box.put(id, [sNum, name, credit, selectedValue1, null, 'one']);
        }
      } else {
        // a  new list
        if (val) {
          box.add([sNum, name, credit, selectedValue1, selectedValue2, 'two']);
        } else {
          box.add([sNum, name, credit, selectedValue1, null, 'one']);
        }
        var idBox = box.toMap().keys.firstWhere(
            (k) => eq(box.toMap()[k],
                [sNum, name, credit, selectedValue1, selectedValue2, option]),
            orElse: () => null);

        setState(() {
          id = idBox;
        });
      }
      print('################## save :$save ############################');
      print(box.toMap());
    }
  }

  // void theStateOfCourse() {
  //   if (_errorName == null) {
  //     Provider.of<MyData>(context, listen: false).stateOfName(true);
  //   } else {
  //     Provider.of<MyData>(context, listen: false).stateOfName(false);
  //   }
  //   if (_errorCredit == null) {
  //     Provider.of<MyData>(context, listen: false).stateOfCredit(true);
  //   } else {
  //     Provider.of<MyData>(context, listen: false).stateOfCredit(false);
  //   }
  //   if (selectedValue1 != null) {
  //     Provider.of<MyData>(context, listen: false).stateOfGrade(true);
  //   } else {
  //     Provider.of<MyData>(context, listen: false).stateOfGrade(false);
  //   }
  // }

  // void findSecondTryCourse() {
  //   if (_controller_Name.text.endsWith('*')) {
  //     setState(() {
  //       secondTry = true;
  //     });
  //   } else {
  //     setState(() {
  //       secondTry = false;
  //     });
  //   }
  // }

  @override
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
                        onChanged: (value) {
                          setState(() {
                            Provider.of<MyData>(context, listen: false)
                                .change(true);
                            selectedValue1 = value as String;
                            widget.courseList[3] = selectedValue1;
                            listOfCoursesInSemester[index][3] = value;
                            // print('################# courseList ######################');
                            // print(courseList);
                            // print(
                            //     '################# semsestcourses ######################');
                            // print(widget.semestCourse[index]);

                            errorGrade();
                            // theStateOfCourse();
                            // Provider.of<MyData>(context, listen: false)
                            //     .changeSaveData(true);

                            collectDate();
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
                        // menuItemStyleData: const MenuItemStyleData(
                        //   height: 40,
                        //   padding: EdgeInsets.only(left: 14, right: 14),
                        // ),
                      ),
                    ),
                  ),
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
                        onChanged: (value) {
                          setState(() {
                            Provider.of<MyData>(context, listen: false)
                                .change(true);
                            selectedValue2 = value as String;
                            widget.courseList[4] = selectedValue2;
                            listOfCoursesInSemester[index][4] = value;
                            // print('################# courseList ######################');
                            // print(courseList);
                            // print(
                            //     '################# semsestcourses ######################');
                            // print(widget.semestCourse[index]);

                            errorGrade();
                            // theStateOfCourse();
                            // Provider.of<MyData>(context, listen: false)
                            //     .changeSaveData(true);

                            collectDate();
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
                        // menuItemStyleData: const MenuItemStyleData(
                        //   height: 40,
                        //   padding: EdgeInsets.only(left: 14, right: 14),
                        // ),
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
                    onChanged: (value) {
                      setState(() {
                        Provider.of<MyData>(context, listen: false)
                            .change(true);
                        selectedValue1 = value as String;
                        widget.courseList[3] = selectedValue1;
                        listOfCoursesInSemester[index][3] = value;
                        // print('################# courseList ######################');
                        // print(courseList);
                        // print(
                        //     '################# semsestcourses ######################');
                        // print(widget.semestCourse[index]);

                        errorGrade();
                        // theStateOfCourse();
                        // Provider.of<MyData>(context, listen: false)
                        //     .changeSaveData(true);

                        collectDate();
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
                    // menuItemStyleData: const MenuItemStyleData(
                    //   height: 40,
                    //   padding: EdgeInsets.only(left: 14, right: 14),
                    // ),
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
                  listOfCoursesInSemester[index][4] = null;
                  widget.courseList[5] = 'one';
                  listOfCoursesInSemester[index][5] = 'one';
                  var name = _controller_Name.text;
                  var credit = _controller_Credit.text;
                  String? sNum = widget.courseList[0];
                  if (id != null) {
                    box.put(
                        id, [sNum, name, credit, selectedValue1, null, 'one']);
                  }
                });
              } else {
                setState(() {
                  widget.courseList[4] = selectedValue2;
                  listOfCoursesInSemester[index][4] = selectedValue2;

                  widget.courseList[5] = 'two';
                  listOfCoursesInSemester[index][5] = 'two';
                  var name = _controller_Name.text;
                  var credit = _controller_Credit.text;
                  String? sNum = widget.courseList[0];
                  if (id != null) {
                    box.put(id, [
                      sNum,
                      name,
                      credit,
                      selectedValue1,
                      selectedValue2,
                      'two'
                    ]);
                  }
                });
              }
              print('###########################');
              print(box.toMap());
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

              // val ?
              // Icon(
              //         Icons.check_box,
              //         color: Colors.green,
              //       )
              //     : Icon(
              //         Icons.check_box_outline_blank,
              //         color: Colors.green,
              //       ),
            ),
          ),
        )
      ],
    );
  }

  Widget build(BuildContext context) {
    if (mounted) {
      test();
      errorGrade();
      validationMethod();
      // theStateOfCourse;
      // if (!pressDelete) {
      // setState(() {
      //   val;
      //   gradeContainer();
      // });

      collectDate();
      // findSecondTryCourse();
      // }
    }

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
                    setState(() {
                      FocusManager.instance.primaryFocus?.unfocus();

                      // Provider.of<MyData>(context, listen: false)
                      //     .changeDelete(true);
                      //
                      pressDelete = true;
                      Provider.of<MyData>(context, listen: false)
                          .changeDelete(true);
                      deleteCourse();
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
                    autofocus: false,
                    focusNode: _focusName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff004d60),
                    ),
                    onChanged: (value) {
                      Provider.of<MyData>(context, listen: false).change(true);
                      setState(() {
                        widget.courseList[1] = value;
                        if (value.isNotEmpty) {
                          listOfCoursesInSemester[index][1] = value;
                        } else {
                          listOfCoursesInSemester[index][1] = null;
                        }
                        errorGrade();
                        selectedValueIs1Null;
                        selectedValueIs2Null;
                        // theStateOfCourse();
                        collectDate();
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
                textAlign: TextAlign.center,
                focusNode: _focusCredite,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  Provider.of<MyData>(context, listen: false).change(true);
                  setState(() {
                    widget.courseList[2] = value;
                    if (value.isNotEmpty) {
                      listOfCoursesInSemester[index][2] = value;
                    } else {
                      listOfCoursesInSemester[index][2] = null;
                    }
                    // theStateOfCourse();
                    collectDate();
                  });
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
