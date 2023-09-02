import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:flutter_textfield_autocomplete/flutter_textfield_autocomplete.dart';
import 'package:textfield_search/textfield_search.dart';

List<List<String>> courseDataList = [
  [
    'courseName1',
    'Credit1',
    'Id1',
  ],
  [
    'courseName2',
    'Credit2',
    'Id2',
  ],
  [
    'courseName',
    'Credit3',
    'Id3',
  ],
];

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffb8c8d1),
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
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
            backgroundColor: Color(0xffb8c8d1),
            body: Center(child: search()),
            // body: ListView.builder(
            //   shrinkWrap: true,
            //   itemCount: courseDataList.length,
            //   itemBuilder: (context, index) => CourseData(
            //       courseDataList[index][0],
            //       courseDataList[index][1],
            //       courseDataList[index][2]),
            // ),
          ),
        ),
      ),
    );
  }
}

class SearchFieldSample extends StatefulWidget {
  const SearchFieldSample({Key? key}) : super(key: key);

  @override
  State<SearchFieldSample> createState() => _SearchFieldSampleState();
}

class _SearchFieldSampleState extends State<SearchFieldSample> {
  int suggestionsCount = 12;
  final focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    final suggestions = List.generate(
        suggestionsCount, (index) => 'suggestionsuggestionsuggestion $index');
    return Center(
      child: SizedBox(
        width: 150,
        child: SearchField(
          searchStyle: TextStyle(color: Color(0xff004d60)),
          suggestionItemDecoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white))),
          scrollbarAlwaysVisible: false,
          onSearchTextChanged: (query) {
            final filter = suggestions
                .where((element) =>
                    element.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return filter
                .map((e) => SearchFieldListItem<String>(e,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0),
                      child: TextFieldReadOnly(e, 150),
                    )))
                .toList();
          },
          key: const Key('searchfield'),
          itemHeight: 50,
          searchInputDecoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            hintText: 'Enter Course',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 0, color: Colors.transparent)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 0, color: Colors.transparent)),
          ),
          suggestionsDecoration: SuggestionDecoration(
            padding: const EdgeInsets.all(0),
            color: Color(0xffb8c8d1),
          ),
          suggestions: suggestions
              .map((e) => SearchFieldListItem<String>(e,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: TextFieldReadOnly(e, 150),
                  )))
              .toList(),
          focusNode: focus,
          suggestionState: Suggestion.expand,
          onSuggestionTap: (SearchFieldListItem<String> x) {
            focus.unfocus();
          },
        ),
      ),
    );
  }
}

class search extends StatefulWidget {
  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  final _controller_Name = TextEditingController();
  final scrollController = ScrollController();
  GlobalKey<TextFieldAutoCompleteState<String>> _textFieldAutoCompleteKey =
      GlobalKey();

  @override
  Widget build(BuildContext context) {
    return TextFieldAutoComplete(
      suggestions: list,
      key: _textFieldAutoCompleteKey,
      clearOnSubmit: false,
      controller: _controller_Name,
      itemSubmitted: (String item) {
        print('###############################################');
        print('selected breed $item');
        _controller_Name.text = item;
        print('selected breed 2 ${item}');
      },
      itemSorter: (String a, String b) {
        return a.compareTo(b);
      },
      itemFilter: (String item, query) {
        return item.toLowerCase().startsWith(query.toLowerCase());
      },
      itemBuilder: (context, String item) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Text(
                item,
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        );
      },
    );
  }
}

List<String> list = [
  'courseName1courseName1',
  'courseName2',
  'courseName3',
  'courseName1',
  'courseName2',
  'courseName5',
  'courseName6',
  'courseName7',
  'courseName9',
];

class CourseData extends StatelessWidget {
  CourseData(this.courseName, this.credit, this.id);
  final String courseName;
  final String credit;
  final String id;
  late final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextFieldReadOnly(courseName, 150),

          // TextFieldReadOnly(credit, 60),
          // TextFieldReadOnly(id, 100),
        ],
      ),
    );
  }
}

class TextFieldReadOnly extends StatelessWidget {
  TextFieldReadOnly(this.title, this.width);
  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: width,
      child: TextField(
        controller: TextEditingController(text: title),
        textAlign: TextAlign.center,
        readOnly: true,
        style: TextStyle(
          fontSize: 18,
          color: Color(0xff004d60),
        ),
        onChanged: (value) {},
        maxLines: 1,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent)),
        ),
      ),
    );
  }
}
