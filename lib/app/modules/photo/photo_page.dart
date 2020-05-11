import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'photo_controller.dart';

class PhotoPage extends StatefulWidget {
  final String title;
  const PhotoPage({Key key, this.title = "Photo"}) : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends ModularState<PhotoPage, PhotoController> {
  void initState() {
    super.initState();
    controller.init();
  }

  void dispose() {
    controller.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          if (controller.initializeControllerFuture.error != null) {
            return Center(
              child: Text('Erro'),
            );
          }
          if (controller.initializeControllerFuture == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return CameraPreview(controller.controller);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        elevation: 5,
        onPressed: () {
          controller.takeShot();
        },
      ),
    );
  }
}
