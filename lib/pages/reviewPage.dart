import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'HomeWithFireStoreFinal.dart';

final List<String> items = [
  'All',
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
String? selectedValue;

class ReviewPage extends StatefulWidget {
  final List allSemesters;

  ReviewPage(this.allSemesters);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List allCourses = [
    // [
    //  name,
    //  credit,
    //  grade1,
    //  grade2
    // ]
  ];
  void setAllCourses(String grade) {
    setState(() {
      allCourses.clear();
    });
    for (List semester in widget.allSemesters) {
      for (List course in semester) {
        var name = course[1];
        var credit = course[2];
        var selectedValue1 = course[3];
        var selectedValue2 = course[4];
        if (name != null && credit != null && selectedValue1 != null) {
          setState(() {
            if (grade == 'All') {
              allCourses
                  .add([name, credit, selectedValue1, selectedValue2 ?? '']);
            } else {
              if (selectedValue2 == null) {
                if (grade == selectedValue1) {
                  allCourses.add(
                      [name, credit, selectedValue1, selectedValue2 ?? '']);
                }
              } else {
                if (grade == selectedValue2) {
                  allCourses.add(
                      [name, credit, selectedValue1, selectedValue2 ?? '']);
                }
              }
            }
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedValue = 'All';
    });
    setAllCourses(selectedValue!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffb8c8d1),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xffb8c8d1),
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBarReview(setAllCourses),
                SizedBox(
                  height: 20,
                ),
                allCourses.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                          ),
                          Container(
                            alignment: Alignment.center,
                            // height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Color(0xffeaf1ed),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  color: Color(0xff004d60),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 10),

                            // height: 50,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Color(0xffeaf1ed),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
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

                            width: 100,
                            decoration: BoxDecoration(
                                color: Color(0xffeaf1ed),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Text(
                                'Grades',
                                style: TextStyle(
                                  color: Color(0xff004d60),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                allCourses.isNotEmpty
                    ? ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return CourseCard(
                                allCourses[index][0],
                                allCourses[index][1],
                                allCourses[index][2],
                                allCourses[index][3],
                                index);
                          },
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: allCourses.length,
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 150,
                          ),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'No Courses Found',
                                style: TextStyle(
                                    fontSize: 20, color: Color(0xff4562a7)),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String name;
  final String credit;
  final String grade1;
  final String? grade2;
  final int index;

  CourseCard(this.name, this.credit, this.grade1, this.grade2, this.index);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 35,
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            '${index + 1}',
            style: TextStyle(
                fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
          child: Row(
            children: [
              Container(
                width: 170,
                alignment: Alignment.center,
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, color: Color(0xff004d60)),
                  maxLines: 1,
                ),
              ),
              Container(
                width: 50,
                alignment: Alignment.center,
                // decoration: BoxDecoration(
                //     border: Border(bottom: BorderSide(color: Colors.white))),
                child: Text(
                  credit,
                  style: TextStyle(fontSize: 18, color: Color(0xff4562a7)),
                ),
              ),
              Container(
                width: 100,
                alignment: Alignment.center,
                // decoration: BoxDecoration(
                //     border: Border(bottom: BorderSide(color: Colors.white))),
                child: Text(
                  '$grade1   $grade2',
                  style: TextStyle(fontSize: 18, color: Color(0xff4562a7)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AppBarReview extends StatefulWidget {
  final Function callBackSetCourses;

  AppBarReview(this.callBackSetCourses);

  @override
  State<AppBarReview> createState() => _AppBarReviewState();
}

class _AppBarReviewState extends State<AppBarReview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: EdgeInsets.only(top: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 65),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xff4562a7),
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePageFin(),
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  'Find Courses',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff004d60),
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    onMenuStateChange: (value) {},
                    customButton: Container(
                      width: 45,
                      height: 31,
                      margin: EdgeInsets.only(bottom: 10, left: 20),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                            bottom:
                                BorderSide(color: Color(0xff004d60), width: 1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$selectedValue',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff4562a7),
                              fontWeight: FontWeight.bold,
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
                    value: selectedValue,
                    key: ValueKey(selectedValue),
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value as String;
                        widget.callBackSetCourses(selectedValue!);
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
                      offset: const Offset(10, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all(0),
                        thumbVisibility: MaterialStateProperty.all(false),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
