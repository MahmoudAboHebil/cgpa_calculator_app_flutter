import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'home_with_firestore_page.dart';
// TODO: the  UI done
// TODO: you need to add to DB(done)

class HomeWithSemesterPage extends StatefulWidget {
  final Function callBack;
  HomeWithSemesterPage(this.callBack);

  @override
  State<HomeWithSemesterPage> createState() => _HomeWithSemesterPageState();
}

List<List> allSemesters2 = [];

Tween<Offset> _offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));

void updateData(CollectionReference? ref, double? SGPA, int? Credits,
    String semesterId, int semesterIndex) async {
  await ref!.doc(semesterId).set({
    'semesterId': semesterId,
    'semesterIndex': semesterIndex,
    'SGPA': SGPA,
    'Credits': Credits,
  });
}

class _HomeWithSemesterPageState extends State<HomeWithSemesterPage> {
  GlobalKey<AnimatedListState> _keySemester = GlobalKey<AnimatedListState>();

  bool isChanged = false;
  double cgpa = 0.0;
  int totCredits = 0;

  isValueChanged() {
    setState(() {
      isChanged = true;
    });
  }

  updataCGPA() {
    setState(() {
      calcCGPA();
      cgpa;
      totCredits;
    });
  }

  void addSemester() {
    var uuid = Uuid();
    var uniqueId = uuid.v1();

    setState(() {
      allSemesters2.add([null, null, uniqueId, maxSemester + 1]);
    });
    int insertIndex =
        allSemesters2.isEmpty ? allSemesters2.length : allSemesters2.length - 1;
    addSemestInDB(null, null, uniqueId, maxSemester + 1);
    _keySemester.currentState!
        .insertItem(insertIndex, duration: Duration(milliseconds: 300));
  }

  void calcCGPA() {
    double totalPoints = 0;
    int totalCredits = 0;
    for (List semest in allSemesters2) {
      if (semest[0] != null && semest[1] != null) {
        double semestPoints = semest[0] * semest[1];
        setState(() {
          totalPoints = totalPoints + semestPoints;
          totalCredits = (totalCredits + semest[1]) as int;
        });
      }
    }

    if (totalPoints != 0 && totalCredits != 0) {
      setState(() {
        totCredits = totalCredits;
        cgpa = totalPoints / totalCredits;
      });
    } else {
      setState(() {
        totCredits = 0;
        cgpa = 0;
      });
    }
    setState(() {
      if (cgpa > 4.0) {
        cgpa = 4.0;
      }
    });
    widget.callBack(cgpa, totCredits);
  }

  List isValidate() {
    List list = [true];
    for (List course in allSemesters2) {
      if (course[0] == null && course[1] == null) {
      } else {
        if (course[0] == null || course[1] == null) {
          setState(() {
            list.add(false);
          });
        }
        if (course[0] == -1 || course[1] == -1) {
          setState(() {
            list.add(-1);
          });
        }
      }
    }

    return list;
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> message(
      bool isThereEmptyField, bool isThereError) {
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
                      isThereEmptyField
                          ? Text(
                              'there is an empty field',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : SizedBox(),
                      isThereError
                          ? Text(
                              'Input Error',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : SizedBox(),
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int maxSemester = 0;
  bool flag = true;
  List getSemesterCourses(int ID, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
    List semest = [];
    // List<List> allSemesters = [
    //   [2.35, 11, '1'],
    //   [null, null, 'o4'],
    //   [2.35, 11, '5'],
    // ];

    for (int i = 0; i < streamSnapshot.data!.docs.length; i++) {
      final DocumentSnapshot course = streamSnapshot.data!.docs[i];
      if (course['semesterIndex'] == ID && course.id != 'init') {
        semest = [
          course['SGPA'],
          course['Credits'],
          course['semesterId'],
          course['semesterIndex'],
        ];
      }
    }

    return semest;
  }

  void addSemestInDB(
      double? SGPA, int? Credits, String semesterId, int semesterIndex) async {
    await FirebaseFirestore.instance
        .collection('UsersSemesters')
        .doc('${loggedInUser!.email}')
        .collection('Semesters')
        .doc(semesterId)
        .set({
      'semesterId': semesterId,
      'semesterIndex': semesterIndex,
      'SGPA': SGPA,
      'Credits': Credits,
    });
  }

  Widget Content() {
    if (semestersRef != null) {
      return StreamBuilder(
        stream: semestersRef!.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            List<int> keys = [];
            for (int i = 0; i < streamSnapshot.data!.docs.length; i++) {
              final DocumentSnapshot course = streamSnapshot.data!.docs[i];
              keys.add(course['semesterIndex']);
            }

            maxSemester = keys.max;
            keys = keys.toSet().toList();
            keys.sort();
            keys.remove(-1);

            if (flag) {
              for (int i = 0; i < keys.length; i++) {
                if (allSemesters2.length < keys.length) {
                  allSemesters2
                      .add(getSemesterCourses(keys[i], streamSnapshot));
                }
              }
              if (allSemesters2.isEmpty) {
                allSemesters2 = [
                  [
                    null,
                    null,
                    'firstSemest',
                    1,
                  ]
                ];
                addSemestInDB(null, null, 'firstSemest', 1);
              }
              Future.delayed(Duration.zero, () {
                calcCGPA();
              });
              flag = false;
            }
            return AnimatedList(
              shrinkWrap: true,
              key: _keySemester,
              physics: ScrollPhysics(),
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  // key: ObjectKey(allSemesters[index][0].toString()),

                  sizeFactor: animation,
                  key: ObjectKey(allSemesters2[index][2]),
                  child: SemesterWithSGPA(
                      index,
                      allSemesters2[index][3],
                      allSemesters2[index][0],
                      allSemesters2[index][1],
                      allSemesters2[index][2],
                      isValueChanged,
                      updataCGPA,
                      _keySemester),
                );
              },
              initialItemCount: allSemesters2.length,
            );
          } else {
            return Container();
          }
        },
      );
    } else {
      return Container();
    }
  }

