import 'dart:io';

import 'package:biketrilhas_modular/app/modules/photo/photo_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'display_controller.g.dart';

class DisplayController = _DisplayControllerBase with _$DisplayController;

abstract class _DisplayControllerBase with Store {
  final PhotoController photoController;

  _DisplayControllerBase(this.photoController);

  @action
  savePicture() async {
    String imagePath = photoController.path;

    final path = join(
      (await getApplicationDocumentsDirectory()).path,
      '${DateTime.now()}.png',
    );

    File(imagePath).copy(path);

    photoController.dispose();

    Modular.to.popUntil(ModalRoute.withName('/map'));
  }
}
