import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/place.dart';

class CameraScreen extends StatefulWidget {
  final Place place;
  CameraScreen(this.place);

  @override
  _CameraScreenState createState() {
    return _CameraScreenState();
  }

}

class _CameraScreenState extends State<CameraScreen> {
  Place? place;
  CameraController? _controller;
  List<CameraDescription>? cameras;
  CameraDescription? camera;
  Widget? cameraPreview;
  Image? image;
  String? path;

  @override
  void initState() {
    setCamera().then((_) {
      _controller = CameraController(camera!, ResolutionPreset.medium);
    _controller?.initialize().then((snapshot) {
      cameraPreview = Center(child: CameraPreview(_controller!));
      setState(() {
        cameraPreview = cameraPreview;
      });
    });
    }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Take Picture'),
        actions: [
          IconButton(
              onPressed: () async {
                //final path = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
                final XFile? file = await _controller?.takePicture();
                path = file!.path;
              },
              icon: Icon(Icons.camera_alt)),
        ],
      ),
      body: Container(
        child: cameraPreview,
      ),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Future setCamera() async {
    cameras = await availableCameras();
    if (cameras?.length != 0) {
      camera = cameras?.first;
    }
  }

}