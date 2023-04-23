import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffb8c8d1),
      child: SafeArea(
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
                    style: TextStyle(color: Color(0xffce2029), fontSize: 18),
                  ),
                  Text(
                    'to sign up...',
                    style: TextStyle(color: Color(0xffce2029), fontSize: 18),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 70,
                    width: 70,
                    padding: EdgeInsets.only(top: 5, left: 5),
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage('images/user3.png'),
                          fit: BoxFit.cover),
                      border: Border.all(color: Colors.white30, width: 1),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white60,
                      size: 24,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff004d60)),
                            decoration: InputDecoration(
                              hintText: 'Name or Student ID',
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff004d60)),
                            decoration: InputDecoration(
                              hintText: 'Enter your Department',
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff004d60)),
                            decoration: InputDecoration(
                              hintText: 'Enter Email',
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff004d60)),
                            decoration: InputDecoration(
                              hintText: 'Enter Password',
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
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Already have account?',
                      style: TextStyle(color: Color(0xffce2029), fontSize: 15),
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
                        onTap: () {
                          print('Pressed');
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
                      style: TextStyle(color: Color(0xffce2029), fontSize: 18),
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
    );
  }
}
