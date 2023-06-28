import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cgp_calculator/pages/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'HomeWithFireStoreFinal.dart';
import 'package:provider/provider.dart';
import 'package:cgp_calculator/authServieses.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffb8c8d1),
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: Color(0xffb8c8d1),
            body: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return HomePageFin();
                }

                return ContentSignUp();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ContentSignUp extends StatefulWidget {
  @override
  State<ContentSignUp> createState() => _ContentSignUpState();
}

class _ContentSignUpState extends State<ContentSignUp> {
  // final _formKey = GlobalKey<FormState>();
  File? image;

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
  final _auth = FirebaseAuth.instance;
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();
  String nameOrID = '';
  String department = '';
  String email = '';
  String password = '';
  bool showProgress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
  }

  String? get _errorText1 {
    var text = _controller1.text;
    if ((text.isEmpty || text.trim().isEmpty) && pressed) {
      return 'Please enter your name or ID ';
    }

    return null;
  }

  String? get _errorText2 {
    var text = _controller3.text;
    if ((text.isEmpty || text.trim().isEmpty) && pressed) {
      return "Please enter an Email";
    } else if (text.isNotEmpty && pressed) {
      return EmailValidator.validate(text)
          ? null
          : "Please enter a valid email";
    }

    return null;
  }

  String? get _errorText3 {
    var text = _controller4.text;

    if ((text.isEmpty || text.trim().isEmpty) && pressed) {
      return 'Please enter a Password ';
    } else if (text.length < 6 && text.isNotEmpty && pressed) {
      return 'At least 6 character';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Siginin(),
            ));
        return false;
      },
      child: Container(
        color: Color(0xffb8c8d1),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: Color(0xffb8c8d1),
              body: ModalProgressHUD(
                inAsyncCall: showProgress,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(35, 50, 35, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Create Account of',
                          style: TextStyle(
                            color: Color(0xff004d60),
                            fontSize: 20,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'CGPA App!',
                            style: TextStyle(
                              color: Color(0xff004d60),
                              fontSize: 25,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Enter the following details',
                          style:
                              TextStyle(color: Color(0xffce2029), fontSize: 18),
                        ),
                        Text(
                          'to sign up...',
                          style:
                              TextStyle(color: Color(0xffce2029), fontSize: 18),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Stack(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(color: Colors.white30, width: 1),
                              ),
                            ),
                            Positioned(
                              child: image == null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        'images/user3.png',
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: GestureDetector(
                                        onTap: () {
                                          showImageDealog();
                                        },
                                        child: Image.file(
                                          image!,
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ),
                            Positioned(
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
                                        actions: [
                                          TextButton(
                                            child: Text("Camera",
                                                style: TextStyle(
                                                    color: Color(0xff4562a7))),
                                            onPressed: () {
                                              pickImage(ImageSource.camera);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Gallery",
                                                style: TextStyle(
                                                    color: Color(0xff4562a7))),
                                            onPressed: () {
                                              pickImage(ImageSource.gallery);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ]),
                                  );
                                },
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  color: Color(0xff4562a7),
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 10),
                              child: TextField(
                                controller: _controller1,
                                onChanged: (text) {
                                  setState(() {
                                    _errorText1;
                                  });
                                },
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xff004d60)),
                                decoration: InputDecoration(
                                  hintText: 'Name or Student ID',
                                  errorText: _errorText1,
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 18),
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
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 10),
                              child: TextField(
                                controller: _controller2,
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xff004d60)),
                                decoration: InputDecoration(
                                  hintText: 'Enter your Department(Option)',
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 18),
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
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 10),
                              child: TextField(
                                controller: _controller3,
                                onChanged: (text) {
                                  setState(() {
                                    _errorText2;
                                  });
                                },
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xff004d60)),
                                decoration: InputDecoration(
                                  hintText: 'Enter Email',
                                  errorText: _errorText2,
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 18),
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
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 10),
                              child: TextField(
                                controller: _controller4,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                onChanged: (text) {
                                  setState(() {
                                    _errorText3;
                                  });
                                },
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xff004d60)),
                                decoration: InputDecoration(
                                  hintText: 'Enter Password',
                                  errorText: _errorText3,
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 18),
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
                        SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Siginin(),
                                  ));
                            },
                            child: Text(
                              'Already have account?',
                              style: TextStyle(
                                  color: Color(0xffce2029), fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Color(0xff4562a7),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  pressed = true;
                                });
                                var validate1 = _errorText1;
                                var validate2 = _errorText2;
                                var validate3 = _errorText3;
                                if (validate1 == null &&
                                    validate2 == null &&
                                    validate3 == null) {
                                  setState(() {
                                    pressed = false;
                                    nameOrID = _controller1.text;
                                    department = _controller2.text;
                                    email = _controller3.text;
                                    password = _controller4.text;
                                    showProgress = true;
                                  });
                                  try {
                                    final user = await _auth
                                        .createUserWithEmailAndPassword(
                                            email: email, password: password);
                                    if (user != null) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePageFin(),
                                        ),
                                        (route) => true,
                                      );
                                      _controller1.clear();
                                      _controller2.clear();
                                      _controller3.clear();
                                      _controller4.clear();
                                    }
                                    _controller1.clear();
                                    _controller2.clear();
                                  } catch (e) {
                                    print(e);
                                  }
                                  _controller1.clear();
                                  _controller2.clear();
                                  _controller3.clear();
                                  _controller4.clear();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePageFin(),
                                    ),
                                    (route) => true,
                                  );

                                  setState(() {
                                    showProgress = false;
                                  });
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Color(0xff4562a7),
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'OR | Sign in with',
                            style: TextStyle(
                                color: Color(0xffce2029), fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: false,
                              child: Icon(
                                Icons.facebook,
                                color: Color(0xff4562a7),
                                size: 50,
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: Container(
                                height: 43,
                                width: 43,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Color(0xff4562a7),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.twitter,
                                  color: Color(0xffb8c8d1),
                                  size: 25,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final prov = Provider.of<AuthServer>(context,
                                    listen: false);
                                // await prov.googleLogout();
                                setState(() {
                                  showProgress = true;
                                });
                                await prov.googleLogin();
                                setState(() {
                                  showProgress = false;
                                });
                              },
                              child: Container(
                                height: 43,
                                width: 43,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Color(0xff4562a7),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.googlePlusG,
                                  color: Color(0xffb8c8d1),
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
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
