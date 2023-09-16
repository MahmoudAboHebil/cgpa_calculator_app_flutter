import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../online app/auth_servieses.dart';
import '../online app/pages/expect_the_cgpa_page.dart';
import '../online app/pages/home_with_firestore_page.dart';
import '../online app/pages/profile_page.dart';
import '../online app/pages/review_page.dart';
import '../online app/pages/sign_in_page.dart';

Duration _kDuration = Duration(milliseconds: 300);
Curve _kCurve = Curves.ease;

class MyNavigationDrawer extends StatefulWidget {
  PageController pageViewController;

  MyNavigationDrawer(this.pageViewController);

  @override
  State<MyNavigationDrawer> createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  String email = '';
  String name = '';
  String imageURL = '';
  String division = '';
  String department = '';
  bool collageOption = false;
  bool departmentOption = false;

  CollectionReference? _usersInfo;

  @override
  void initState() {
    super.initState();
    setState(() {
      _usersInfo = FirebaseFirestore.instance.collection('UsersInfo');
    });
  }

  void setChanges(bool collageOption, bool departmentOption) async {
    await FirebaseFirestore.instance.collection('UsersInfo').doc(email).update({
      'departmentOption': departmentOption,
      'divisionOption': collageOption,
    });
  }

  Future showImageDealog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        contentPadding: EdgeInsets.all(0),
        alignment: Alignment.center,
        content: Container(
          height: 300,
          width: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageURL,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget headerContent() {
    if (_usersInfo != null && loggedInUser != null) {
      return StreamBuilder(
        stream: _usersInfo!.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              final DocumentSnapshot userInfo = snapshot.data!.docs[i];
              if (userInfo['email'] == loggedInUser!.email) {
                Future.delayed(Duration.zero, () {
                  setState(() {
                    email = userInfo['email'];
                    name = userInfo['name'];

                    imageURL = userInfo['image'];
                    division = userInfo['division'];
                    department = userInfo['department'];
                    collageOption = userInfo['divisionOption'];
                    departmentOption = userInfo['departmentOption'];
                  });
                });
              }
            }
            // showSpinner = false;
          }

          return name.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imageURL.isEmpty
                        ? Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                    color: Color(0xff4562a7),
                                    // Color(0xff4562a7)
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(200)),
                                    border: Border.all(
                                        color: Colors.white54, width: 4)),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  'images/user3.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                          )
                        : Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                    color: Color(0xff4562a7),
                                    // Color(0xff4562a7)
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(200)),
                                    border: Border.all(
                                        color: Colors.white54, width: 4)),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  imageURL,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      division,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    'Loading .... ',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                );
        },
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 250,
              color: Color(0xff4562a7),
              child: headerContent(),
              padding: EdgeInsets.all(10),
            ),
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.home_outlined),
                    title: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeWithFireStorePage(),
                              ));
                        },
                        child: Text('Home')),
                  ),
                  ListTile(
                    leading: Icon(Icons.school_sharp),
                    title: GestureDetector(
                        onTap: () async {
                          Scaffold.of(context).closeDrawer();
                          widget.pageViewController
                              .nextPage(duration: _kDuration, curve: _kCurve);
                        },
                        child: Text('With Semester')),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.lightbulb_rounded,
                    ),
                    title: GestureDetector(
                        onTap: () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExpectTheCGPAPage(),
                            ),
                          );
                        },
                        child: Text('Fast')),
                  ),
                  ListTile(
                    leading: Icon(Icons.reviews),
                    title: GestureDetector(
                        onTap: () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewPage(allSemesters),
                            ),
                          );
                        },
                        child: Text('Review')),
                  ),
                  ListTile(
                    leading: Icon(Icons.person_rounded),
                    title: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(email, name,
                                    imageURL, division, department),
                              ));
                        },
                        child: Text('Profile')),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout_outlined),
                    title: GestureDetector(
                      onTap: () async {
                        final prov =
                            Provider.of<AuthServer>(context, listen: false);
                        await prov.googleLogout();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            email.isNotEmpty
                ? Container(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            height: 18,
                            width: 18,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              border: Border.all(color: Colors.grey, width: 2),
                            ),
                            child: Container(
                                height: 10,
                                width: 10,
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: collageOption
                                      ? Colors.green
                                      : Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                )),
                          ),
                          title: GestureDetector(
                            onTap: () {
                              setState(() {
                                collageOption = !collageOption;
                                setChanges(collageOption, departmentOption);
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomeWithFireStorePage(),
                                  ));
                            },
                            child: Text('Enable Collage System'),
                          ),
                        ),
                        ListTile(
                          leading: Container(
                            height: 18,
                            width: 18,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              border: Border.all(color: Colors.grey, width: 2),
                            ),
                            child: Container(
                                height: 10,
                                width: 10,
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: departmentOption
                                      ? Colors.green
                                      : Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                )),
                          ),
                          title: GestureDetector(
                            onTap: () {
                              setState(() {
                                departmentOption = !departmentOption;
                                setChanges(collageOption, departmentOption);
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomeWithFireStorePage(),
                                  ));
                            },
                            child: Text('Enable department System'),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
