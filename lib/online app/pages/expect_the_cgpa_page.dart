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
  TextEditingController _cgga_total = TextEditingController();
  TextEditingController _credits_total = TextEditingController();
  double gpaMustHave = 0.0000;
  int creditsMustHave = 0;

  void calcPredictCGPA() {
    String currCGPA = _contr_curr_CGPA.text;
    String currCredits = _contr_curr_credits.text;
    String cgga_total = _cgga_total.text;
    String credits_total = _credits_total.text;
    if (currCredits.isNotEmpty &&
        currCGPA.isNotEmpty &&
        credits_total.isNotEmpty &&
        cgga_total.isNotEmpty) {
      try {
        double totalPoints =
            double.parse(cgga_total) * int.parse(credits_total);
        double currrentPoints = double.parse(currCGPA) * int.parse(currCredits);
        int credits = int.parse(credits_total) - int.parse(currCredits);
        setState(() {
          if ((double.parse(currCredits) +
                  double.parse(credits_total) +
                  double.parse(currCGPA) +
                  double.parse(cgga_total)) ==
              0) {
            print('herrrrrrrrrrrrrrrrrrrrr');
            gpaMustHave = 0.000;
            creditsMustHave = 0;
          } else {
            gpaMustHave = (totalPoints - currrentPoints) / (credits);
            creditsMustHave = credits;
          }

          if (gpaMustHave > 4.0) {
            gpaMustHave = 4.0;
          }
        });
      } catch (error) {
        print(error);
        setState(() {
          gpaMustHave = 0.000;
          creditsMustHave = 0;
        });
      }
    } else {
      setState(() {
        gpaMustHave = 0.000;
        creditsMustHave = 0;
      });
    }
  }

  String? get _totalCreditsError {
    String currCredits = _contr_curr_credits.text;
    String credits_total = _credits_total.text;
    try {
      if (currCredits.isNotEmpty && credits_total.isNotEmpty) {
        if (int.parse(credits_total) < int.parse(currCredits)) {
          return 'must be greater than the current Credits';
        }
      }
    } catch (e) {
      return 'Invalid field';
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
                                              setState(() {
                                                calcPredictCGPA();
                                              });
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
                                              setState(() {
                                                calcPredictCGPA();
                                              });
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
                                        ' CGPA you want',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff296E85),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                          width: 150,
                                          height: 75,
                                          child: TextField(
                                            controller: _cgga_total,
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
                                              setState(() {
                                                calcPredictCGPA();
                                              });
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
                                        'Total Credits ',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff296E85),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                          width: 150,
                                          height: 75,
                                          child: TextField(
                                            controller: _credits_total,
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
                                              setState(() {
                                                calcPredictCGPA();
                                              });
                                            },
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4562a7)),
                                              ),
                                              hintText: 'Credits',
                                              errorText: _totalCreditsError,
                                              errorMaxLines: 2,
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
                                'You should have Semester with GPA ${gpaMustHave.toStringAsFixed(4)} and Credits $creditsMustHave',
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle(
                                  wordSpacing: 5,
                                  fontSize: 20,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              CircularPercentIndicator(
                                radius: 80,
                                percent: (gpaMustHave / 4),
                                lineWidth: 10,
                                center: Text(
                                  '${gpaMustHave.toStringAsFixed(4)}',
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
