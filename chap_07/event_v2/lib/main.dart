import 'package:event_v2/views/event_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    testData();
    return MaterialApp(
      title: 'Events',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: EventScreen(),
    );
  }

  Future testData() async {
    CollectionReference data = FirebaseFirestore.instance.collection('event_details');
    var result = await data.get();
    //.then((value) => value.docs.forEach((element) {print(element.id); })); // this prints the document id.

  }

}