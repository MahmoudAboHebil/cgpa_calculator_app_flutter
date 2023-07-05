import 'package:flutter/services.dart';
import 'package:cgp_calculator/pages/signUp.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cgp_calculator/authServieses.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'HomeWithFireStoreFinal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'forgetPasswordPage.dart';

class Siginin extends StatefulWidget {
  @override
  State<Siginin> createState() => _SigininState();
}

class _SigininState extends State<Siginin> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Container(
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

                  return Content();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Content extends StatefulWidget {
  const Content({Key? key}) : super(key: key);

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final _auth = FirebaseAuth.instance;
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  String email = '';
  String password = '';
  bool remember = true;
  bool pressed = false;
  bool showProgress = false;
  String errorMassage = '';
  void setDataCheckUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (remember) {
      String? em = prefs.getString('email');
      String? pas = prefs.getString('password');
      if (em != null && pas != null) {
        _controller1 = TextEditingController(text: em);
        _controller2 = TextEditingController(text: pas);
        // print(remember);
        // print(_controller1.text);
        // print(_controller2.text);
      }
    }
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
                      Text(
                        errorMassage,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )
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

  void setRememberMy(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (remember) {
      prefs.setString('email', email);
      prefs.setString('password', password);
    }
  }

  void setRememberMyCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? check = prefs.getBool('check');
    if (check == null) {
      prefs.setBool('check', true);
      setState(() {
        remember = true;
      });
    } else {
      setState(() {
        remember = check;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setRememberMyCheck();
    setDataCheckUser();
  }

  String? get _errorText1 {
    var text = _controller1.text;
    if ((text.isEmpty || text.trim().isEmpty) && pressed) {
      return "Please enter an Email";
    } else if (text.isNotEmpty && pressed) {
      return EmailValidator.validate(text)
          ? null
          : "Please enter a valid email";
    }

    return null;
  }

  String? get _errorText2 {
    var text = _controller2.text;

    if ((text.isEmpty || text.trim().isEmpty) && pressed) {
      return 'Please enter a Password ';
    } else if (text.length < 6 && text.isNotEmpty && pressed) {
      return 'At least 6 character';
    }

    return null;
  }

  static Future<bool> checkExist(String docID) async {
    bool exist = false;
    try {
      await FirebaseFirestore.instance
          .doc("UsersInfo/$docID")
          .get()
          .then((doc) {
        exist = doc.exists;
      });
      return exist;
    } catch (e) {
      // If any error
      return false;
    }
  }

  void addUserInfo(String? email, String? name, String? imageURl) async {
    bool isExist = await checkExist('$email');
    if (!isExist) {
      // firstTime
      await FirebaseFirestore.instance.collection('UsersInfo').doc(email).set({
        'email': '$email',
        'name': '$name',
        'image': '$imageURl',
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: Padding(
        padding: EdgeInsets.fromLTRB(35, 50, 35, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome back to',
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
                style: TextStyle(color: Color(0xffce2029), fontSize: 18),
              ),
              Text(
                'to sign in...',
                style: TextStyle(color: Color(0xffce2029), fontSize: 18),
              ),
              SizedBox(
                height: 25,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _controller1,
                      onChanged: (text) {
                        setState(() {
                          _errorText1;
                        });
                      },
                      style: TextStyle(fontSize: 18, color: Color(0xff004d60)),
                      decoration: InputDecoration(
                        hintText: 'Enter Email',
                        errorText: _errorText1,
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: TextField(
                      controller: _controller2,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (text) {
                        setState(() {
                          _errorText2;
                        });
                      },
                      style: TextStyle(fontSize: 18, color: Color(0xff004d60)),
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        errorText: _errorText2,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Switch(
                          value: remember,
                          onChanged: (value) async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            setState(() {
                              remember = value;
                              prefs.setBool('check', value);
                            });
                          },
                          activeColor: Color(0xff4562a7),
                          activeTrackColor: Colors.white,
                          splashRadius: 0),
                      Text(
                        'Remember me',
                        style:
                            TextStyle(color: Color(0xffce2029), fontSize: 15),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgetPassword(),
                          ));
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xffce2029), fontSize: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sign in',
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
                      if (validate1 == null && validate2 == null) {
                        setState(() {
                          pressed = false;
                          email = _controller1.text;
                          password = _controller2.text;
                          showProgress = true;
                        });

                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            setRememberMy(email, password);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePageFin(),
                              ),
                              (route) => true,
                            );
                          }
                          _controller1.clear();
                          _controller2.clear();

                          setState(() {
                            showProgress = false;
                          });
                        } on FirebaseAuthException catch (error) {
                          setState(() {
                            if (error.message ==
                                'There is no user record corresponding to this identifier. The user may have been deleted.') {
                              errorMassage =
                                  'There is no user record with that email';
                            } else {
                              errorMassage = error.message!;
                            }
                            showProgress = false;
                            message();
                          });
                        }

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //       content: Text('Processing Data')),
                        // );
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
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ));
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Color(0xffce2029), fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 230,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'OR | Sign in with',
                  style: TextStyle(color: Color(0xffce2029), fontSize: 18),
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
                      final prov =
                          Provider.of<AuthServer>(context, listen: false);
                      // await prov.googleLogout();
                      setState(() {
                        showProgress = true;
                      });
                      await prov.googleLogin();
                      if (prov.gUser != null) {
                        addUserInfo(prov.gUser!.email.toLowerCase(),
                            prov.gUser!.displayName, prov.gUser!.photoUrl);
                      }

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
    );
  }
}
