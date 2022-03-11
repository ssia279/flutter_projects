import 'dart:io';

import 'package:flutter/material.dart';
import 'package:treasure_mapp/main.dart';
import 'package:treasure_mapp/repositories/dbHelper.dart';

import '../models/place.dart';

class PictureScreen extends StatelessWidget {
  final String imagePath;
  final Place place;

  PictureScreen(this.imagePath, this.place);

  @override
  Widget build(BuildContext context) {
    DbHelper helper = DbHelper();
    return Scaffold(
      appBar: AppBar(title: Text('Save picture'),
        actions: [IconButton(
            onPressed: () {
              place.image = imagePath;
              helper.insertPlace(place);
              MaterialPageRoute route = MaterialPageRoute(builder: (context) => MainMap());
              Navigator.push(context, route);
            },
            icon: Icon(Icons.save))],
      ),
      body: Container(
        child: Image.file(File(imagePath)),
      ),
    );
  }

}