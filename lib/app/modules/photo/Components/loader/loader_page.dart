import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'loader_controller.dart';

class LoaderPage extends StatefulWidget {
  final String title;
  const LoaderPage({Key key, this.title = "Loader"}) : super(key: key);

  @override
  _LoaderPageState createState() => _LoaderPageState();
}

class _LoaderPageState extends ModularState<LoaderPage, LoaderController> {
  @override
  void initState() {
    super.initState();

    startCameras();
  }

  CameraDescription camera;

  void startCameras() async {
    final cameras = await availableCameras();
    camera = cameras.first;
    Modular.to.pushReplacementNamed('/fotos/photo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
