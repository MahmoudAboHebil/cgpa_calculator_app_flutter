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
      body: Center(
        child: DropMenuWithIcon(),
      ),
    );
  }
}

class DropMenuWithIcon extends StatefulWidget {
  const DropMenuWithIcon({Key? key}) : super(key: key);

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
          width: 130,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(bottom: BorderSide(color: Colors.red, width: 2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              selectedValue == null
                  ? Text(
                      '',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      '$selectedValue',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.redAccent,
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
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 14, color: Colors.red),
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
        buttonStyleData: const ButtonStyleData(
          height: 40,
          width: 140,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
