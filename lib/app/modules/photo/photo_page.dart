import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'photo_controller.dart';

class PhotoPage extends StatefulWidget {
  final String title;
  final CameraDescription camera;

  const PhotoPage({Key key, this.title = "Photo", this.camera})
      : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends ModularState<PhotoPage, PhotoController> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  String path;

  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller = CameraController(widget.camera, ResolutionPreset.max);

    _initializeControllerFuture = _controller.initialize();
  }

  void dispose() {
    _controller.dispose();
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
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        elevation: 5,
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            await _controller.takePicture(path);

            dispose();

            Navigator.of(context)
                .pushReplacementNamed('/fotos/display', arguments: path);
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
