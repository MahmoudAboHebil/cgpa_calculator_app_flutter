import 'package:cgp_calculator/online%20app/collage_courses_data/computer_science.dart';
import 'package:cgp_calculator/online%20app/collage_courses_data/free_choice_courses.dart';
import 'package:cgp_calculator/online%20app/collage_courses_data/natural_sciences_division.dart';
import 'package:cgp_calculator/online%20app/collage_courses_data/statistics.dart';
import 'package:cgp_calculator/online%20app/collage_courses_data/university_requirement_courses.dart';
import 'package:cgp_calculator/online%20app/models/courses_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:searchfield/searchfield.dart';
import 'package:flutter_textfield_autocomplete/flutter_textfield_autocomplete.dart';
import 'package:textfield_search/textfield_search.dart';

import 'home_with_firestore_page.dart';

/// todo: you need to change color of course card when it selected (no needed)
/// todo: you need to add delete button (done)
/// todo: you need to  total gain  credits

List<List<String>> courseDataList = [
  [
    'courseName1',
    'Credit1',
    'Id1',
  ],
  [
    'courseName2',
    'Credit2',
    'Id2',
  ],
  [
    'courseName',
    'Credit3',
    'Id3',
  ],
];
bool isChanged = false;

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  UniversityRequirement universityRequirement = UniversityRequirement();
  FreeChoice freeChoice = FreeChoice();
  String? selectDp;
  String? selectedCourse;
  Widget content() {
    setState(() {
      selectedCourse = (selectDp == null) ? null : _selectController.text;
    });

    Widget? selectedWidget;
    Widget college = CoursesBlock('College-Mandatory    (متطلب كلية)',
        CoursesService.getDivisionList(), _selectFocus, selectedCourse);
    Widget majorMandatory = CoursesBlock('Major-Mandatory    (رئيسى إجبارى)',
        CoursesService.getMajor_Mandatory(), _selectFocus, selectedCourse);
    Widget majorElective = CoursesBlock('Major-Elective    (رئيسى إختيارى)',
        CoursesService.getMajor_Elective(), _selectFocus, selectedCourse);
    Widget minorMandatory = CoursesBlock('Minor-Mandatory    (فرعى إجبارى)',
        CoursesService.getMinor_Mandatory(), _selectFocus, selectedCourse);
    Widget minorElective = CoursesBlock('Minor-Elective    (فرعى إختيارى)',
        CoursesService.getMinor_Elective(), _selectFocus, selectedCourse);
    Widget university = CoursesBlock(
        'University-Courses    (متطلب جامعة)',
        universityRequirement.universityRequirementsCourses,
        _selectFocus,
        selectedCourse);
    Widget freeChoiceCourses = CoursesBlock('FreeChoice-Courses    (إختيار حر)',
        freeChoice.freeChoiceCourses, _selectFocus, selectedCourse);
    if (selectDp == 'College') {
      selectedWidget = college;
    } else if (selectDp == 'Major-Mandatory') {
      selectedWidget = majorMandatory;
    } else if (selectDp == 'Major-Elective') {
      selectedWidget = majorElective;
    } else if (selectDp == 'Minor-Mandatory') {
      selectedWidget = minorMandatory;
    } else if (selectDp == 'Minor-Elective') {
      selectedWidget = minorElective;
    } else if (selectDp == 'University') {
      selectedWidget = university;
    } else if (selectDp == 'FreeChoice') {
      selectedWidget = freeChoiceCourses;
    }

    return selectDp == null
        ? Column(
            children: [
              college,
              majorMandatory,
              majorElective,
              minorMandatory,
              minorElective,
              university,
              freeChoiceCourses
            ],
          )
        : Column(
            children: [
              selectedWidget ?? SizedBox(),
            ],
          );
  }

  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();
  TextEditingController _selectController = TextEditingController();
  final _selectFocus = FocusNode();
  @override
  void dispose() {
    super.dispose();
    _selectFocus.dispose();
    _selectController.dispose();
    suggestionBoxController.close();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeWithFireStorePage(),
            ));

        return false;
      },
      child: Container(
        color: Color(0xffb8c8d1),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeWithFireStorePage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, top: 5),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
                elevation: 0,
              ),
              backgroundColor: Color(0xffb8c8d1),
              body: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            selectDp = null;
                            selectedCourse = null;
                            _selectController.text = '';
                            isChanged = true;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.delete_outline,
                            color: Color(0xffce2029),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: _selectController,
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.bottom,
                              focusNode: _selectFocus,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff004d60),
                                  overflow: TextOverflow.ellipsis),
                              onChanged: (value) {
                                setState(() {
                                  isChanged = true;
                                  if (value != 'There are no courses left') {
                                    selectDp = CoursesService
                                        .getCourseNickNameDpByName(
                                            _selectController.text);
                                  } else {
                                    selectDp = null;
                                  }
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
                            suggestionsCallback: (pattern) async {
                              return CoursesService.getSuggestionsCoursePage(
                                  pattern);
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
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 20),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(suggestion,
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.grey.shade700,
                                            )),
                                      ),
                                    );
                            },
                            suggestionsBoxController: suggestionBoxController,
                            hideOnEmpty: false,
                            noItemsFoundBuilder: (context) => Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text('No Items Found!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade700,
                                    )),
                              ),
                            ),

                            onSuggestionSelected: (String suggestion) {
                              setState(() {
                                isChanged = true;

                                if (suggestion != 'There are no courses left') {
                                  _selectController.text = suggestion;
                                  selectDp =
                                      CoursesService.getCourseNickNameDpByName(
                                          suggestion);
                                } else {
                                  selectDp = null;
                                }
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
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [content()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CoursesBlock extends StatefulWidget {
  String title;
  List list;
  String? selectedCourse;
  FocusNode focusNode;

  CoursesBlock(this.title, this.list, this.focusNode, this.selectedCourse);

  @override
  State<CoursesBlock> createState() => _CoursesBlockState();
}

class _CoursesBlockState extends State<CoursesBlock> {
  List listOfCourses = [
    // ['name', 'id', '3', 'A', null, true]
  ];
  void setData() {
    // substring(0, s.indexOf('.')

    setState(() {
      listOfCourses = [];
    });
    String? replace;
    if (widget.title == 'University-Courses    (متطلب جامعة)') {
      replace = ' متطلب جامعة _ ';
    } else if (widget.title == 'FreeChoice-Courses    (إختيار حر)') {
      replace = ' إختيار حر _ ';
    }

    for (List course1 in widget.list) {
      if (widget.selectedCourse != null) {
        if (course1[4] == widget.selectedCourse) {
          List grade1 = [];
          List grade2 = [];
          String nameDetail = course1[0];
          String name;
          if (replace != null) {
            name = nameDetail.replaceAll(replace, '');
          } else {
            name = nameDetail.substring(0, nameDetail.indexOf('_'));
          }

          String credit = course1[1];
          String? id = course1[2];
          List? reqs = course1[3];

          for (List semester in allSemesters) {
            for (List course2 in semester) {
              if (course2[1] != null) {
                String name2;
                if (replace != null) {
                  name2 = course2[1].replaceAll(replace, '');
                } else {
                  name2 = course2[1].substring(0, course2[1].indexOf('_'));
                }
                if (name2 == name) {
                  grade1.add(course2[3]);
                  grade2.add(course2[4]);
                }
              }
            }
          }
          if (grade1.isNotEmpty) {
            String? grade =
                grade2[grade2.length - 1] ?? grade1[grade1.length - 1];
            setState(() {
              listOfCourses.add([
                name,
                id,
                credit,
                grade1[grade1.length - 1],
                grade2[grade2.length - 1],
                (grade == null ||
                        grade == 'F' ||
                        grade == 'Non' ||
                        grade == 'W' ||
                        grade == 'U')
                    ? false
                    : true,
                reqs
              ]);
            });
          } else {
            setState(() {
              listOfCourses.add([name, id, credit, null, null, false, reqs]);
            });
          }
        }
      } else {
        List grade1 = [];
        List grade2 = [];
        String nameDetail = course1[0];
        String name;
        if (replace != null) {
          name = nameDetail.replaceAll(replace, '');
        } else {
          name = nameDetail.substring(0, nameDetail.indexOf('_'));
        }

        String credit = course1[1];
        String? id = course1[2];
        List? reqs = course1[3];

        for (List semester in allSemesters) {
          for (List course2 in semester) {
            if (course2[1] != null) {
              String name2;
              if (replace != null) {
                name2 = course2[1].replaceAll(replace, '');
              } else {
                name2 = course2[1].substring(0, course2[1].indexOf('_'));
              }
              if (name2 == name) {
                grade1.add(course2[3]);
                grade2.add(course2[4]);
              }
            }
          }
        }
        if (grade1.isNotEmpty) {
          String? grade =
              grade2[grade2.length - 1] ?? grade1[grade1.length - 1];
          setState(() {
            listOfCourses.add([
              name,
              id,
              credit,
              grade1[grade1.length - 1],
              grade2[grade2.length - 1],
              (grade == null ||
                      grade == 'F' ||
                      grade == 'Non' ||
                      grade == 'W' ||
                      grade == 'U')
                  ? false
                  : true,
              reqs
            ]);
          });
        } else {
          setState(() {
            listOfCourses.add([name, id, credit, null, null, false, reqs]);
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  Future<dynamic> message(
      String courseName, String id, List openCourses, List requirementCourses) {
    List mandotery = requirementCourses[0];
    List option = requirementCourses[1];

    bool isForth = mandotery.contains('Four');
    bool isM = mandotery.contains('m');

    Widget mandoteryWidget() {
      return Container(
        height: 165,
        width: 500,
        child: isForth
            ? Column(
                children: [
                  Text('Forth Level ',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.redAccent,
                      )),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 5),
                  //   child: Divider(
                  //     height: 1,
                  //     thickness: 1,
                  //     color: Colors.black,
                  //   ),
                  // )
                ],
              )
            : ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CoursesService.getDepartmentCourseNameById(
                                    mandotery[index])
                                .isNotEmpty
                            ? Text(
                                '${CoursesService.getDepartmentCourseNameById(mandotery[index])}',
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.redAccent,
                                ))
                            : SizedBox(),
                        (mandotery[index] != 'm' && mandotery[index] != 'Four')
                            ? Text('${mandotery[index]}',
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.redAccent,
                                ))
                            : SizedBox(),
                        (isM && index == 0)
                            ? Text(' و',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff004d60),
                                ))
                            : SizedBox(),
                        (requirementCourses.length == index + 1)
                            ? Text('مصاحب',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff004d60),
                                ))
                            : SizedBox(),
                        // (!isForth && !isM) &&
                        //         requirementCourses.length < index + 1
                        //     ? Padding(
                        //         padding: EdgeInsets.symmetric(vertical: 5),
                        //         child: Divider(
                        //           height: 1,
                        //           thickness: 1,
                        //           color: Colors.black,
                        //         ),
                        //       )
                        //     : SizedBox(),
                      ],
                    ),
                itemCount: mandotery.length),
      );
    }

    Widget optionWidget() {
      return Container(
        height: 165,
        width: 500,
        child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${CoursesService.getDepartmentCourseNameById(option[index])}',
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.redAccent,
                        )),
                    Text('${option[index]}',
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.redAccent,
                        )),
                    (index + 1 < option.length)
                        ? Text('أو',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff004d60),
                            ))
                        : SizedBox(),
                    // option.length > index + 1
                    //     ? Padding(
                    //         padding: EdgeInsets.symmetric(vertical: 5),
                    //         child: Divider(
                    //           height: 1,
                    //           thickness: 1,
                    //           color: Colors.black,
                    //         ),
                    //       )
                    //     : SizedBox(),
                  ],
                ),
            itemCount: option.length),
      );
    }

    Widget openWidget() {
      return Column(
        children: [
          Row(
            children: [
              Text(
                "This course will open:  ",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff004d60),
                ),
              ),
              Text(
                "${openCourses.length}",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 165,
            width: 500,
            child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${openCourses[index][1]} ',
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            )),
                        Text(openCourses[index][0],
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            )),
                        openCourses.length > index + 1
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Colors.black,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                itemCount: openCourses.length),
          )
        ],
      );
    }

    Widget requirtsWidget() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "To open, you need to finish: ",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xff004d60),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (mandotery.isEmpty && option.isEmpty)
              ? Text(
                  "No requirements",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff004d60),
                  ),
                )
              : SizedBox(),
          (option.isEmpty || mandotery.isNotEmpty)
              ? mandoteryWidget()
              : SizedBox(),
          option.isNotEmpty ? optionWidget() : SizedBox(),
        ],
      );
    }

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Color(0xffb8c8d1),
              content: Container(
                height: 525,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(courseName,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xff4562a7))),
                          Text(id,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xff4562a7))),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      requirtsWidget(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Divider(
                          height: 3,
                          thickness: 3,
                          color: Color(0xff4562a7),
                        ),
                      ),
                      openWidget(),
                    ],
                  ),
                ),
              ),
              // alignment: Alignment.center,
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (isChanged) {
      setData();
      setState(() {
        isChanged = false;
      });
    }
    return widget.list.isNotEmpty
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                HeadTitle(widget.title),
                ListView.builder(
                  itemBuilder: (context, index) {
                    return TextButton(
                      style: ButtonStyle(
                          padding: MaterialStatePropertyAll(EdgeInsets.zero),
                          textStyle: MaterialStatePropertyAll(
                              TextStyle(fontWeight: FontWeight.normal))),
                      onPressed: () {
                        String? id = listOfCourses[index][1];
                        FocusManager.instance.primaryFocus?.unfocus();

                        if (id != null && !widget.focusNode.hasFocus) {
                          // print(CoursesService.getOpenCoursesId(id));
                          message(
                              listOfCourses[index][0],
                              id,
                              CoursesService.getOpenCoursesId(id),
                              listOfCourses[index][6]);
                        }
                      },
                      child: CourseCard(
                          listOfCourses[index][0],
                          listOfCourses[index][2],
                          listOfCourses[index][3],
                          listOfCourses[index][4],
                          listOfCourses[index][5]),
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: listOfCourses.length,
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          )
        : SizedBox();
  }
}

