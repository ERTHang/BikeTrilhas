import 'package:mobx/mobx.dart';

part 'photo_controller.g.dart';

class PhotoController = _PhotoControllerBase with _$PhotoController;

abstract class _PhotoControllerBase with Store {}
