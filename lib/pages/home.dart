import 'package:collection/collection.dart';
import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:cgp_calculator/providerBrain.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ToDo: the data entry removed when click the deleteCourse button
// ToDo: there is a problem sometimes when clicking the addCourse button
// ToDo: there is a problem when scrolling
// ToDo: the validation desgin need to fix
// ToDo: name disappear when get long

var box = Hive.box('courses1');
GlobalKey<AnimatedListState> _keyOfCourse = GlobalKey();

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
    return Container(
      color: Color(0xffb8c8d1),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xffb8c8d1),
          body: ListView(
            shrinkWrap: true,
            children: [
              AppBarHome(),
              Semester(1),
              Provider.of<MyData>(context).isChanged
                  ? Container(
                      width: 200,
                      height: 100,
                      child: GestureDetector(
                        onTap: () {
                          bool validName =
                              Provider.of<MyData>(context, listen: false)
                                  .validName;
                          bool validCredit =
                              Provider.of<MyData>(context, listen: false)
                                  .validCredit;
                          bool validGrade =
                              Provider.of<MyData>(context, listen: false)
                                  .validGrade;
                          print('validName : $validName');
                          print('validCredit : $validCredit');
                          print('validGrade : $validGrade');
                          if (validName && validGrade && validCredit) {
                            Provider.of<MyData>(context, listen: false)
                                .change(false);
                            Provider.of<MyData>(context, listen: false)
                                .changeSaveData(true);
                            Future.delayed(Duration(milliseconds: 500), () {
                              Provider.of<MyData>(context, listen: false)
                                  .changeSaveData(false);
                            });
                          } else {}
                        },
                        child: Center(
                          child: Text(
                            'Changed',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
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
  List listOfCoursesInSemester = [];
  late String semestNumString;

  bool val = true;
  void getData() async {
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

  void addCourse() {
    setState(() {
      listOfCoursesInSemester.add([semestNumString, null, null, null]);
    });
    int insertIndex = listOfCoursesInSemester.isEmpty
        ? listOfCoursesInSemester.length
        : listOfCoursesInSemester.length - 1;
    print('################# insertIndex: $insertIndex ######################');
    _keyOfCourse.currentState!.insertItem(insertIndex);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      semestNumString = widget.semesterNum.toString();
    });
    getData();
    print('################### map #####################');
    print(box.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
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
                  listOfCoursesInSemester[index], () {
                setState(() {
                  listOfCoursesInSemester;
                });
              }, listOfCoursesInSemester);
            },
            initialItemCount: listOfCoursesInSemester.length,
            shrinkWrap: true,
            key: _keyOfCourse,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  addCourse();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xffeaf1ed),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.white, width: 2)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
            ],
          ),
        ],
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
  Function function;
  List semestCourse;
  Course(this.semestNum, this.name, this.credite, this.grade, this.courseList,
      this.function, this.semestCourse);

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  late TextEditingController _controller_Name;
  late TextEditingController _controller_Credit;
  late String? selectedValue;
  bool selectedValueIsNull = false;
  int index = 0;
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
  @override
  void initState() {
    super.initState();
    setState(() {
      index = widget.semestCourse.indexOf(widget.courseList);
    });

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
    selectedValue = widget.grade;
  }

  String? get _errorCredit {
    var name = _controller_Name.text;
    var credit = _controller_Credit.text;
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
    var name = _controller_Name.text;
    var credit = _controller_Credit.text;
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
    var name = _controller_Name.text;
    var credit = _controller_Credit.text;
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

  void deleteCourse() {
    setState(() {
      // List deletedCourse = [
      //   widget.semestCourse,
      //   widget.name,
      //   widget.credite,
      //   widget.grade
      // ];
      int index = widget.semestCourse.indexOf(widget.courseList);
      List deletedCourse = widget.semestCourse.removeAt(index);
      print('################## deleted course###############################');
      print(deletedCourse);
      _keyOfCourse.currentState!.removeItem(index, (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          key: ValueKey(
            widget.name,
          ),
          child: Course(widget.semestNum, widget.name, widget.credite,
              widget.grade, widget.courseList, () {
            setState(() {
              widget.semestCourse;
            });
          }, widget.semestCourse),
        );
      }, duration: Duration(milliseconds: 450));
      Function eq = const ListEquality().equals;
      var id = box.toMap().keys.firstWhere(
          (k) => eq(box.toMap()[k], deletedCourse),
          orElse: () => null);
      if (id != null) {
        print('################# id delete: $id ############################');
        box.delete(id);
      }
      widget.function();
    });
  }

  void collectDate() {
    Function eq = const ListEquality().equals;
    bool save = Provider.of<MyData>(context, listen: false).savaData;
    var name = _controller_Name.text;
    var credit = _controller_Credit.text;
    String? sNum = widget.courseList[0];
    if (_errorName == null &&
        _errorCredit == null &&
        selectedValue != null &&
        save) {
      if (!eq([
        sNum,
        name,
        credit,
        selectedValue
      ], [
        sNum,
        widget.courseList[1],
        widget.courseList[2],
        widget.courseList[3]
      ])) {
        var id = box.toMap().keys.firstWhere(
            (k) => eq(box.toMap()[k], widget.courseList),
            orElse: () => null);
        if (id == null) {
          box.add([sNum, name, credit, selectedValue]);
        } else {
          box.put(id, [sNum, name, credit, selectedValue]);
        }
      }

      var id = box.toMap().keys.firstWhere(
          (k) => eq(box.toMap()[k], widget.courseList),
          orElse: () => null);
      print('################## collect id: $id##########################');
      if (id == null) {
        box.add([sNum, name, credit, selectedValue]);
      } else {}
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
      errorGrade();
      theStateOfCourse;
      collectDate();
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
                  style: TextStyle(fontSize: 18, color: Color(0xff004d60)),
                  onChanged: (value) {
                    Provider.of<MyData>(context, listen: false).change(true);
                    setState(() {
                      widget.courseList[1] = _controller_Name.text;

                      widget.semestCourse[index] = widget.courseList;
                      errorGrade();
                      selectedValueIsNull;
                      theStateOfCourse();
                      collectDate();
                    });
                  },
                  decoration: InputDecoration(
                    errorText: _errorName,
                    hintText: 'Enter Course',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff4562a7),
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
              keyboardType: TextInputType.number,
              onChanged: (value) {
                Provider.of<MyData>(context, listen: false).change(true);
                setState(() {
                  widget.courseList[2] = _controller_Credit.text;
                  widget.semestCourse[index] = widget.courseList;
                  theStateOfCourse();
                  collectDate();
                });
              },
              style: TextStyle(
                fontSize: 18,
                color: Color(0xff4562a7),
              ),
              decoration: InputDecoration(
                errorText: _errorCredit,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                hintText: 'Credit',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff4562a7),
                  ),
                ),
              ),
            ),
          ),
          DropdownButtonHideUnderline(
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
                            style: TextStyle(color: Colors.grey, fontSize: 18),
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
                              bottom: BorderSide(color: Colors.white, width: 1),
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
                  widget.semestCourse[index] = widget.courseList;
                  // print('################# courseList ######################');
                  // print(courseList);
                  // print(
                  //     '################# semsestcourses ######################');
                  // print(widget.semestCourse[index]);

                  errorGrade();
                  theStateOfCourse();
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
