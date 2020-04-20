import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

class CameraLoaderPage extends StatefulWidget {
  final String title;
  const CameraLoaderPage({Key key, this.title = "CameraLoader"})
      : super(key: key);

  @override
  _CameraLoaderPageState createState() => _CameraLoaderPageState();
}

class _CameraLoaderPageState extends State<CameraLoaderPage> {
  ReactionDisposer disposer;

  Future<List<CameraDescription>> _futureCameras;

  @override
  void initState() {
    super.initState();
    disposer = autorun(
      (_) {
        super.initState();
        WidgetsFlutterBinding.ensureInitialized();

        _futureCameras = availableCameras().then((cameras) {
          Navigator.of(context).pushReplacementNamed('/camera', arguments: cameras.first);
          return cameras;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    disposer();
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
