import 'package:mobx/mobx.dart';

part 'drawer_controller.g.dart';

class DrawerClassController = _DrawerControllerBase with _$DrawerClassController;

abstract class _DrawerControllerBase with Store {
  @observable
  int value = 0;
}
