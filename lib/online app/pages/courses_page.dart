import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
            body: Center(child: NavigationExample()),
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

class NavigationExample extends StatelessWidget {
  final TextEditingController _typeAheadController = TextEditingController();
  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          // suggestionBoxController.close();
        },
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _typeAheadController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Enter Course',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Colors.transparent)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Colors.transparent)),
                ),
              ),
              suggestionsCallback: (pattern) async {
                return CitiesService.getSuggestions(pattern);
              },
              itemBuilder: (context, String suggestion) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(suggestion,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff4562a7),
                        )),
                  ),
                );
              },
              suggestionsBoxController: suggestionBoxController,
              onSuggestionSelected: (String suggestion) {
                this._typeAheadController.text = suggestion;
              },
              itemSeparatorBuilder: (context, index) {
                return Divider(
                  color: Colors.white,
                );
              },
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                constraints: BoxConstraints(
                  maxHeight: 250,
                ),
                borderRadius: BorderRadius.circular(10.0),
                elevation: 8.0,
                color: Color(0xffb8c8d1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormExample extends StatefulWidget {
  @override
  _FormExampleState createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  String? _selectedCity;

  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // close the suggestions box when the user taps outside of it
      onTap: () {
        suggestionBoxController.close();
      },
      child: Container(
        // Add zero opacity to make the gesture detector work
        color: Colors.amber.withOpacity(0),
        // Create the form for the user to enter their favorite city
        child: Form(
          key: this._formKey,
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                Text('What is your favorite city?'),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(labelText: 'City'),
                    controller: this._typeAheadController,
                  ),
                  suggestionsCallback: (pattern) {
                    return CitiesService.getSuggestions(pattern);
                  },
                  itemBuilder: (context, String suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  itemSeparatorBuilder: (context, index) {
                    return Divider();
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (String suggestion) {
                    this._typeAheadController.text = suggestion;
                  },
                  suggestionsBoxController: suggestionBoxController,
                  validator: (value) =>
                      value!.isEmpty ? 'Please select a city' : null,
                  onSaved: (value) => this._selectedCity = value,
                ),
                Spacer(),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (this._formKey.currentState!.validate()) {
                      this._formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Your Favorite City is ${this._selectedCity}'),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CitiesService {
  static final List<String> cities = [
    'Beirut',
    'Damascus',
    'San Fransisco',
    'Rome',
    'Los Angeles',
    'Madrid',
    'Bali',
    'Barcelona',
    'Paris',
    'Bucharest',
    'New York City',
    'Philadelphia',
    'Sydney',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(cities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
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
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: TextFieldAutoComplete(
        suggestions: list,
        key: _textFieldAutoCompleteKey,
        clearOnSubmit: false,
        decoration: InputDecoration(contentPadding: EdgeInsets.only(right: 10)),
        controller: _controller_Name,
        textChanged: (value) {
          print('###############################################');
          print(value);
        },
        itemSubmitted: (String item) {
          _controller_Name.text = item;
          print('###############################################');
          print('selected breed $item');
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
            color: Colors.grey,
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
      ),
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
