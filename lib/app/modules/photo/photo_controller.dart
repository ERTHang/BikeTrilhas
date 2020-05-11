import 'package:biketrilhas_modular/app/modules/photo/Components/display/display_controller.dart';
import 'package:biketrilhas_modular/app/modules/photo/Components/loader/loader_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'photo_controller.g.dart';

class PhotoController = _PhotoControllerBase with _$PhotoController;

abstract class _PhotoControllerBase with Store {
  CameraController controller;
  LoaderController loaderController = Modular.get<LoaderController>();
  String path;

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
      path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      await controller.takePicture(path);


      Modular.to.pushNamed('/photo/display');
    } catch (e) {
      print(e);
    }
  }
}
