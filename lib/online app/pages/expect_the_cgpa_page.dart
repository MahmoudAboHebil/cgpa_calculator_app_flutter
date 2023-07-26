import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'home_with_firestore_page.dart';

class ExpectTheCGPAPage extends StatefulWidget {
  @override
  State<ExpectTheCGPAPage> createState() => _ExpectTheCGPAPageState();
}

class _ExpectTheCGPAPageState extends State<ExpectTheCGPAPage> {
  TextEditingController _contr_curr_CGPA = TextEditingController();
  TextEditingController _contr_curr_credits = TextEditingController();
  TextEditingController _contr_Semest_GPA = TextEditingController();
  TextEditingController _contr_semest_credits = TextEditingController();
  double newCGPA = 0.0000;

  void calcPredictCGPA() {
    String currCGPA = _contr_curr_CGPA.text;
    String currCredits = _contr_curr_credits.text;
    String semestGPA = _contr_Semest_GPA.text;
    String semestCredits = _contr_semest_credits.text;
    if (currCredits.isNotEmpty &&
        currCGPA.isNotEmpty &&
        semestCredits.isNotEmpty &&
        semestGPA.isNotEmpty) {
      try {
        double currPoints = double.parse(currCGPA) * double.parse(currCredits);
        double semestPoints =
            double.parse(semestGPA) * double.parse(semestCredits);

        setState(() {
          if ((double.parse(currCredits) +
                  double.parse(semestCredits) +
                  double.parse(currCGPA) +
                  double.parse(semestGPA)) ==
              0) {
            print('herrrrrrrrrrrrrrrrrrrrr');
            newCGPA = 0.000;
          } else {
            newCGPA = (currPoints + semestPoints) /
                (double.parse(currCredits) + double.parse(semestCredits));
          }

          if (newCGPA > 4.0) {
            newCGPA = 4.0;
          }
        });
      } catch (error) {
        print(error);
        setState(() {
          newCGPA = 0.000;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    calcPredictCGPA();
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
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              child: Scaffold(
                backgroundColor: Color(0xffb8c8d1),

                // backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.blueGrey,
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
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 350,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 10,
                                  spreadRadius: 0.5)
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Current CGPA',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff296E85),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                          width: 150,
                                          height: 75,
                                          child: TextField(
                                            controller: _contr_curr_CGPA,
                                            textAlign: TextAlign.center,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r"[0-9.]")),
                                            ],
                                            keyboardType: TextInputType.number,
                                            autofocus: false,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xff67B7D1),
                                            ),
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4562a7)),
                                              ),
                                              hintText: 'CGPA',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18),
                                            ),
                                          ))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Current Cradits',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff296E85),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                          width: 150,
                                          height: 75,
                                          child: TextField(
                                            controller: _contr_curr_credits,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            autofocus: false,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xff67B7D1),
                                            ),
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4562a7)),
                                              ),
                                              hintText: 'Cradits',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18),
                                            ),
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Semester GPA',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff296E85),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                          width: 150,
                                          height: 75,
                                          child: TextField(
                                            controller: _contr_Semest_GPA,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r"[0-9.]")),
                                            ],
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            autofocus: false,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xff67B7D1),
                                            ),
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4562a7)),
                                              ),
                                              hintText: 'GPA',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18),
                                            ),
                                          ))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Semester Credits',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff296E85),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                          width: 150,
                                          height: 75,
                                          child: TextField(
                                            controller: _contr_semest_credits,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            autofocus: false,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xff67B7D1),
                                            ),
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4562a7)),
                                              ),
                                              hintText: 'Credits',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18),
                                            ),
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 350,
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 10,
                                  spreadRadius: 0.5)
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 40,
                              ),
                              Text(
                                'CGPA will be ',
                                style: TextStyle(
                                  wordSpacing: 5,
                                  fontSize: 25,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              CircularPercentIndicator(
                                radius: 80,
                                percent: (newCGPA / 4),
                                lineWidth: 10,
                                center: Text(
                                  '${newCGPA.toStringAsFixed(3)}',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                backgroundColor: Colors.grey.shade300,
                                progressColor: Color(0xff4562a7),
                                animation: true,
                              ),
                            ],
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