class HeadTitle extends StatelessWidget {
  final String title;
  HeadTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 100,
        decoration: BoxDecoration(
            color: Color(0xffeaf1ed),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: Colors.white, width: 2)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Color(0xff004d60),
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15),
                  width: 200,
                  child: Text(
                    'Name',
                    style: TextStyle(
                      color: Color(0xff004d60),
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Credit',
                  style: TextStyle(
                    color: Color(0xff004d60),
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '1st',
                  style: TextStyle(
                    color: Color(0xff004d60),
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  '2nd',
                  style: TextStyle(
                    color: Color(0xff004d60),
                    fontSize: 18,
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class CourseCard extends StatefulWidget {
  final String name;
  final String credit;
  final String? grade1;
  final String? grade2;
  final bool check;

  CourseCard(this.name, this.credit, this.grade1, this.grade2, this.check);
  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  String grade1 = '';
  String grade2 = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      grade1 = widget.grade1 ?? '-';
      grade2 = widget.grade2 ?? '-  ';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                widget.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18, color: Color(0xff004d60)),
                maxLines: 1,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 50,
                alignment: Alignment.center,
                // decoration: BoxDecoration(
                //     border: Border(bottom: BorderSide(color: Colors.white))),
                child: Text(
                  widget.credit,
                  style: TextStyle(fontSize: 18, color: Color(0xff4562a7)),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: 60,
                // alignment: Alignment.center,
                // decoration: BoxDecoration(
                //     border: Border(bottom: BorderSide(color: Colors.white))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$grade1',
                      style: TextStyle(fontSize: 18, color: Color(0xff4562a7)),
                    ),
                    Text(
                      '$grade2',
                      style: TextStyle(fontSize: 18, color: Color(0xff4562a7)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              widget.check
                  ? Icon(
                      Icons.check_box_rounded,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class NavigationExample extends StatelessWidget {
  final TextEditingController _typeAheadController = TextEditingController();
  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          // suggestionBoxController.close();
        },
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _typeAheadController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Enter Course',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Colors.transparent)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Colors.transparent)),
                ),
              ),
              suggestionsCallback: (pattern) async {
                return CitiesService.getSuggestions(pattern);
              },
              itemBuilder: (context, String suggestion) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                this._typeAheadController.text = suggestion;
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
            ),
          ],
        ),
      ),
    );
  }
}

