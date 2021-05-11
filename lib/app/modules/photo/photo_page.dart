import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    controller.init();
  }

  void dispose() {
    controller.controller.dispose();
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(builder: (_) {
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
        return new Container(
          height: MediaQuery.of(context).size.height,
          child: new CameraPreview(store.controller,
              child: Positioned(
                bottom: 10,
                left: 5,
                right: 5,
                child: FloatingActionButton(
                  child: Icon(Icons.camera),
                  elevation: 5,
                  onPressed: () {
                    controller.takeShot();
                  },
                ),
              )),
        );
      }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
