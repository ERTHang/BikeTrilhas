import 'package:mobx/mobx.dart';

part 'marker_controller.g.dart';

class MarkerController = _MarkerControllerBase with _$MarkerController;

abstract class _MarkerControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
