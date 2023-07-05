import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool showSpinner = false;
  bool pressed = false;
  String massageText = 'Password Reset Email Sent';
  final _controller1 = TextEditingController();
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> message() {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      clipBehavior: Clip.none,
      elevation: 0,
      content: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xff4562a7),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(
          textAlign: TextAlign.center,
          massageText,
          style: TextStyle(fontSize: 18, color: Colors.white),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ));
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        SizedBox(
                          height: 150,
                        ),
                        Text(
                          'Receive an email to',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          'reset your password.',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 30,
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
                                  Icons.email,
                                  size: 28,
                                  color: Colors.white54,
                                ),
                                Text(
                                  'Email',
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
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();

                            setState(() {
                              pressed = true;
                            });
                            if (_errorText1 == null) {
                              try {
                                setState(() {
                                  showSpinner = true;
                                });
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email: _controller1.text.trim());
                                setState(() {
                                  showSpinner = false;
                                });
                                message();
                                Navigator.pop(context);
                              } on FirebaseAuthException catch (error) {
                                setState(() {
                                  if (error.message ==
                                      'There is no user record corresponding to this identifier. The user may have been deleted.') {
                                    massageText =
                                        'There is no user record with that email';
                                  } else {
                                    massageText = error.message!;
                                  }

                                  showSpinner = false;
                                  message();
                                });
                              }
                            }
                          },
                          child: AbsorbPointer(
                            child: Container(
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  // Color(0xff4562a7)
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white54, width: 1)),
                              child: Text(
                                'Reset Password',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
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
    );
  }
}
