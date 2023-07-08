import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WithSemester extends StatefulWidget {
  const WithSemester({super.key});

  @override
  State<WithSemester> createState() => _WithSemesterState();
}

class _WithSemesterState extends State<WithSemester> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
              SemesterWithSGPA(),
              SemesterWithSGPA(),
              GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Color(0xff4562a7),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.white, width: 2)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    child: Text(
                      'Add semester',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SemesterWithSGPA extends StatefulWidget {
  const SemesterWithSGPA({super.key});

  @override
  State<SemesterWithSGPA> createState() => _SemesterWithSGPAState();
}

class _SemesterWithSGPAState extends State<SemesterWithSGPA> {
  final _controller_SGPA = TextEditingController();
  final _controller_Credits = TextEditingController();
  bool isCreditsValide = true;
  bool isSGPAValide = true;
  FocusNode _focusSGPA = FocusNode();
  FocusNode _focusCredits = FocusNode();
  @override
  void initState() {
    _focusSGPA.addListener(_onFocusSGPAChange);
    _focusCredits.addListener(_onFocusCreditsChange);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _focusSGPA.removeListener(_onFocusSGPAChange);
    _focusSGPA.dispose();
    _focusCredits.removeListener(_onFocusCreditsChange);
    _focusCredits.dispose();
  }

  void _onFocusSGPAChange() {
    setState(() {});
    validationMethod();
  }

  void _onFocusCreditsChange() {
    setState(() {});
    validationMethod();
  }

  String? get _errorSGPA {
    var SGPA = _controller_SGPA.text ?? '';
    var credits = _controller_Credits.text ?? '';

    if ((credits.isNotEmpty && credits.trim().isNotEmpty)) {
      if (SGPA.isEmpty || SGPA.trim().isEmpty) {
        return '';
      }
    }
    return null;
  }

  String? get _errorCredits {
    var SGPA = _controller_SGPA.text ?? '';
    var credits = _controller_Credits.text ?? '';

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
                    // widget.CallBackUpdateChange();
                    setState(() {
                      Future.delayed(Duration(milliseconds: 100), () {
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
                      TextField(
                        controller: _controller_SGPA,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.bottom,
                        focusNode: _focusSGPA,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                        ],
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff004d60),
                        ),
                        onChanged: (value) {
                          setState(() {
                            validationMethod();
                          });
                        },
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
                  TextField(
                    controller: _controller_Credits,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    focusNode: _focusCredits,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        validationMethod();
                      });
                    },
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff4562a7),
                    ),
                    maxLines: 1,
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
                'Semester 1',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
