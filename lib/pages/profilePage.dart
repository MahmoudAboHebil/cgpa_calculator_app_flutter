import 'dart:io';
import 'package:cgp_calculator/pages/HomeWithFireStoreFinal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'welcome.dart';

class Profile extends StatefulWidget {
  String email = '';
  String name = '';
  String imageURL = '';

  Profile(this.email, this.name, this.imageURL);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
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
  bool showSpinner = false;
  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController(text: widget.name);
  }

  String? get _errorText1 {
    var text = _controller1.text;
    if ((text.isEmpty || text.trim().isEmpty) && pressed) {
      return 'Please enter your name or ID ';
    }

    return null;
  }

  void addUserInfo(String? email, String? name, String? imageURl) async {
    await FirebaseFirestore.instance.collection('UsersInfo').doc(email).set({
      'email': '$email',
      'name': '$name',
      'image': '$imageURl',
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
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
                                                pickImage(ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                            ),
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
                        TextField(
                          controller: _controller2,
                          onChanged: (text) {
                            setState(() {
                              // _errorText2;
                            });
                          },
                          style: TextStyle(fontSize: 20, color: Colors.white),
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
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
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
                              if (image != null ||
                                  _controller1.text != widget.name) {
                                addUserInfo(widget.email, _controller1.text,
                                    widget.imageURL);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WelcomePage(),
                                  ),
                                  (route) => true,
                                );
                              } else {
                                Navigator.pop(context);
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
    );
  }
}
