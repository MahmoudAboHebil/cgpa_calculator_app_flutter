import 'dart:io';
import 'package:cgp_calculator/online%20app/models/courses_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'home_with_firestore_page.dart';
import 'welcome_page.dart';

class ProfilePage extends StatefulWidget {
  String email;
  String name;
  String imageURL;
  String division;
  String department;

  ProfilePage(
      this.email, this.name, this.imageURL, this.division, this.department);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller_div = TextEditingController();
  TextEditingController _controller_dp = TextEditingController();
  SuggestionsBoxController suggestionBoxController_div =
      SuggestionsBoxController();
  SuggestionsBoxController suggestionBoxController_dp =
      SuggestionsBoxController();
  File? image;
  bool imageDelete = false;
  bool showDepartment = false;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick Image: $e');
    }
  }

  Future showImageDealog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        contentPadding: EdgeInsets.all(0),
        content: Container(
          height: 300,
          width: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              image!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  bool pressed = false;
  bool showSpinner = false;
  @override
  void initState() {
    super.initState();
    print(widget.division);
    _controller1 = TextEditingController(text: widget.name);
    _controller_div = TextEditingController(text: widget.division);
    _controller_dp = TextEditingController(text: widget.department);
    setState(() {
      showDepartment = CollegeService.isGlobalDepartmentValidationOK();
      print('222222222222222222222222222222222222222222222');
      print(showDepartment);
    });
  }

  String? get _errorText1 {
    var text = _controller1.text;
    if ((text.isEmpty || text.trim().isEmpty) && pressed) {
      return 'Please enter your name or ID ';
    }

    return null;
  }

  void addUserInfo(String? email, String? name, String? imageURl,
      String? division, String department) async {
    bool depOp = department != widget.department;
    bool divOp = division != widget.division;

    if (depOp && divOp) {
      bool divV = CollegeService.divisions.contains(division);
      bool depV = CollegeService.departments.contains(department);

      await FirebaseFirestore.instance
          .collection('UsersInfo')
          .doc(email)
          .update({
        'email': '$email',
        'name': '$name',
        'image': '$imageURl',
        'division': division ?? '',
        'department': department ?? '',
        'departmentOption': depV,
        'divisionOption': divV,
      });
    } else if (depOp) {
      bool depV = CollegeService.departments.contains(department);
      await FirebaseFirestore.instance
          .collection('UsersInfo')
          .doc(email)
          .update({
        'email': '$email',
        'name': '$name',
        'image': '$imageURl',
        'division': division ?? '',
        'department': department ?? '',
        'departmentOption': depV,
      });
    } else if (divOp) {
      bool divV = CollegeService.divisions.contains(division);

      await FirebaseFirestore.instance
          .collection('UsersInfo')
          .doc(email)
          .update({
        'email': '$email',
        'name': '$name',
        'image': '$imageURl',
        'division': division ?? '',
        'department': department ?? '',
        'divisionOption': divV,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('UsersInfo')
          .doc(email)
          .update({
        'email': '$email',
        'name': '$name',
        'image': '$imageURl',
        'division': division ?? '',
        'department': department ?? '',
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller_div.dispose();
    _controller_dp.dispose();
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
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff3b6b93), Color(0xff384973)],
              ),
            ),
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                backgroundColor: Colors.transparent,
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
                body: ModalProgressHUD(
                  inAsyncCall: showSpinner,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 130,
                                  width: 130,
                                  alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    border: Border.all(
                                        color: Colors.white54, width: 5),
                                  ),
                                ),
                                Positioned(
                                  child: image == null
                                      ? widget.imageURL.isEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Image.asset(
                                                'images/user3.png',
                                                width: 110,
                                                height: 110,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Image.network(
                                                widget.imageURL,
                                                width: 110,
                                                height: 110,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: GestureDetector(
                                            onTap: () {
                                              showImageDealog();
                                            },
                                            child: Image.file(
                                              image!,
                                              width: 110,
                                              height: 110,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                            content: Text(
                                              "Choose image source",
                                              style: TextStyle(
                                                color: Color(0xff004d60),
                                              ),
                                            ),
                                            // alignment: Alignment.center,

                                            actions: [
                                              TextButton(
                                                child: Text("Camera",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff4562a7))),
                                                onPressed: () {
                                                  pickImage(ImageSource.camera);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                child: Text("Gallery",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff4562a7))),
                                                onPressed: () {
                                                  pickImage(
                                                      ImageSource.gallery);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              widget.imageURL.isNotEmpty ||
                                                      image != null
                                                  ? SizedBox(
                                                      width: 20,
                                                    )
                                                  : SizedBox(),
                                              widget.imageURL.isNotEmpty ||
                                                      image != null
                                                  ? TextButton(
                                                      child: Text("delete",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xffce2029))),
                                                      onPressed: () {
                                                        setState(() {
                                                          imageDelete = true;
                                                          image = null;
                                                          widget.imageURL = '';
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  : SizedBox()
                                            ]),
                                      );
                                    },
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: _controller1,
                            onChanged: (text) {
                              setState(() {
                                _errorText1;
                              });
                            },
                            style: TextStyle(fontSize: 20, color: Colors.white),
                            decoration: InputDecoration(
                              errorText: _errorText1,
                              label: Row(
                                children: [
                                  Icon(
                                    Icons.person_rounded,
                                    size: 28,
                                    color: Colors.white54,
                                  ),
                                  Text(
                                    'Name',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )
                                ],
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                              controller: _controller_div,
                              decoration: InputDecoration(
                                // errorText: _errorText2,
                                label: Row(
                                  children: [
                                    Icon(
                                      Icons.school_rounded,
                                      size: 28,
                                      color: Colors.white54,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'division (شعبة)',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    )
                                  ],
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white54,
                                  ),
                                ),
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return CollegeService.divisions;
                            },
                            itemBuilder: (context, String suggestion) {
                              return Container(
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
                              );
                            },
                            suggestionsBoxController:
                                suggestionBoxController_div,
                            onSuggestionSelected: (String suggestion) {
                              setState(() {
                                _controller_div.text = suggestion;
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
                          SizedBox(
                            height: showDepartment ? 10 : 0,
                          ),
                          showDepartment
                              ? TypeAheadFormField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                    controller: _controller_dp,
                                    decoration: InputDecoration(
                                      // errorText: _errorText2,
                                      label: Row(
                                        children: [
                                          Icon(
                                            Icons.school_rounded,
                                            size: 28,
                                            color: Colors.white54,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Department',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          )
                                        ],
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    return CollegeService.departments;
                                  },
                                  itemBuilder: (context, String suggestion) {
                                    return Container(
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
                                    );
                                  },
                                  suggestionsBoxController:
                                      suggestionBoxController_dp,
                                  onSuggestionSelected: (String suggestion) {
                                    setState(() {
                                      _controller_dp.text = suggestion;
                                    });
                                  },
                                  itemSeparatorBuilder: (context, index) {
                                    return Divider(
                                      color: Colors.white,
                                    );
                                  },
                                  suggestionsBoxDecoration:
                                      SuggestionsBoxDecoration(
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
                              : SizedBox(),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.white))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.email,
                                      size: 20,
                                      color: Colors.white54,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Email',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  '${widget.email}',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                pressed = true;
                              });
                              if (_errorText1 == null) {
                                // add image if it changed
                                setState(() {
                                  showSpinner = true;
                                });
                                if (image != null) {
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceDirImage =
                                      referenceRoot.child('images');
                                  Reference referenceImageToUpload =
                                      referenceDirImage.child(widget.email);
                                  await referenceImageToUpload
                                      .putFile(File(image!.path));
                                  String imageURL = await referenceImageToUpload
                                      .getDownloadURL();
                                  setState(() {
                                    widget.imageURL = imageURL;
                                  });
                                }
                                if (imageDelete) {
                                  try {
                                    Reference referenceRoot =
                                        FirebaseStorage.instance.ref();
                                    Reference referenceDirImage =
                                        referenceRoot.child('images');
                                    Reference referenceImage =
                                        referenceDirImage.child(widget.email);
                                    await referenceImage.delete();
                                  } on FirebaseException catch (error) {
                                    print(
                                        '##########################################################');
                                    print(error.message!);
                                  }
                                }
                                if (image != null ||
                                    _controller1.text != widget.name ||
                                    imageDelete ||
                                    _controller_div.text != widget.division ||
                                    _controller_dp.text != widget.department) {
                                  addUserInfo(
                                    widget.email.toLowerCase(),
                                    _controller1.text,
                                    widget.imageURL,
                                    _controller_div.text,
                                    _controller_dp.text,
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WelcomePage(),
                                    ),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomeWithFireStorePage(),
                                    ),
                                  );
                                }

                                // add department if it changed
                              }
                            },
                            child: AbsorbPointer(
                              child: Container(
                                height: 60,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    // Color(0xff4562a7)
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.white54, width: 1)),
                                child: Icon(
                                  Icons.check_outlined,
                                  color: Colors.white54,
                                  size: 45,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
