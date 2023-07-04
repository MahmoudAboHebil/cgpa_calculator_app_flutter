import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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
              body: Container(
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
                                border:
                                    Border.all(color: Colors.white54, width: 5),
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
                                      borderRadius: BorderRadius.circular(100),
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
                                style: TextStyle(color: Colors.white),
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
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();

                          setState(() {
                            pressed = true;
                          });
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
    );
  }
}
