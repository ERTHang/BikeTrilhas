import 'package:mobx/mobx.dart';

part 'camera_loader_controller.g.dart';

class CameraLoaderController = _CameraLoaderControllerBase
    with _$CameraLoaderController;

abstract class _CameraLoaderControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
