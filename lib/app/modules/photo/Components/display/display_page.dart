import 'dart:io';

import 'package:biketrilhas_modular/app/modules/photo/photo_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class DisplayPage extends StatefulWidget {
  final String title;
  const DisplayPage({Key key, this.title = "Display"}) : super(key: key);

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  PhotoController photoController = Modular.get();
  final TextEditingController nameController = TextEditingController();

  savePicture() async {
    String imagePath = photoController.path;

    final path = join(
      (await getApplicationDocumentsDirectory()).path,
      '${DateTime.now()}.png',
    );

    File(imagePath).copy(path);

    Modular.to.popUntil(ModalRoute.withName('/map'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: savePicture,
        backgroundColor: Colors.blue,
        child: Icon(Icons.send),
      ),
      body: Stack(
        children: <Widget>[
          PhotoView(
            imageProvider: FileImage(File(photoController.path), scale: 1),
            minScale: PhotoViewComputedScale.contained,
          ),
          Positioned(
            bottom: 0,
            child: Container(
              color: Color.fromARGB(80, 80, 80, 80),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: TextField(
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.white),
                  textCapitalization: TextCapitalization.sentences,
                  controller: nameController,
                  cursorRadius: Radius.circular(200),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Adicione uma legenda...',
                      hintStyle: TextStyle(color: Colors.white70)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
