import 'dart:io';

import 'package:flutter/material.dart';
import 'package:treasure_mapp/repositories/dbHelper.dart';
import 'package:treasure_mapp/views/camera_screen.dart';

import '../models/place.dart';

class PlaceDialog {
  final txtName = TextEditingController();
  final txtLat = TextEditingController();
  final txtLon = TextEditingController();
  final bool isNew;
  final Place place;

  PlaceDialog(this.place, this.isNew);

  Widget buildDialog(BuildContext context) {
    DbHelper helper = DbHelper();
    txtName.text = place.name;
    txtLat.text = place.lat.toString();
    txtLon.text = place.lon.toString();

    return AlertDialog(
      title: Text('Place'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            TextField(
              controller: txtLat,
              decoration: InputDecoration(hintText: 'Latitude'),
            ),
            TextField(
              controller: txtLon,
              decoration: InputDecoration(hintText: 'Latitude'),
            ),
            (place.image! != '') ? Container(child: Image.file(File(place.image))): Container(),
            IconButton(
                onPressed: () {
              if (isNew) {
                helper.insertPlace(place).then((data){
                  place.id = data!;
                  MaterialPageRoute route = MaterialPageRoute(builder:
                  (context) => CameraScreen(place));
                  Navigator.push(context, route);
                });
              } else {
                MaterialPageRoute route = MaterialPageRoute(builder: (context) => CameraScreen(place));
                Navigator.push(context, route);
              }
            }, icon: Icon(Icons.camera_front)),
            ElevatedButton(onPressed: () {
              place.name = txtName.text;
              place.lat = double.tryParse(txtLat.text)!;
              place.lon = double.tryParse(txtLon.text)!;
              helper.insertPlace(place);
              Navigator.pop(context);
            }, child: Text('Ok'))
          ],
        ),
      ),
    );
  }
}