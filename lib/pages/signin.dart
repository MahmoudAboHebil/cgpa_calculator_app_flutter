import 'package:flutter/services.dart';
import 'package:cgp_calculator/pages/signUp.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homeWithHive.dart';

class Siginin extends StatefulWidget {
  @override
  State<Siginin> createState() => _SigininState();
}

class _SigininState extends State<Siginin> {
  final _auth = FirebaseAuth.instance;
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  String email = '';
  String password = '';
  bool remember = true;
  bool pressed = false;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }

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
              body: Padding(
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
                        style:
                            TextStyle(color: Color(0xffce2029), fontSize: 18),
                      ),
                      Text(
                        'to sign in...',
                        style:
                            TextStyle(color: Color(0xffce2029), fontSize: 18),
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
                              keyboardType: TextInputType.emailAddress,
                              controller: _controller1,
                              onChanged: (text) {
                                setState(() {
                                  _errorText1;
                                });
                              },
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xff004d60)),
                              decoration: InputDecoration(
                                hintText: 'Enter Email',
                                errorText: _errorText1,
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 18),
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
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              onChanged: (text) {
                                setState(() {
                                  _errorText2;
                                });
                              },
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xff004d60)),
                              decoration: InputDecoration(
                                hintText: 'Enter Password',
                                errorText: _errorText2,
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 18),
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
                                  onChanged: (value) {
                                    setState(() {
                                      remember = value;
                                    });
                                  },
                                  activeColor: Color(0xff4562a7),
                                  activeTrackColor: Colors.white,
                                  splashRadius: 0),
                              Text(
                                'Remember me',
                                style: TextStyle(
                                    color: Color(0xffce2029), fontSize: 15),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpPage(),
                                  ));
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Color(0xffce2029), fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
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
                                });
                                try {
                                  final user =
                                      await _auth.signInWithEmailAndPassword(
                                          email: email, password: password);
                                  if (user != null) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ),
                                      (route) => true,
                                    );
                                  }
                                  _controller1.clear();
                                  _controller2.clear();
                                } catch (e) {
                                  print(e);
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
                        height: 270,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'OR | Sign in with',
                          style:
                              TextStyle(color: Color(0xffce2029), fontSize: 18),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.facebook,
                            color: Color(0xff4562a7),
                            size: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
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
                          SizedBox(
                            width: 20,
                          ),
                          Container(
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
    );
  }
}