class FormExample extends StatefulWidget {
  @override
  _FormExampleState createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  String? _selectedCity;

  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // close the suggestions box when the user taps outside of it
      onTap: () {
        suggestionBoxController.close();
      },
      child: Container(
        // Add zero opacity to make the gesture detector work
        color: Colors.amber.withOpacity(0),
        // Create the form for the user to enter their favorite city
        child: Form(
          key: this._formKey,
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                Text('What is your favorite city?'),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(labelText: 'City'),
                    controller: this._typeAheadController,
                  ),
                  suggestionsCallback: (pattern) {
                    return CitiesService.getSuggestions(pattern);
                  },
                  itemBuilder: (context, String suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  itemSeparatorBuilder: (context, index) {
                    return Divider();
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (String suggestion) {
                    this._typeAheadController.text = suggestion;
                  },
                  suggestionsBoxController: suggestionBoxController,
                  validator: (value) =>
                      value!.isEmpty ? 'Please select a city' : null,
                  onSaved: (value) => this._selectedCity = value,
                ),
                Spacer(),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (this._formKey.currentState!.validate()) {
                      this._formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Your Favorite City is ${this._selectedCity}'),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CitiesService {
  static final List<String> cities = [
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

  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(cities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

class SearchFieldSample extends StatefulWidget {
  const SearchFieldSample({Key? key}) : super(key: key);

  @override
  State<SearchFieldSample> createState() => _SearchFieldSampleState();
}

class _SearchFieldSampleState extends State<SearchFieldSample> {
  int suggestionsCount = 12;
  final focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    final suggestions = List.generate(
        suggestionsCount, (index) => 'suggestionsuggestionsuggestion $index');
    return Center(
      child: SizedBox(
        width: 150,
        child: SearchField(
          searchStyle: TextStyle(color: Color(0xff004d60)),
          suggestionItemDecoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white))),
          scrollbarAlwaysVisible: false,
          onSearchTextChanged: (query) {
            final filter = suggestions
                .where((element) =>
                    element.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return filter
                .map((e) => SearchFieldListItem<String>(e,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0),
                      child: TextFieldReadOnly(e, 150),
                    )))
                .toList();
          },
          key: const Key('searchfield'),
          itemHeight: 50,
          searchInputDecoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            hintText: 'Enter Course',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 0, color: Colors.transparent)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 0, color: Colors.transparent)),
          ),
          suggestionsDecoration: SuggestionDecoration(
            padding: const EdgeInsets.all(0),
            color: Color(0xffb8c8d1),
          ),
          suggestions: suggestions
              .map((e) => SearchFieldListItem<String>(e,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: TextFieldReadOnly(e, 150),
                  )))
              .toList(),
          focusNode: focus,
          suggestionState: Suggestion.expand,
          onSuggestionTap: (SearchFieldListItem<String> x) {
            focus.unfocus();
          },
        ),
      ),
    );
  }
}

