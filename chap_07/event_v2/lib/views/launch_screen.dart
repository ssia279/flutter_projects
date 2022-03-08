import 'package:event_v2/views/login_screen.dart';
import 'package:event_v2/services/authentication.dart';
import 'package:event_v2/views/event_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LaunchScreen extends StatefulWidget {

  @override
  _LaunchScreenState createState() {
    return _LaunchScreenState();
  }

}

class _LaunchScreenState extends State<LaunchScreen> {

  @override
  void initState() {
    Authentication auth = Authentication();
    User? currentUser = auth.getUser();
    MaterialPageRoute route;
    if (currentUser != null) {
      route = MaterialPageRoute(builder: (context) => EventScreen(currentUser.uid));
    } else {
      route = MaterialPageRoute(builder: (context) => LoginScreen());
    }
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) { // this line fixed the issue.
      Navigator.pushReplacement(context, route);
    });

    //Navigator.pushReplacement(context, route);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(value: null),),
    );
  }

}