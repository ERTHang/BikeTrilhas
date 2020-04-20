import 'package:mobx/mobx.dart';

part 'display_controller.g.dart';

class DisplayController = _DisplayControllerBase with _$DisplayController;

abstract class _DisplayControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