  void collectDate() {
    for (List semest in allSemesters2) {
      updateData(semestersRef, semest[0], semest[1], semest[2], semest[3]);
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      isChanged;
    });
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    alignment: Alignment.center,
                    // height: 50,
                    width: 145,
                    decoration: BoxDecoration(
                        color: Color(0xffeaf1ed),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Colors.white, width: 2)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Text(
                        'SGPA',
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
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Colors.white, width: 2)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Text(
                        'Credits',
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

                    width: 120,
                    decoration: BoxDecoration(
                        color: Color(0xffeaf1ed),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Colors.white, width: 2)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Text(
                        'Semester',
                        style: TextStyle(
                          color: Color(0xff004d60),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Content(),
              Row(
                mainAxisAlignment: isChanged
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      // FocusManager.instance.primaryFocus?.unfocus();
                      addSemester();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: isChanged
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
                          'Add semester',
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
                            bool isThereEmptyField =
                                isValidate().contains(false);
                            bool isThereError = isValidate().contains(-1);

                            if (!isThereError && !isThereEmptyField) {
                              setState(() {
                                calcCGPA();
                                isChanged = false;
                              });
                              collectDate();
                            } else {
                              message(isThereEmptyField, isThereError);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: isChanged
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
                              isChanged = true;
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
      ),
    );
  }
}

class SemesterWithSGPA extends StatefulWidget {
  final int index;
  final int indexDB;
  final double? SGPA;
  final int? credits;
  final String semesterId;
  final Function callBackchanged;
  final Function callBackUpdateCGPA;
  GlobalKey<AnimatedListState> _SemestersKey;

  SemesterWithSGPA(
      this.index,
      this.indexDB,
      this.SGPA,
      this.credits,
      this.semesterId,
      this.callBackchanged,
      this.callBackUpdateCGPA,
      this._SemestersKey,
      {Key? key})
      : super(key: key);

  @override
  State<SemesterWithSGPA> createState() => _SemesterWithSGPAState();
}

class _SemesterWithSGPAState extends State<SemesterWithSGPA> {
  final TextEditingController _controller_SGPA = TextEditingController();
  final TextEditingController _controller_Credits = TextEditingController();

  bool isCreditsValide = true;
  bool isSGPAValide = true;
  FocusNode _focusSGPA = FocusNode();
  FocusNode _focusCredits = FocusNode();

  @override
  void initState() {
    _focusSGPA.addListener(_onFocusSGPAChange);
    _focusCredits.addListener(_onFocusCreditsChange);
    if (widget.SGPA != null) {
      _controller_SGPA.text = widget.SGPA.toString();
    }
    if (widget.credits != null) {
      _controller_Credits.text = widget.credits.toString();
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller_SGPA.dispose();
    _controller_Credits.dispose();
    _focusSGPA.removeListener(_onFocusSGPAChange);
    _focusSGPA.dispose();
    _focusCredits.removeListener(_onFocusCreditsChange);
    _focusCredits.dispose();
  }

  void _onFocusSGPAChange() {
    setState(() {});
  }

  void _onFocusCreditsChange() {
    setState(() {});
  }

  String? get _errorSGPA {
    var SGPA = _controller_SGPA.text;
    var credits = _controller_Credits.text;

    if ((credits.isNotEmpty && credits.trim().isNotEmpty)) {
      if (SGPA.isEmpty || SGPA.trim().isEmpty) {
        return '';
      }
      try {
        double va = double.parse(SGPA);
        if (va == -1) {
          return '';
        }
      } catch (error) {
        return '';
      }
    }
    return null;
  }

  String? get _errorCredits {
    var SGPA = _controller_SGPA.text;
    var credits = _controller_Credits.text;

    if ((SGPA.isNotEmpty && SGPA.trim().isNotEmpty)) {
      if (credits.isEmpty || credits.trim().isEmpty) {
        return '';
      }
      try {
        int va = int.parse(credits);
        if (va == -1) {
          return '';
        }
      } catch (error) {
        return '';
      }
    }
    return null;
  }

  void validationMethod() {
    if (_errorSGPA != null) {
      setState(() {
        isSGPAValide = false;
      });
    } else {
      setState(() {
        isSGPAValide = true;
      });
    }

    if (_errorCredits != null) {
      setState(() {
        isCreditsValide = false;
      });
    } else {
      setState(() {
        isCreditsValide = true;
      });
    }
  }

  void deleteSemesterFromDB(String semesterId) async {
    await semestersRef!.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final DocumentSnapshot course = doc;
        if (course['semesterId'] == semesterId) {
          String id = course.id;
          semestersRef!.doc(id).delete();
        }
      });
    });
  }

  void deleteSemester() {
    if (allSemesters2.length != 1) {
      setState(() {
        allSemesters2.removeAt(widget.index);
        widget._SemestersKey.currentState!.removeItem(widget.index,
            (context, animation) {
          return SizeTransition(
              sizeFactor: animation,
              child: SemesterWithSGPA(
                  widget.index,
                  widget.indexDB,
                  widget.SGPA,
                  widget.credits,
                  widget.semesterId,
                  () {},
                  () {},
                  widget._SemestersKey));
        }, duration: Duration(milliseconds: 300));
      });
      deleteSemesterFromDB(widget.semesterId);
    } else {
      _controller_Credits.text = '';
      _controller_SGPA.text = '';
      allSemesters2[widget.index] = [
        null,
        null,
        widget.semesterId,
        widget.indexDB,
      ];

      updateData(semestersRef, null, null, widget.semesterId, widget.indexDB);
    }
    widget.callBackUpdateCGPA();
  }

  @override
  Widget build(BuildContext context) {
    // _errorCredits!;
    // _errorSGPA!;
    validationMethod();
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 15, 20, 15),
      child: Container(
        height: 31,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      Future.delayed(Duration(milliseconds: 100), () {
                        deleteSemester();
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
                  // padding: EdgeInsets.,
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: _focusSGPA.hasFocus
                        ? BorderSide(
                            color: isSGPAValide
                                ? Color(0xff4562a7)
                                : Color(0xffce2029),
                          )
                        : BorderSide(
                            color: isSGPAValide
                                ? Colors.white
                                : Color(0xffce2029)),
                  )),
                  // padding: EdgeInsets.only(bottom: 4),
                  child: TextFormField(
                    controller: _controller_SGPA,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.bottom,
                    // focusNode: _focusSGPA,
                    // autofocus: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                    ],
                    onChanged: (val) {
                      setState(() {
                        if (val.isNotEmpty) {
                          double? va;
                          try {
                            va = double.parse(val);
                          } catch (error) {
                            va = -1;
                          }
                          allSemesters2[widget.index][0] = va;
                        } else {
                          allSemesters2[widget.index][0] = null;
                        }
                        widget.callBackchanged();
                        validationMethod();
                      });
                    },
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff004d60),
                    ),
                    maxLines: 1,
                    decoration: InputDecoration(
                      // errorText: _errorSGPA,
                      isDense: true,
                      contentPadding: EdgeInsets.only(bottom: 3),
                      hintText: 'Enter SGPA',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.transparent)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.transparent)),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 70,
              // height: 34,
              height: 30,
              // margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                  border: Border(
                bottom: _focusCredits.hasFocus
                    ? BorderSide(
                        color: isCreditsValide
                            ? Color(0xff4562a7)
                            : Color(0xffce2029),
                      )
                    : BorderSide(
                        color:
                            isCreditsValide ? Colors.white : Color(0xffce2029)),
              )),
              child: TextFormField(
                controller: _controller_Credits,
                // autofocus: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                // focusNode: _focusCredits,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff4562a7),
                ),
                maxLines: 1,
                onChanged: (val) {
                  setState(() {
                    if (val.isNotEmpty) {
                      int? va;
                      try {
                        va = int.parse(val);
                      } catch (error) {
                        va = -1;
                      }
                      allSemesters2[widget.index][1] = va;
                    } else {
                      allSemesters2[widget.index][1] = null;
                    }

                    widget.callBackchanged();
                    validationMethod();
                  });
                },

                decoration: InputDecoration(
                  // errorText: _errorCredits,
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 3),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  hintText: 'Credits',
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Colors.transparent)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Colors.transparent)),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 0),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white))),
              child: Text(
                'Semester ${widget.index + 1}',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
