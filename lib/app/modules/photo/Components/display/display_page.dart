import 'dart:io';

import 'package:biketrilhas_modular/app/modules/photo/photo_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_view/photo_view.dart';
import 'display_controller.dart';

class DisplayPage extends StatefulWidget {
  final String title;
  const DisplayPage({Key key, this.title = "Display"}) : super(key: key);

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends ModularState<DisplayPage, DisplayController> {
  
  PhotoController photoController = Modular.get<PhotoController>();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.savePicture();
        },
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