class search extends StatefulWidget {
  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  final _controller_Name = TextEditingController();
  final scrollController = ScrollController();
  GlobalKey<TextFieldAutoCompleteState<String>> _textFieldAutoCompleteKey =
      GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: TextFieldAutoComplete(
        suggestions: list,
        key: _textFieldAutoCompleteKey,
        clearOnSubmit: false,
        decoration: InputDecoration(contentPadding: EdgeInsets.only(right: 10)),
        controller: _controller_Name,
        textChanged: (value) {
          print('###############################################');
          print(value);
        },
        itemSubmitted: (String item) {
          _controller_Name.text = item;
          print('###############################################');
          print('selected breed $item');
        },
        itemSorter: (String a, String b) {
          return a.compareTo(b);
        },
        itemFilter: (String item, query) {
          return item.toLowerCase().startsWith(query.toLowerCase());
        },
        itemBuilder: (context, String item) {
          return Container(
            padding: EdgeInsets.all(20),
            color: Colors.grey,
            child: Row(
              children: [
                Text(
                  item,
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

List<String> list = [
  'courseName1courseName1',
  'courseName2',
  'courseName3',
  'courseName1',
  'courseName2',
  'courseName5',
  'courseName6',
  'courseName7',
  'courseName9',
];

class CourseData extends StatelessWidget {
  CourseData(this.courseName, this.credit, this.id);
  final String courseName;
  final String credit;
  final String id;
  late final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextFieldReadOnly(courseName, 150),

          // TextFieldReadOnly(credit, 60),
          // TextFieldReadOnly(id, 100),
        ],
      ),
    );
  }
}

class TextFieldReadOnly extends StatelessWidget {
  TextFieldReadOnly(this.title, this.width);
  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: width,
      child: TextField(
        controller: TextEditingController(text: title),
        textAlign: TextAlign.center,
        readOnly: true,
        style: TextStyle(
          fontSize: 18,
          color: Color(0xff004d60),
        ),
        onChanged: (value) {},
        maxLines: 1,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent)),
        ),
      ),
    );
  }
}
