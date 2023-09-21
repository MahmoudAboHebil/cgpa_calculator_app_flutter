import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MyCustomAppBar extends StatelessWidget {
  final double height;
  final double cgpa;
  final int earnCredit;
  final int totalCredit;

  MyCustomAppBar(this.height, this.cgpa, this.earnCredit, this.totalCredit);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.only(top: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Color(0xff4562a7),
                    size: 28,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              AppBar(
                cgpa,
                earnCredit,
                totalCredit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  final double cgpa;
  final int earnCredit;
  final int totalCredit;
  AppBar(this.cgpa, this.earnCredit, this.totalCredit);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'CGPA',
                                style: TextStyle(
                                    color: Color(0xff4562a7),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              '${cgpa.toStringAsFixed(4)}',
                              style: TextStyle(
                                  color: Color(0xff4562a7),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      LinearPercentIndicator(
                        width: 230,
                        lineHeight: 15,
                        percent: cgpa / 4,
                        backgroundColor: Colors.grey.shade400,
                        progressColor: Color(0xff4562a7),
                        animation: true,
                        barRadius: Radius.circular(10),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 0, top: 20),
                      child: Text(
                        'Total Credits',
                        style: TextStyle(
                          color: Color(0xff004d60),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Text(
                        '${earnCredit} / ${totalCredit}',
                        style: TextStyle(
                          color: Color(0xff004d60),
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
