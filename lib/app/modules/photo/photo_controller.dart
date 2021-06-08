import 'package:biketrilhas_modular/app/modules/photo/Components/loader/loader_controller.dart';
import 'package:mobx/mobx.dart';

part 'photo_controller.g.dart';

class PhotoController = _PhotoControllerBase with _$PhotoController;

abstract class _PhotoControllerBase with Store {
  String path;

  final LoaderController loaderController;
  _PhotoControllerBase(this.loaderController);
}
