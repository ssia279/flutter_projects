import 'package:books/services/books_helper.dart';
import 'package:books/ui/list_view.dart';
import 'package:books/ui/table_view.dart';
import 'package:flutter/material.dart';

import 'models/book.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  BooksHelper? helper;
  List<dynamic>? books;
  int? booksCount;
  TextEditingController? txtSearchController;

  @override
  void initState() {
    helper = BooksHelper();
    txtSearchController = TextEditingController();
    initialize();
    super.initState();
  }

  Future initialize() async {
    books = await helper?.getBooks('Flutter');
    setState(() {
      booksCount = books?.length;
      books = books;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = false;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Books'),
        actions: [
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: (isSmall == true) ? Icon(Icons.home) : Text('Home'),
            ),
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: (isSmall == true) ? Icon(Icons.star) : Text('Favorites'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: 200,
                  child: TextField(
                    controller: txtSearchController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (text) {
                      helper?.getBooks(text).then((value) {
                        setState(() {
                          books = value;
                        });
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => helper?.getBooks(txtSearchController!.text),
                  ),
                ),
              ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: (isSmall == true) ? BooksList(books!, false) : BooksTable(books!, false)
            ),
          ],
        ),
      ),
    );
  }

}