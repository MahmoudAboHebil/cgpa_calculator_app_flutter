import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
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

  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();
  FocusNode _focus = FocusNode();

  void _onFocusChange() {
    print('############################');
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    setState(() {
      valide = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();

    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
  }

  bool valide = true;
  @override
  Widget build(BuildContext context) {
    return Container(
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
                    Stack(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.white30, width: 1),
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
                    Form(
                      key: _formKey,
                      autovalidateMode: valide
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 10),
                            child: TextFormField(
                              focusNode: _focus,
                              controller: _controller1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name or ID ';
                                }
                                return null;
                              },
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 10),
                            child: TextFormField(
                              controller: _controller2,
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xff004d60)),
                              decoration: InputDecoration(
                                hintText: 'Enter your Department(Option)',
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
                            child: TextFormField(
                              controller: _controller3,
                              validator: (value) =>
                                  EmailValidator.validate(value!)
                                      ? null
                                      : "Please enter a valid email",
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 10),
                            child: TextFormField(
                              controller: _controller4,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a Password ';
                                } else if (value.length < 6) {
                                  return 'At least 6 character';
                                }
                                return null;
                              },
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
                        style:
                            TextStyle(color: Color(0xffce2029), fontSize: 15),
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
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                valide = false;
                              });
                              _controller1.clear();
                              _controller2.clear();
                              _controller3.clear();
                              _controller4.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
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
    );
  }
}
