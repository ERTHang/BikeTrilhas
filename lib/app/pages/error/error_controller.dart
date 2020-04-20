import 'package:mobx/mobx.dart';

part 'error_controller.g.dart';

class ErrorController = _ErrorControllerBase with _$ErrorController;

abstract class _ErrorControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
