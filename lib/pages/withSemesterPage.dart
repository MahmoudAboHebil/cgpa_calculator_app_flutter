import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class WithSemester extends StatefulWidget {
  final Function callBack;

  WithSemester(this.callBack);

  @override
  State<WithSemester> createState() => _WithSemesterState();
}

List<List> allSemesters = [
  [2.35, 11, '1'],
  [null, null, 'o4'],
  [2.35, 11, '5'],
];

final _keySemester = GlobalKey<AnimatedListState>();
Tween<Offset> _offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));

class _WithSemesterState extends State<WithSemester> {
  bool isChanged = false;

  isValueChanged() {
    setState(() {
      isChanged = true;
    });
  }

  void addSemester() {
    var uuid = Uuid();
    var uniqueId = uuid.v1();

    setState(() {
      allSemesters.add([null, null, uniqueId]);
    });
    int insertIndex =
        allSemesters.isEmpty ? allSemesters.length : allSemesters.length - 1;

    _keySemester.currentState!
        .insertItem(insertIndex, duration: Duration(milliseconds: 300));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      widget.callBack(3.5, 33);
    });

    // _semestersKeys = List.generate(allSemesters.length, (index) {
    //   return GlobalObjectKey<_SemesterWithSGPAState>(index);
    // });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      isChanged;
    });
    return SingleChildScrollView(
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
            AnimatedList(
              shrinkWrap: true,
              key: _keySemester,
              itemBuilder: (context, index, animation) {
                // print(allSemesters);
                return SizeTransition(
                  // key: ObjectKey(allSemesters[index][0].toString()),

                  sizeFactor: animation,
                  key: ObjectKey(allSemesters[index][2]),

                  child: SemesterWithSGPA(
                    index,
                    allSemesters[index][0],
                    allSemesters[index][1],
                    isValueChanged,
                  ),
                );
              },
              initialItemCount: allSemesters.length,
            ),
            Row(
              mainAxisAlignment:
                  isChanged ? MainAxisAlignment.center : MainAxisAlignment.end,
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
                          setState(() {
                            isChanged = false;
                          });
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
    );
  }
}

class SemesterWithSGPA extends StatefulWidget {
  final int index;
  final double? SGPA;
  final int? credits;
  final Function callBackchanged;

  SemesterWithSGPA(this.index, this.SGPA, this.credits, this.callBackchanged,
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

  void deleteSemester() {
    if (allSemesters.length != 1) {
      setState(() {
        allSemesters.removeAt(widget.index);
        widget.callBackchanged();
        // _semestersKeys.removeAt(widget.index);
        // widget.key ==
        //     List.generate(allSemesters.length,
        //         (index) => GlobalObjectKey<FormState>(index));
        _keySemester.currentState!.removeItem(widget.index,
            (context, animation) {
          return SlideTransition(
              position: animation.drive(_offset),
              child: SemesterWithSGPA(
                  widget.index, widget.SGPA, widget.credits, () {}));
        }, duration: Duration(milliseconds: 300));
      });
    }
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
                    // FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      deleteSemester();
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
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
                            allSemesters[widget.index][0] = double.parse(val);
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
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Enter SGPA',
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
                      SizedBox(
                        height: 0.5,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: 70,
              // height: 34,
              height: 28,
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
              child: Column(
                children: [
                  TextFormField(
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
                        allSemesters[widget.index][1] = int.parse(val);

                        widget.callBackchanged();
                        validationMethod();
                      });
                    },

                    decoration: InputDecoration(
                      // errorText: _errorCredits,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
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
                  SizedBox(
                    height: 1,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10),
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
