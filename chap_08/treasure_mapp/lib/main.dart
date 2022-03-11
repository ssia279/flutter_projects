import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treasure_mapp/repositories/dbHelper.dart';
import 'package:treasure_mapp/test/map_example.dart';
import 'package:treasure_mapp/views/manage_places.dart';
import 'package:treasure_mapp/views/place_dialog.dart';

import 'models/place.dart';


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
        primarySwatch: Colors.blue,
      ),
      home: MainMap(),
    );
  }
}

class MainMap extends StatefulWidget {
  @override
  _MainMapState createState() => _MainMapState();

}

class _MainMapState extends State<MainMap> {
  CameraPosition position = CameraPosition(target: LatLng(41.9028, 12.4964), zoom: 12);
  List<Marker> markers = [];
  Completer<GoogleMapController> _controller = Completer();
  DbHelper? helper;

  @override
  void initState() {
    helper = DbHelper();
    _getCurrentLocation().then((pos) {
      _goToCurrentPosition(pos);
      addMarker(pos, 'currpos', 'You are here!');
    }).catchError((err) => print(err.toString()));
    helper?.insertMockData();
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Treasure Mapp'),
        actions: [
          IconButton(
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(builder: (context) => ManagePlaces());
                Navigator.push(context, route);
              },
              icon: Icon(Icons.list),
          )
        ],
      ),
      body: Container(child: GoogleMap(initialCameraPosition: position,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers),)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_location),
        onPressed: () {
          int here = markers.indexWhere((p) => p.markerId == MarkerId('currpos'));
          Place place;
          if (here == -1) {
            place = Place(0, '', 0, 0, '');
          } else {
            LatLng pos = markers[here].position;
            place = Place(0, '', pos.latitude, pos.longitude, '');
          }
          PlaceDialog dialog = PlaceDialog(place , true);
          showDialog(context: context, builder: (context) => dialog.buildDialog(context));
        },
      ),

    );
  }

  void addMarker(Position? pos, String markerId, String markerTitle) {
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: LatLng(pos!.latitude, pos!.longitude),
      infoWindow: InfoWindow(title: markerTitle),
      icon: (markerId == 'currpos') ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure) :
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
    );
    markers.add(marker);
    setState(() {
      markers = markers;
    });

  }

  Future<Position?> _getCurrentLocation() async {
    bool isGeolocationAvailable = await Geolocator.isLocationServiceEnabled();
    Position? _position;
    if (isGeolocationAvailable) {
      try {
        _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      } catch(error) {
        print(error);
      }
    }

    return _position;
  }

  Future<void> _goToCurrentPosition(Position? position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position!.latitude, position!.longitude), zoom: 10)));
  }

  Future<void> _getData() async {
    await helper?.openDb();
    List<Place> _places = await helper!.getPlaces();
    for (Place p in _places) {
      Position tempPosition = Position.fromMap({'latitude' : p.lat, 'longitude': p.lon,});
      addMarker(tempPosition, p.id.toString(), p.name);
    }
    setState(() {
      markers = markers;
    });
  }


}