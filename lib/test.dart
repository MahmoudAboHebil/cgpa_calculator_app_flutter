import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb8c8d1),
    );
  }
}

class DropMenuWithIcon extends StatefulWidget {
  @override
  State<DropMenuWithIcon> createState() => _DropMenuWithIconState();
}

class _DropMenuWithIconState extends State<DropMenuWithIcon> {
  String? selectedValue;
  final List<String> items = [
    'A+',
    'b+',
    'c+',
    'd+',
    'e+',
    'f+',
    'g',
    'k+',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Container(
          height: 40,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              selectedValue == null
                  ? Text(
                      '',
                    )
                  : Text(
                      '$selectedValue',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff4562a7),
                      ),
                    ),
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 35,
                  color: Color(0xff4562a7),
                ),
              )
            ],
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 45,
                      height: 80,
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: Colors.white, width: 1),
                      )),
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xff4562a7),
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value as String;
          });
        },
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 70,
          padding: null,
          elevation: 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            color: Color(0xffb8c8d1),
            // boxShadow: [
            //   BoxShadow(color: Colors.white, blurRadius: 5, spreadRadius: 0.2)
            // ],
          ),
          offset: const Offset(20, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(0),
            thumbVisibility: MaterialStateProperty.all(false),
          ),
        ),
        // menuItemStyleData: const MenuItemStyleData(
        //   height: 40,
        //   padding: EdgeInsets.only(left: 14, right: 14),
        // ),
      ),
    );
  }
}
