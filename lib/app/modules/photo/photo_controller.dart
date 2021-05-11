import 'package:biketrilhas_modular/app/modules/photo/Components/loader/loader_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'photo_controller.g.dart';

class PhotoController = _PhotoControllerBase with _$PhotoController;

abstract class _PhotoControllerBase with Store {
  CameraController controller;
  String path;

  final LoaderController loaderController;
  _PhotoControllerBase(this.loaderController);

  @observable
  ObservableFuture<void> initializeControllerFuture;

  @action
  init() async {
    controller =
        CameraController(loaderController.camera, ResolutionPreset.max);

    initializeControllerFuture = controller.initialize().asObservable();
  }

  @action
  void dispose() {
    controller.dispose();
  }

  @action
  takeShot() async {
    try {
      await initializeControllerFuture;

      path = (await controller.takePicture()).path;

      Modular.to.pushNamed('/fotos/display');
    } catch (e) {
      print(e);
    }
  }
}
