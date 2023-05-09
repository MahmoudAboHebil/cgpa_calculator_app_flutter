import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:cgp_calculator/providerBrain.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:collection/collection.dart';
import 'package:dropdown_button2/src/dropdown_button2.dart';
// ToDo: the data entry removed when click the deleteCourse button  (done)
// ToDo: there is a problem sometimes when clicking the addCourse button  (done)
// ToDo: name disappear when get long  (done)
// ToDo: save data in DataBase automatic without press any button  ( -i need that to update the id- done)
// ToDo: there is a problem when save a data in dataBase in same time there some  validation errors (done)
// ToDo: must do not call calc button function if there any errors about  validation (done)
// ToDo: the validation design need to fix  (done)

// ToDo: the validation need to be more handel like the course must be not repeated in one semester
// ToDo: there is a problem when scrolling

var box = Hive.box('courses1');
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
            body: ListView(
              shrinkWrap: true,
              children: [
                AppBarHome(),
                Semester(1),
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
        listOfCoursesInSemester.add([semestNumString, null, null, null]);
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
      if (!(course[1] == null && course[2] == null && course[3] == null)) {
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
      listOfCoursesInSemester.add([semestNumString, null, null, null]);
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
            padding: const EdgeInsets.all(8),
            height: 75,
            decoration: const BoxDecoration(
              color: Color(0xff4562a7),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 48,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Oops Error!',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        'This Username is not found! Please try again later',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
            // Container(
            //   alignment: Alignment.center,
            //   // height: 50,
            //   // width: 100,
            //   decoration: BoxDecoration(
            //       color: Color(0xffeaf1ed),
            //       borderRadius: BorderRadius.all(Radius.circular(20)),
            //       border: Border.all(color: Color(0xff004d60), width: 2)),
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            //     child: Text(
            //       'Semester $semestNumString',
            //       style: TextStyle(
            //         color: Color(0xff4562a7),
            //         fontSize: 20,
            //       ),
            //     ),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20),
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
                  listOfCoursesInSemester[index],
                );
              },
              initialItemCount: listOfCoursesInSemester.length,
              shrinkWrap: true,
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
                          // message();
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
  String? grade;
  List courseList;
  Course(this.semestNum, this.name, this.credite, this.grade, this.courseList);

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

  late String? selectedValue;
  bool selectedValueIsNull = false;
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
    if (setValues) {
      setState(() {
        index = listOfCoursesInSemester.indexOf(widget.courseList);
        selectedValue = widget.grade;
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

  @override
  void initState() {
    super.initState();
    _focusName.addListener(_onFocusNameChange);
    _focusCredite.addListener(_onFocusCrediteChange);

    setState(() {
      index = listOfCoursesInSemester.indexOf(widget.courseList);
      selectedValue = widget.grade;
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
    var idBox = box.toMap().keys.firstWhere(
        (k) => eq(box.toMap()[k], [sNum, name, credit, selectedValue]),
        orElse: () => null);
    setState(() {
      id = idBox;
    });
    validationMethod();
  }

  bool valideName = true;
  bool valideCredit = true;
  void validationMethod() {
    // bool containe = false;
    // setState(() {
    //   if (_controller_Name.text.isNotEmpty && box.isNotEmpty) {
    //     Map map = box.toMap();
    //     for (final mapEntry in map.entries) {
    //       var key = mapEntry.key;
    //       var values = mapEntry.value;
    //       if (values[1] == _controller_Name.text) {
    //         containe = true;
    //       }
    //     }
    //   }
    // });
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

    if ((name.isNotEmpty && name.trim().isNotEmpty)) {
      if (credit.isEmpty || credit.trim().isEmpty) {
        return '';
      }
    } else if ((credit.isEmpty || credit.trim().isEmpty) &&
        selectedValue != null) {
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
    } else if ((name.isEmpty || name.trim().isEmpty) && selectedValue != null) {
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
      if (selectedValue == null) {
        setState(() {
          selectedValueIsNull = true;
          // print('############# red ###############');
        });
      } else {
        setState(() {
          selectedValueIsNull = false;
          // print('############# white ###############');
        });
      }
    } else {
      setState(() {
        selectedValueIsNull = false;
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
              widget.grade, widget.courseList),
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

  void collectDate() {
    bool save = Provider.of<MyData>(context, listen: false).savaData;
    var name = _controller_Name.text;
    var credit = _controller_Credit.text;
    String? sNum = widget.courseList[0];

    if (valideName &&
        valideCredit &&
        selectedValue != null &&
        save &&
        !pressDelete) {
      List? alreadyExistValue = box.get(id);
      if (alreadyExistValue != null) {
        // list is already exist
        box.put(id, [sNum, name, credit, selectedValue]);
      } else {
        // a  new list
        box.add([sNum, name, credit, selectedValue]);
        var idBox = box.toMap().keys.firstWhere(
            (k) => eq(box.toMap()[k], [sNum, name, credit, selectedValue]),
            orElse: () => null);

        setState(() {
          id = idBox;
        });
      }
      print('################## save :$save ############################');
      print(box.toMap());
    }
  }

  void theStateOfCourse() {
    if (_errorName == null) {
      Provider.of<MyData>(context, listen: false).stateOfName(true);
    } else {
      Provider.of<MyData>(context, listen: false).stateOfName(false);
    }
    if (_errorCredit == null) {
      Provider.of<MyData>(context, listen: false).stateOfCredit(true);
    } else {
      Provider.of<MyData>(context, listen: false).stateOfCredit(false);
    }
    if (selectedValue != null) {
      Provider.of<MyData>(context, listen: false).stateOfGrade(true);
    } else {
      Provider.of<MyData>(context, listen: false).stateOfGrade(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      test();
      errorGrade();
      validationMethod();
      theStateOfCourse;
      // if (!pressDelete) {
      collectDate();
      // }
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(5, 15, 20, 15),
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
                margin: EdgeInsets.only(top: 4, left: 10),
                child: TextField(
                  controller: _controller_Name,
                  textAlign: TextAlign.center,
                  autofocus: false,
                  focusNode: _focusName,
                  style: TextStyle(fontSize: 18, color: Color(0xff004d60)),
                  onChanged: (value) {
                    Provider.of<MyData>(context, listen: false).change(true);
                    setState(() {
                      widget.courseList[1] = value;

                      listOfCoursesInSemester[index][1] = value;
                      errorGrade();
                      selectedValueIsNull;
                      theStateOfCourse();
                      collectDate();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Course',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: valideName ? Colors.white : Color(0xffce2029)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            valideName ? Color(0xff4562a7) : Color(0xffce2029),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: 60,
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
                  listOfCoursesInSemester[index][2] = value;
                  theStateOfCourse();
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
                    color: valideCredit ? Color(0xff4562a7) : Color(0xffce2029),
                  ),
                ),
              ),
            ),
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
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                        bottom: BorderSide(
                            color: selectedValueIsNull
                                ? Color(0xffce2029)
                                : Colors.white,
                            width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      selectedValue == null
                          ? Text(
                              'Grade',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            )
                          : Text(
                              '$selectedValue',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff4562a7),
                              ),
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 35,
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
                                bottom:
                                    BorderSide(color: Colors.white, width: 1),
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
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    Provider.of<MyData>(context, listen: false).change(true);
                    selectedValue = value as String;
                    widget.courseList[3] = selectedValue;
                    listOfCoursesInSemester[index][3] = value;
                    // print('################# courseList ######################');
                    // print(courseList);
                    // print(
                    //     '################# semsestcourses ######################');
                    // print(widget.semestCourse[index]);

                    errorGrade();
                    theStateOfCourse();
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
