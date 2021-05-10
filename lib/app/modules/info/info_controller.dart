import 'package:mobx/mobx.dart';

part 'info_controller.g.dart';

class InfoController = _InfoControllerBase with _$InfoController;

abstract class _InfoControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
